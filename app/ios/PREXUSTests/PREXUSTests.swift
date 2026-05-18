import XCTest
@testable import PREXUS

final class PREXUSTests: XCTestCase {
    func testSensitivityLevelsExposeConsistentLabelsAndDescriptions() {
        XCTAssertEqual(
            SensitivityLevel.allCases,
            [.localOnly, .localPreferred, .escalationAllowed, .providerRestricted]
        )
        XCTAssertEqual(
            SensitivityLevel.allCases.map(\.displayLabel),
            ["Local Only", "Local Preferred", "Escalation Allowed", "Provider Restricted"]
        )
        XCTAssertEqual(
            SensitivityLevel.allCases.map(\.compactDisplayLabel),
            ["Local", "Prefer", "Escalate", "Restricted"]
        )
        XCTAssertEqual(
            SensitivityLevel.allCases.map(\.helperDescription),
            [
                "Run only on device.",
                "Prefer on-device handling, with fallback if needed.",
                "Allow cloud escalation when it helps.",
                "Allow cloud use only through approved providers."
            ]
        )
        XCTAssertEqual(
            SensitivityLevel.allCases.map(\.allowsAutomaticEpisodicMemory),
            [false, true, true, false]
        )
    }

    func testSensitiveRequestsStayLocal() {
        let router = DefaultRoutingEngine(
            classifier: HeuristicIntentClassifier(),
            policy: ExecutionPolicy(
                allowsCloudEscalation: true,
                maxCloudContextTokens: 2_048,
                approvedProvidersForRestrictedMode: []
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

    func testProviderRestrictedRequestsStayLocal() {
        let router = DefaultRoutingEngine(
            classifier: HeuristicIntentClassifier(),
            policy: ExecutionPolicy(
                allowsCloudEscalation: true,
                maxCloudContextTokens: 2_048,
                approvedProvidersForRestrictedMode: []
            )
        )

        let decision = router.route(
            request: RuntimeRequest(
                text: "Review this code path",
                modality: .text,
                sensitivity: .providerRestricted
            )
        )

        XCTAssertEqual(decision.target, .local)
        XCTAssertEqual(decision.tier, .tier2)
        XCTAssertEqual(decision.reasonCodes, ["codeAnalysis", "provider_restricted", "provider_not_approved"])
        XCTAssertEqual(decision.displayReasonSummary, "Code analysis | Provider restricted | Provider not approved")
    }

    func testProviderRestrictedRequestsUseApprovedProvider() {
        let router = DefaultRoutingEngine(
            classifier: HeuristicIntentClassifier(),
            policy: ExecutionPolicy(
                allowsCloudEscalation: true,
                maxCloudContextTokens: 2_048,
                approvedProvidersForRestrictedMode: [.openAI]
            )
        )

        let decision = router.route(
            request: RuntimeRequest(
                text: "Review this code path",
                modality: .text,
                sensitivity: .providerRestricted
            )
        )

        XCTAssertEqual(decision.target, .openAI)
        XCTAssertEqual(decision.tier, .tier3)
        XCTAssertEqual(decision.reasonCodes, ["codeAnalysis", "provider_restricted"])
        XCTAssertEqual(decision.displayReasonSummary, "Code analysis | Provider restricted")
    }

    func testLocalOnlyImageRequestsStayLocal() {
        let router = DefaultRoutingEngine(
            classifier: HeuristicIntentClassifier(),
            policy: ExecutionPolicy(
                allowsCloudEscalation: true,
                maxCloudContextTokens: 2_048,
                approvedProvidersForRestrictedMode: [.gemini]
            )
        )

        let decision = router.route(
            request: RuntimeRequest(
                text: "Inspect this diagram",
                modality: .image,
                sensitivity: .localOnly
            )
        )

        XCTAssertEqual(decision.target, .local)
        XCTAssertEqual(decision.reasonCodes, ["visionReasoning", "local_only"])
    }

    func testProviderRestrictedImageRequestsUseApprovedGeminiRoute() {
        let router = DefaultRoutingEngine(
            classifier: HeuristicIntentClassifier(),
            policy: ExecutionPolicy(
                allowsCloudEscalation: true,
                maxCloudContextTokens: 2_048,
                approvedProvidersForRestrictedMode: [.gemini]
            )
        )

        let decision = router.route(
            request: RuntimeRequest(
                text: "Inspect this wiring diagram",
                modality: .image,
                sensitivity: .providerRestricted
            )
        )

        XCTAssertEqual(decision.target, .gemini)
        XCTAssertEqual(decision.tier, .tier3)
        XCTAssertEqual(decision.reasonCodes, ["visionReasoning", "provider_restricted"])
    }

    func testProviderRestrictedOCRRequestsStayLocalByDefault() {
        let router = DefaultRoutingEngine(
            classifier: HeuristicIntentClassifier(),
            policy: ExecutionPolicy(
                allowsCloudEscalation: true,
                maxCloudContextTokens: 2_048,
                approvedProvidersForRestrictedMode: [.openAI, .gemini]
            )
        )

        let decision = router.route(
            request: RuntimeRequest(
                text: "Extract text from this receipt with OCR",
                modality: .text,
                sensitivity: .providerRestricted
            )
        )

        XCTAssertEqual(decision.target, .local)
        XCTAssertEqual(decision.reasonCodes, ["ocrExtraction", "provider_restricted", "local_default"])
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
        XCTAssertEqual(route.statusSummary, "Local | Tier 2")
        XCTAssertEqual(route.displayReasonSummary, "Code analysis | High complexity | OpenAI key unavailable")
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
                localModelBackend: .automatic,
                approvedProvidersForRestrictedMode: []
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

    func testRunTurnSkipsAutomaticMemoryForLocalOnlySensitivity() async throws {
        let memoryStore = InMemoryEpisodicMemoryStore()
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: InMemoryAPIKeyStore(),
            memoryStore: memoryStore,
            localModel: MockLocalModelClient(),
            cloudModel: MockCloudModelClient()
        )

        _ = try await runtime.runTurn(
            input: RuntimeTurnInput(
                userText: "Store nothing from this private note",
                modality: .text,
                sensitivity: .localOnly
            ),
            transcript: []
        )

        XCTAssertTrue(memoryStore.all().isEmpty)
    }

    func testRunTurnSkipsAutomaticMemoryForProviderRestrictedSensitivity() async throws {
        let apiKeyStore = InMemoryAPIKeyStore()
        apiKeyStore.setAPIKey("test-key", for: .openAI)
        let memoryStore = InMemoryEpisodicMemoryStore()
        let runtime = RuntimeContainer.live(
            config: AppConfig(
                allowsCloudEscalation: true,
                maxCloudContextTokens: 2_048,
                openAIModel: "gpt-5-mini",
                localModelBackend: .automatic,
                approvedProvidersForRestrictedMode: [.openAI]
            ),
            apiKeyStore: apiKeyStore,
            memoryStore: memoryStore,
            localModel: MockLocalModelClient(),
            cloudModel: MockCloudModelClient()
        )

        _ = try await runtime.runTurn(
            input: RuntimeTurnInput(
                userText: "Review this restricted code path",
                modality: .text,
                sensitivity: .providerRestricted
            ),
            transcript: []
        )

        XCTAssertTrue(memoryStore.all().isEmpty)
    }

    func testRunTurnStoresAutomaticMemoryForLocalPreferredSensitivity() async throws {
        let memoryStore = InMemoryEpisodicMemoryStore()
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: InMemoryAPIKeyStore(),
            memoryStore: memoryStore,
            localModel: MockLocalModelClient(),
            cloudModel: MockCloudModelClient()
        )

        _ = try await runtime.runTurn(
            input: RuntimeTurnInput(
                userText: "Remember this local-first preference",
                modality: .text,
                sensitivity: .localPreferred
            ),
            transcript: []
        )

        XCTAssertEqual(memoryStore.all().map(\.summary), ["Remember this local-first preference"])
        XCTAssertEqual(memoryStore.all().first?.sensitivity, .localPreferred)
    }

    func testAudioInputUsesSameSensitivityRetentionPolicy() async throws {
        let memoryStore = InMemoryEpisodicMemoryStore()
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: InMemoryAPIKeyStore(),
            memoryStore: memoryStore,
            localModel: MockLocalModelClient(),
            cloudModel: MockCloudModelClient()
        )

        _ = try await runtime.runTurn(
            input: .audio(
                "Remember this spoken reminder",
                sensitivity: .providerRestricted
            ),
            transcript: []
        )

        XCTAssertTrue(memoryStore.all().isEmpty)
    }

    @MainActor
    func testChatViewModelPinsActiveTurnStateWhileSending() async {
        let suiteName = "PREXUSTests.ChatViewModel.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let apiKeyStore = InMemoryAPIKeyStore()
        let settings = AppSettingsStore(defaults: defaults, apiKeyStore: apiKeyStore)
        let environment = AppEnvironment(
            settings: settings,
            apiKeyStore: apiKeyStore,
            memoryStore: InMemoryEpisodicMemoryStore()
        )
        let viewModel = ChatViewModel(environment: environment)

        viewModel.selectedSensitivity = .localOnly
        viewModel.draftText = "Review this Swift code for a bug"

        viewModel.send(text: "Review this Swift code for a bug")

        XCTAssertTrue(viewModel.isSending)
        XCTAssertEqual(viewModel.routeBannerTitle, "Executing Route")
        XCTAssertEqual(viewModel.displayedSensitivity, .localOnly)
        XCTAssertEqual(viewModel.activeTurnSensitivity, .localOnly)
        XCTAssertEqual(viewModel.activeRoute?.statusSummary, "Local | Tier 2")
        XCTAssertEqual(viewModel.displayedRoute?.statusSummary, "Local | Tier 2")
        XCTAssertEqual(viewModel.sendStateSummary, "Local Only | Local | Tier 2")

        while viewModel.isSending {
            await Task.yield()
        }

        XCTAssertNil(viewModel.activeTurnSensitivity)
        XCTAssertNil(viewModel.activeRoute)
        XCTAssertEqual(viewModel.routeBannerTitle, "Planned Route")
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
            localModelBackend: .embeddedHeuristic,
            approvedProvidersForRestrictedMode: [.openAI, .gemini]
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
                localModelBackend: .embeddedHeuristic,
                approvedProvidersForRestrictedMode: [.openAI, .gemini]
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
            localModelBackend: .automatic,
            approvedProvidersForRestrictedMode: []
        )
        XCTAssertEqual(settings.availabilityStatus(for: .openAI), .disabled)
    }

    @MainActor
    func testAppSettingsStorePersistsRestrictedProviderApprovals() {
        let suiteName = "PREXUSTests.RestrictedProviders.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let settings = AppSettingsStore(defaults: defaults, apiKeyStore: InMemoryAPIKeyStore())
        settings.setApprovedForRestrictedMode(true, provider: .openAI)
        settings.setApprovedForRestrictedMode(true, provider: .gemini)
        settings.setApprovedForRestrictedMode(false, provider: .openAI)

        let reloaded = AppSettingsStore(defaults: defaults, apiKeyStore: InMemoryAPIKeyStore())

        XCTAssertFalse(reloaded.isApprovedForRestrictedMode(.openAI))
        XCTAssertFalse(reloaded.isApprovedForRestrictedMode(.anthropic))
        XCTAssertTrue(reloaded.isApprovedForRestrictedMode(.gemini))
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
        XCTAssertEqual(store.entries.first?.routeSummary, "Route: Local | Tier: Tier 2")
        XCTAssertEqual(store.entries.first?.reasonSummary, "Local default")

        let reloaded = RuntimeDiagnosticsStore(defaults: defaults, maxEntries: 2)
        XCTAssertEqual(reloaded.entries.map(\.userText), ["Third", "Second"])

        store.clear()
        XCTAssertTrue(store.entries.isEmpty)
        XCTAssertTrue(RuntimeDiagnosticsStore(defaults: defaults, maxEntries: 2).entries.isEmpty)
    }

    @MainActor
    func testRuntimeDiagnosticsStoreSurfacesPrimaryRouteReason() {
        let defaults = UserDefaults(suiteName: #function)!
        defaults.removePersistentDomain(forName: #function)
        let store = RuntimeDiagnosticsStore(defaults: defaults, maxEntries: 1)
        let route = RouteDecision(
            tier: .tier2,
            target: .local,
            reasonCodes: ["codeAnalysis", "provider_restricted", "provider_not_approved"]
        )
        let execution = RuntimeExecutionMetadata(
            mode: .fallback,
            provider: nil,
            model: nil,
            detail: "Restricted mode fell back to local execution."
        )

        store.record(route: route, execution: execution, userText: "Review this code")

        XCTAssertEqual(store.entries.first?.primaryReasonSummary, "Provider not approved")
        XCTAssertEqual(store.entries.first?.secondaryReasonSummary, "Code analysis | Provider restricted")
        XCTAssertEqual(
            store.entries.first?.reasonSummary,
            "Provider not approved | Code analysis | Provider restricted"
        )
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
