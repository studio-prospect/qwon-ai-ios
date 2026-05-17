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
            memoryStore: InMemoryEpisodicMemoryStore(),
            localModel: MockLocalModelClient(),
            cloudModel: MockCloudModelClient()
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
        XCTAssertEqual(output.execution.mode, .local)
        XCTAssertEqual(output.execution.model, "Mock Local Runtime")
        XCTAssertTrue(output.prompt.contains("Context:"))
        XCTAssertTrue(output.response.contains("Local runtime handled"))
    }

    func testPreviewRouteReroutesToLocalWhenKeyIsMissing() {
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: InMemoryAPIKeyStore(),
            memoryStore: InMemoryEpisodicMemoryStore(),
            localModel: MockLocalModelClient(),
            cloudModel: MockCloudModelClient()
        )

        let route = runtime.previewRoute(
            input: .text("Review this Swift code for a bug", sensitivity: .escalationAllowed)
        )

        XCTAssertEqual(route.target, .local)
        XCTAssertTrue(route.reasonCodes.contains("openai_key_unavailable"))
    }

    func testRunTurnHonorsLocalOnlySensitivityForCodeRequests() async throws {
        let apiKeyStore = InMemoryAPIKeyStore()
        apiKeyStore.setAPIKey("test-key", for: .openAI)
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: apiKeyStore,
            memoryStore: InMemoryEpisodicMemoryStore(),
            localModel: MockLocalModelClient(),
            cloudModel: MockCloudModelClient()
        )

        let output = try await runtime.runTurn(
            input: RuntimeTurnInput(
                userText: "Review this Swift code for a bug",
                modality: .text,
                sensitivity: .localOnly
            ),
            transcript: [ChatMessage(role: .user, content: "Previous context")]
        )

        XCTAssertEqual(output.route.target, .local)
        XCTAssertEqual(output.execution.mode, .local)
        XCTAssertTrue(output.route.reasonCodes.contains("local_only"))
    }

    func testRunTurnEscalatesCodeRequestsToOpenAI() async throws {
        let apiKeyStore = InMemoryAPIKeyStore()
        apiKeyStore.setAPIKey("test-key", for: .openAI)
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: apiKeyStore,
            memoryStore: InMemoryEpisodicMemoryStore(),
            localModel: MockLocalModelClient(),
            cloudModel: MockCloudModelClient()
        )

        let output = try await runtime.runTurn(
            userText: "Review this Swift code for a bug",
            transcript: [ChatMessage(role: .user, content: "Previous context")]
        )

        XCTAssertEqual(output.route.target, .openAI)
        XCTAssertEqual(output.execution.mode, .cloud)
        XCTAssertEqual(output.execution.provider, .openAI)
        XCTAssertEqual(output.execution.model, "gpt-5-mini")
        XCTAssertTrue(output.response.contains("openAI handled"))
    }

    func testRunTurnTrimsCloudPromptToConfiguredBudget() async throws {
        let apiKeyStore = InMemoryAPIKeyStore()
        apiKeyStore.setAPIKey("test-key", for: .openAI)
        let runtime = RuntimeContainer.live(
            config: AppConfig(
                allowsCloudEscalation: true,
                maxCloudContextTokens: 64,
                openAIModel: "gpt-5-mini",
                localModelBackend: .automatic
            ),
            apiKeyStore: apiKeyStore,
            memoryStore: InMemoryEpisodicMemoryStore(),
            localModel: MockLocalModelClient(),
            cloudModel: MockCloudModelClient()
        )
        let longMessage = String(repeating: "A very long context line. ", count: 40)

        let output = try await runtime.runTurn(
            userText: "Review this Swift code for a bug",
            transcript: [
                ChatMessage(role: .user, content: longMessage),
                ChatMessage(role: .assistant, content: longMessage),
                ChatMessage(role: .user, content: longMessage)
            ]
        )

        XCTAssertEqual(output.execution.mode, .cloud)
        XCTAssertTrue(output.prompt.contains("...[trimmed]"))
        XCTAssertLessThanOrEqual(output.prompt.count, 64 * 4 + 32)
    }

    func testRunTurnUsesLocalPrimaryWhenCloudKeyIsMissing() async throws {
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: InMemoryAPIKeyStore(),
            memoryStore: InMemoryEpisodicMemoryStore(),
            localModel: MockLocalModelClient(),
            cloudModel: MockCloudModelClient()
        )

        let output = try await runtime.runTurn(
            userText: "Review this Swift code for a bug",
            transcript: [ChatMessage(role: .user, content: "Previous context")]
        )

        XCTAssertEqual(output.route.target, .local)
        XCTAssertEqual(output.execution.mode, .local)
        XCTAssertNil(output.execution.provider)
        XCTAssertEqual(output.execution.model, "Mock Local Runtime")
        XCTAssertTrue(output.route.reasonCodes.contains("openai_key_unavailable"))
        XCTAssertFalse(output.response.contains("Local fallback used"))
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
            maxCloudContextTokens: 512,
            openAIModel: "gpt-5.1",
            localModelBackend: .embeddedHeuristic
        )
        settings.openAIKey = "  openai-test-key  "
        settings.anthropicKey = ""

        let reloaded = AppSettingsStore(defaults: defaults, apiKeyStore: apiKeyStore)

        XCTAssertEqual(
            reloaded.config,
            AppConfig(
                allowsCloudEscalation: false,
                maxCloudContextTokens: 512,
                openAIModel: "gpt-5.1",
                localModelBackend: .embeddedHeuristic
            )
        )
        XCTAssertEqual(apiKeyStore.apiKey(for: .openAI), "openai-test-key")
        XCTAssertNil(apiKeyStore.apiKey(for: .anthropic))
    }

    @MainActor
    func testAppSettingsStoreReportsProviderAvailability() {
        let suiteName = "PREXUSTests.ProviderAvailability.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let apiKeyStore = InMemoryAPIKeyStore()
        let settings = AppSettingsStore(defaults: defaults, apiKeyStore: apiKeyStore)

        XCTAssertEqual(settings.availabilityStatus(for: .openAI), .localPrimary)

        settings.openAIKey = "test-openai-key"
        XCTAssertEqual(settings.availabilityStatus(for: .openAI), .cloudReady)

        settings.config = AppConfig(
            allowsCloudEscalation: false,
            maxCloudContextTokens: 2_048,
            openAIModel: "gpt-5-mini",
            localModelBackend: .automatic
        )
        XCTAssertEqual(settings.availabilityStatus(for: .openAI), .disabled)
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

    @MainActor
    func testRuntimeDiagnosticsStoreKeepsRecentEntries() {
        let defaults = UserDefaults(suiteName: #function)!
        defaults.removePersistentDomain(forName: #function)
        let store = RuntimeDiagnosticsStore(defaults: defaults, maxEntries: 2)
        let route = RouteDecision(
            tier: .tier2,
            target: .local,
            reasonCodes: ["local_default"]
        )
        let localExecution = RuntimeExecutionMetadata(
            mode: .local,
            provider: nil,
            model: "Embedded Heuristic Runtime",
            detail: "Handled on device."
        )

        store.record(route: route, execution: localExecution, userText: "First")
        store.record(route: route, execution: localExecution, userText: "Second")
        store.record(route: route, execution: localExecution, userText: "Third")

        XCTAssertEqual(store.entries.map(\.userText), ["Third", "Second"])
        XCTAssertEqual(store.entries.first?.executionStatusSummary, "Local runtime | Embedded Heuristic Runtime | Handled on device.")
        XCTAssertEqual(store.entries.first?.routeSummary, "Route: local | Tier: tier2")

        let reloaded = RuntimeDiagnosticsStore(defaults: defaults, maxEntries: 2)
        XCTAssertEqual(reloaded.entries.map(\.userText), ["Third", "Second"])

        store.clear()
        XCTAssertTrue(store.entries.isEmpty)
        XCTAssertTrue(RuntimeDiagnosticsStore(defaults: defaults, maxEntries: 2).entries.isEmpty)
    }

    func testOpenAIResponsesClientBuildsRequestAndParsesOutput() async throws {
        let transport = MockHTTPTransport(
            responseData: """
            {
              "output": [
                {
                  "content": [
                    {
                      "type": "output_text",
                      "text": "Escalated answer."
                    }
                  ]
                }
              ]
            }
            """.data(using: .utf8)!,
            statusCode: 200
        )
        let client = OpenAIResponsesClient(
            transport: transport,
            model: "gpt-5-mini"
        )

        let output = try await client.generate(
            prompt: "Intent route: code_task\n\nUser:\nReview this Swift code",
            apiKey: "secret-key"
        )

        XCTAssertEqual(output, "Escalated answer.")
        XCTAssertEqual(transport.lastRequest?.httpMethod, "POST")
        XCTAssertEqual(transport.lastRequest?.value(forHTTPHeaderField: "Authorization"), "Bearer secret-key")

        let requestBody = try XCTUnwrap(transport.lastRequest?.httpBody)
        let json = try XCTUnwrap(JSONSerialization.jsonObject(with: requestBody) as? [String: Any])
        XCTAssertEqual(json["model"] as? String, "gpt-5-mini")
        XCTAssertEqual(json["input"] as? String, "Intent route: code_task\n\nUser:\nReview this Swift code")
        XCTAssertEqual(json["store"] as? Bool, false)
        XCTAssertNotNil(json["instructions"] as? String)
    }

    func testOpenAIResponsesClientSurfacesProviderErrors() async throws {
        let transport = MockHTTPTransport(
            responseData: """
            {
              "error": {
                "message": "Invalid authentication credentials."
              }
            }
            """.data(using: .utf8)!,
            statusCode: 401
        )
        let client = OpenAIResponsesClient(
            transport: transport,
            model: "gpt-5-mini"
        )

        do {
            _ = try await client.generate(prompt: "Hello", apiKey: "bad-key")
            XCTFail("Expected provider failure")
        } catch let error as CloudModelError {
            XCTAssertEqual(
                error,
                .providerFailure(statusCode: 401, message: "Invalid authentication credentials.")
            )
        }
    }

    func testLocalModelFactoryUsesSimulatorBackendForAutomaticMode() {
        let client = LocalModelFactory.makeClient(preferred: .automatic)
        XCTAssertEqual(client.descriptor.backend, .simulatorMock)
        XCTAssertEqual(client.descriptor.name, "Simulator Mock Runtime")
    }

    func testLocalModelFactoryHonorsExplicitEmbeddedBackend() {
        let client = LocalModelFactory.makeClient(preferred: .embeddedHeuristic)
        XCTAssertEqual(client.descriptor.backend, .embeddedHeuristic)
        XCTAssertEqual(client.descriptor.name, "Embedded Heuristic Runtime")
    }
}

private final class MockHTTPTransport: HTTPTransport {
    private let responseData: Data
    private let statusCode: Int

    private(set) var lastRequest: URLRequest?

    init(responseData: Data, statusCode: Int) {
        self.responseData = responseData
        self.statusCode = statusCode
    }

    func data(for request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        lastRequest = request
        let response = HTTPURLResponse(
            url: try XCTUnwrap(request.url),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        return (responseData, response)
    }
}
