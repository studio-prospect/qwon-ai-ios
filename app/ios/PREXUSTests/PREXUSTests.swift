import XCTest
@testable import PREXUS

final class PREXUSTests: XCTestCase {
    func testSensitiveRequestsStayLocal() {
        let router = DefaultRoutingEngine(
            classifier: HeuristicIntentClassifier(),
            policy: ExecutionPolicy(
                allowsCloudEscalation: true,
                maxCloudContextTokens: 2_048
            )
        )

        let decision = router.route(
            request: RuntimeRequest(
                text: "Analyze this private note",
                modality: .text,
                sensitivity: .localOnly
            )
        )

        XCTAssertEqual(decision.target, .local)
        XCTAssertEqual(decision.tier, .tier2)
    }

    func testRunTurnUsesLocalModelForGeneralChat() async throws {
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: InMemoryAPIKeyStore(),
            memoryStore: InMemoryEpisodicMemoryStore()
        )
        let transcript = [
            ChatMessage(role: .system, content: "PREXUS runtime initialized."),
            ChatMessage(role: .user, content: "Hello")
        ]

        let output = try await runtime.runTurn(
            userText: "Summarize this quickly",
            transcript: transcript
        )

        XCTAssertEqual(output.route.target, .local)
        XCTAssertTrue(output.prompt.contains("Context:"))
        XCTAssertTrue(output.response.contains("Local runtime handled"))
    }

    func testRunTurnEscalatesCodeRequestsToOpenAI() async throws {
        let apiKeyStore = InMemoryAPIKeyStore()
        apiKeyStore.setAPIKey("test-key", for: .openAI)
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: apiKeyStore,
            memoryStore: InMemoryEpisodicMemoryStore()
        )

        let output = try await runtime.runTurn(
            userText: "Review this Swift code for a bug",
            transcript: [ChatMessage(role: .user, content: "Previous context")]
        )

        XCTAssertEqual(output.route.target, .openAI)
        XCTAssertTrue(output.response.contains("openAI handled"))
    }

    func testRunTurnFallsBackLocallyWhenCloudKeyIsMissing() async throws {
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: InMemoryAPIKeyStore(),
            memoryStore: InMemoryEpisodicMemoryStore()
        )

        let output = try await runtime.runTurn(
            userText: "Review this Swift code for a bug",
            transcript: [ChatMessage(role: .user, content: "Previous context")]
        )

        XCTAssertEqual(output.route.target, .openAI)
        XCTAssertTrue(output.response.contains("Local fallback used"))
    }

    func testPersistentMemoryStoreReloadsSavedEpisodes() {
        let suiteName = "PREXUSTests.PersistentMemory.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let createdAt = Date(timeIntervalSince1970: 1_715_900_000)
        let firstStore = PersistentMemoryStore(defaults: defaults)
        firstStore.save(
            EpisodicMemory(
                id: UUID(),
                summary: "Remember the local-first routing decision.",
                sensitivity: .localPreferred,
                createdAt: createdAt
            )
        )

        let reloadedStore = PersistentMemoryStore(defaults: defaults)

        XCTAssertEqual(
            reloadedStore.recent(limit: 10),
            [
                EpisodicMemory(
                    id: reloadedStore.recent(limit: 10)[0].id,
                    summary: "Remember the local-first routing decision.",
                    sensitivity: .localPreferred,
                    createdAt: createdAt
                )
            ]
        )
    }

    func testPersistentMemoryStoreSupportsDeletionAndClear() {
        let suiteName = "PREXUSTests.PersistentMemory.Delete.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let store = PersistentMemoryStore(defaults: defaults)
        let first = EpisodicMemory(
            id: UUID(),
            summary: "Keep the OCR routing local.",
            sensitivity: .localPreferred,
            createdAt: Date(timeIntervalSince1970: 1_715_900_100)
        )
        let second = EpisodicMemory(
            id: UUID(),
            summary: "Escalate only after compression.",
            sensitivity: .escalationAllowed,
            createdAt: Date(timeIntervalSince1970: 1_715_900_200)
        )

        store.save(first)
        store.save(second)
        store.delete(id: first.id)

        XCTAssertEqual(store.all().map(\.summary), ["Escalate only after compression."])

        store.removeAll()

        XCTAssertTrue(store.all().isEmpty)
    }

    @MainActor
    func testAppSettingsStorePersistsConfigAndKeys() {
        let suiteName = "PREXUSTests.Settings.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let apiKeyStore = InMemoryAPIKeyStore()
        let settings = AppSettingsStore(defaults: defaults, apiKeyStore: apiKeyStore)

        settings.config = AppConfig(
            allowsCloudEscalation: false,
            maxCloudContextTokens: 512
        )
        settings.openAIKey = "  openai-test-key  "
        settings.anthropicKey = ""

        let reloaded = AppSettingsStore(defaults: defaults, apiKeyStore: apiKeyStore)

        XCTAssertEqual(
            reloaded.config,
            AppConfig(
                allowsCloudEscalation: false,
                maxCloudContextTokens: 512
            )
        )
        XCTAssertEqual(apiKeyStore.apiKey(for: .openAI), "openai-test-key")
        XCTAssertNil(apiKeyStore.apiKey(for: .anthropic))
    }

    @MainActor
    func testMemoryLibraryViewModelRefreshesAfterMutations() {
        let store = InMemoryEpisodicMemoryStore()
        let viewModel = MemoryLibraryViewModel(memoryStore: store)
        let first = EpisodicMemory(
            id: UUID(),
            summary: "User prefers local-first mode.",
            sensitivity: .localOnly,
            createdAt: Date(timeIntervalSince1970: 1_715_900_300)
        )
        let second = EpisodicMemory(
            id: UUID(),
            summary: "Battery-sensitive tasks should stay lightweight.",
            sensitivity: .localPreferred,
            createdAt: Date(timeIntervalSince1970: 1_715_900_400)
        )

        store.save(first)
        store.save(second)
        viewModel.refresh()

        XCTAssertEqual(
            viewModel.memories.map(\.summary),
            [
                "Battery-sensitive tasks should stay lightweight.",
                "User prefers local-first mode."
            ]
        )

        viewModel.delete(second)
        XCTAssertEqual(viewModel.memories.map(\.summary), ["User prefers local-first mode."])

        viewModel.clearAll()
        XCTAssertTrue(viewModel.memories.isEmpty)
    }
}
