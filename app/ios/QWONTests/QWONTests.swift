import XCTest
@testable import QWON

final class QWONTests: XCTestCase {
    func testUILabelCopyPreservesAlphaOnboardingMeanings() {
        XCTAssertTrue(QWONUILabelCopy.Chat.onboardingHint.contains("llama.cpp On-Device Runtime"))
        XCTAssertTrue(QWONUILabelCopy.Chat.onboardingHint.contains("Embedded Heuristic Runtime"))
        XCTAssertTrue(QWONUILabelCopy.Settings.introMessage.contains("Matisse"))
        XCTAssertTrue(QWONUILabelCopy.Diagnostics.summaryDetail.contains("answered_by"))
        XCTAssertFalse(QWONUILabelCopy.Settings.localRuntimeFooter.localizedCaseInsensitiveContains("download"))
        XCTAssertFalse(QWONUILabelCopy.ModelStatus.settingsFooter.localizedCaseInsensitiveContains("download"))
        XCTAssertFalse(QWONUILabelCopy.GuidedPlacement.introMessage.localizedCaseInsensitiveContains("tap to download"))
        XCTAssertFalse(QWONUILabelCopy.GuidedPlacement.settingsNavSubtitle.localizedCaseInsensitiveContains("download in qwon"))
        XCTAssertFalse(QWONUILabelCopy.Chat.onboardingHint.localizedCaseInsensitiveContains("fully offline"))
    }

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

    func testPriorityOneAccessibilityIdentifiersStayStable() {
        XCTAssertEqual(QWONAccessibilityID.Chat.openSettings, "chat.open-settings")
        XCTAssertEqual(QWONAccessibilityID.Settings.done, "settings.done")
        XCTAssertEqual(QWONAccessibilityID.Settings.openDiagnostics, "settings.open-diagnostics")
        XCTAssertEqual(QWONAccessibilityID.Settings.openMemory, "settings.open-memory")
        XCTAssertEqual(QWONAccessibilityID.Settings.openGuidedPlacement, "settings.open-guided-placement")
        XCTAssertEqual(QWONAccessibilityID.Settings.guidedPlacementScreen, "settings.guided-placement")
        XCTAssertEqual(QWONAccessibilityID.Diagnostics.clear, "diagnostics.clear")
        XCTAssertEqual(QWONAccessibilityID.Memory.clearAll, "memory.clear-all")
    }

    @MainActor
    func testSeededRuntimeSurfaceScenarioPreloadsDiagnosticsAndMemory() {
        let environment = AppEnvironment.bootstrap(launchScenario: .seededRuntimeSurfaces)

        XCTAssertEqual(environment.runtimeDiagnostics.entries.count, 2)
        XCTAssertEqual(environment.memoryLibrary.memories.count, 2)
        XCTAssertFalse(environment.runtimeDiagnostics.entries[0].primaryReasonSummary.isEmpty)
        XCTAssertFalse(environment.memoryLibrary.memories[0].summary.isEmpty)
    }

    @MainActor
    func testSeededRuntimeSurfaceScenarioPreloadsChatRoutePreview() {
        let environment = AppEnvironment.bootstrap(launchScenario: .seededRuntimeSurfaces)
        let viewModel = ChatViewModel.seededRuntimeSurfaces(environment: environment)

        XCTAssertEqual(viewModel.selectedSensitivity, .providerRestricted)
        XCTAssertEqual(viewModel.messages.count, 3)
        XCTAssertFalse(viewModel.draftText.isEmpty)
        XCTAssertNotNil(viewModel.forcedPreviewRoute)
        XCTAssertNotNil(viewModel.displayedRoute)
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
            ChatMessage(role: .system, content: "QWON runtime initialized."),
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
            transcript: [RuntimeMessage]()
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
            transcript: [RuntimeMessage]()
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
            transcript: [RuntimeMessage]()
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
            transcript: [RuntimeMessage]()
        )

        XCTAssertTrue(memoryStore.all().isEmpty)
    }

    func testRuntimeTranscriptExcludesCanceledInFlightUserTurn() {
        let transcript = ChatRuntimeTranscript.messages(
            from: [
                ChatMessage(role: .system, content: "QWON runtime initialized."),
                ChatMessage(role: .user, content: "First turn")
            ],
            replacingInFlightTurn: true
        )

        XCTAssertEqual(transcript.map(\.content), ["QWON runtime initialized."])
    }

    @MainActor
    func testChatViewModelIgnoresStaleSendResults() async {
        let suiteName = "QWONTests.ChatViewModelStale.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let capturingLocalModel = CapturingLocalModelClient()
        let apiKeyStore = InMemoryAPIKeyStore()
        let settings = AppSettingsStore(defaults: defaults, apiKeyStore: apiKeyStore)
        let memoryStore = InMemoryEpisodicMemoryStore()
        let runtime = RuntimeContainer.live(
            config: settings.config,
            apiKeyStore: apiKeyStore,
            memoryStore: memoryStore,
            localModel: capturingLocalModel,
            cloudModel: MockCloudModelClient()
        )
        let environment = AppEnvironment(
            settings: settings,
            apiKeyStore: apiKeyStore,
            memoryStore: memoryStore,
            runtimeDiagnosticsStore: RuntimeDiagnosticsStore(defaults: defaults),
            runtimeOverride: runtime
        )
        let viewModel = ChatViewModel(environment: environment)

        viewModel.send(text: "First turn")
        await capturingLocalModel.waitUntilHolding()
        viewModel.send(text: "Second turn")
        await capturingLocalModel.waitUntilHolding()
        capturingLocalModel.releaseActiveTurn()

        while viewModel.isSending {
            await Task.yield()
        }

        let userMessages = viewModel.messages.filter { $0.role == .user }
        XCTAssertEqual(userMessages.map(\.content), ["Second turn"])

        let assistantMessages = viewModel.messages.filter { $0.role == .assistant }
        XCTAssertEqual(assistantMessages.count, 1)

        guard let capturedPrompt = capturingLocalModel.lastPrompt else {
            return XCTFail("Expected the active turn to capture a runtime prompt.")
        }
        XCTAssertTrue(capturedPrompt.contains("Second turn"))
        XCTAssertFalse(capturedPrompt.contains("First turn"))
    }

    @MainActor
    func testChatViewModelPinsActiveTurnStateWhileSending() async {
        let suiteName = "QWONTests.ChatViewModel.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let apiKeyStore = InMemoryAPIKeyStore()
        let settings = AppSettingsStore(defaults: defaults, apiKeyStore: apiKeyStore)
        let diagnosticsStore = RuntimeDiagnosticsStore(defaults: defaults)
        let environment = AppEnvironment(
            settings: settings,
            apiKeyStore: apiKeyStore,
            memoryStore: InMemoryEpisodicMemoryStore(),
            runtimeDiagnosticsStore: diagnosticsStore
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
        XCTAssertEqual(viewModel.routeBannerTitle, "Executed Route")
        XCTAssertEqual(viewModel.displayedRoute?.statusSummary, "Local | Tier 2")
    }

    @MainActor
    func testChatViewModelKeepsAssistantReplyConversationOnly() async {
        let suiteName = "QWONTests.ChatViewModelConversation.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        defer { defaults.removePersistentDomain(forName: suiteName) }

        let apiKeyStore = InMemoryAPIKeyStore()
        let settings = AppSettingsStore(defaults: defaults, apiKeyStore: apiKeyStore)
        let diagnosticsStore = RuntimeDiagnosticsStore(defaults: defaults)
        let environment = AppEnvironment(
            settings: settings,
            apiKeyStore: apiKeyStore,
            memoryStore: InMemoryEpisodicMemoryStore(),
            runtimeDiagnosticsStore: diagnosticsStore
        )
        let viewModel = ChatViewModel(environment: environment)

        viewModel.send(text: "Summarize this quickly")

        while viewModel.isSending {
            await Task.yield()
        }

        let assistantMessages: [ChatMessage] = viewModel.messages.filter { $0.role == ChatMessage.Role.assistant }
        XCTAssertEqual(assistantMessages.count, 1)
        XCTAssertFalse(assistantMessages[0].content.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)
        XCTAssertFalse(assistantMessages[0].content.contains("Route:"))
        XCTAssertFalse(assistantMessages[0].content.contains("Reason:"))
        XCTAssertFalse(assistantMessages[0].content.contains("Execution:"))
    }

    func testEpisodicMemoryRecentReturnsNewestEpisodes() {
        let store = InMemoryEpisodicMemoryStore()
        let oldest = EpisodicMemory(
            id: UUID(),
            summary: "Oldest episode",
            sensitivity: .localPreferred,
            createdAt: Date(timeIntervalSince1970: 1_715_900_100)
        )
        let middle = EpisodicMemory(
            id: UUID(),
            summary: "Middle episode",
            sensitivity: .localPreferred,
            createdAt: Date(timeIntervalSince1970: 1_715_900_200)
        )
        let newest = EpisodicMemory(
            id: UUID(),
            summary: "Newest episode",
            sensitivity: .localPreferred,
            createdAt: Date(timeIntervalSince1970: 1_715_900_300)
        )

        store.save(oldest)
        store.save(middle)
        store.save(newest)

        XCTAssertEqual(store.recent(limit: 2).map(\.summary), ["Newest episode", "Middle episode"])
    }

    func testPersistentMemoryStoreReloadsSavedEpisodes() {
        let suiteName = "QWONTests.PersistentMemory.\(UUID().uuidString)"
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
        let suiteName = "QWONTests.PersistentMemory.Delete.\(UUID().uuidString)"
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
        let suiteName = "QWONTests.Settings.\(UUID().uuidString)"
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
        let suiteName = "QWONTests.ProviderAvailability.\(UUID().uuidString)"
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
        let suiteName = "QWONTests.RestrictedProviders.\(UUID().uuidString)"
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

    func testLocalInferenceDeviceGateSupportsA17ProClassIdentifiers() {
        XCTAssertEqual(
            LocalInferenceDeviceGate.chipTier(machineIdentifier: "iPhone16,1"),
            .a17ProOrNewer
        )
        XCTAssertEqual(
            LocalInferenceDeviceGate.chipTier(machineIdentifier: "iPhone17,3"),
            .a17ProOrNewer
        )
        XCTAssertEqual(
            LocalInferenceDeviceGate.chipTier(machineIdentifier: "iPhone18,3"),
            .a17ProOrNewer
        )
    }

    func testLocalInferenceDeviceGateRejectsOlderPhones() {
        XCTAssertEqual(
            LocalInferenceDeviceGate.chipTier(machineIdentifier: "iPhone15,4"),
            .unsupported
        )
        XCTAssertEqual(
            LocalInferenceDeviceGate.chipTier(machineIdentifier: "iPhone14,5"),
            .unsupported
        )
    }

    func testLocalGGUFModelPlacementPrefersDefaultThenEvaluationArtifact() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        let modelsDirectory = root.appendingPathComponent("Models", isDirectory: true)
        try FileManager.default.createDirectory(at: modelsDirectory, withIntermediateDirectories: true)

        let defaultModel = modelsDirectory.appendingPathComponent(LocalGGUFModelPlacement.defaultModelFileName)
        let evaluationModel = modelsDirectory.appendingPathComponent(LocalGGUFModelPlacement.evaluationGemmaModelFileName)
        try Data("default".utf8).write(to: defaultModel)
        try Data("eval".utf8).write(to: evaluationModel)

        let withDefault = LocalGGUFModelPlacement(
            fileManager: .default,
            environment: [:],
            documentsDirectory: root
        )
        XCTAssertEqual(withDefault.resolvedModelURL?.lastPathComponent, LocalGGUFModelPlacement.defaultModelFileName)

        try FileManager.default.removeItem(at: defaultModel)

        let withEvaluationOnly = LocalGGUFModelPlacement(
            fileManager: .default,
            environment: [:],
            documentsDirectory: root
        )
        XCTAssertEqual(
            withEvaluationOnly.resolvedModelURL?.lastPathComponent,
            LocalGGUFModelPlacement.evaluationGemmaModelFileName
        )

        try FileManager.default.removeItem(at: root)
    }

    func testQWONLocalModelStatusReportsMissingAtExpectedPath() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)

        let status = QWONLocalModelStatusInspector(
            fileManager: .default,
            environment: [:],
            documentsDirectory: root,
            machineIdentifierProvider: { "iPhone16,1" },
            isSimulatorProvider: { false }
        ).inspect()

        XCTAssertEqual(status.placementState, .missing)
        XCTAssertEqual(status.chipTier, .a17ProOrNewer)
        XCTAssertFalse(status.expectedPathPresent)
        XCTAssertEqual(QWONLocalModelStatus.expectedFileName, LocalGGUFModelPlacement.defaultModelFileName)
        XCTAssertEqual(QWONLocalModelStatus.expectedRelativePlacement, "Documents/Models/prexus-local-mvp.gguf")
        XCTAssertEqual(QWONLocalModelStatusPresentation.statusChipLabel(for: status), "Missing")
        XCTAssertEqual(QWONLocalModelStatusPresentation.expectedRuntimeLabel(for: status), "Embedded Heuristic fallback")
        XCTAssertTrue(QWONUILabelCopy.ModelStatus.summaryDetail(for: status).contains("prexus-local-mvp.gguf"))
        XCTAssertTrue(QWONUILabelCopy.ModelStatus.diagnosticsMappingDetail(for: status).contains("model_asset_unavailable"))

        try FileManager.default.removeItem(at: root)
    }

    func testQWONLocalModelStatusReportsPresentUnverifiedAtDefaultPath() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        let modelsDirectory = root.appendingPathComponent("Models", isDirectory: true)
        try FileManager.default.createDirectory(at: modelsDirectory, withIntermediateDirectories: true)

        let defaultModel = modelsDirectory.appendingPathComponent(LocalGGUFModelPlacement.defaultModelFileName)
        let payload = Data("gguf-placeholder".utf8)
        try payload.write(to: defaultModel)

        let status = QWONLocalModelStatusInspector(
            fileManager: .default,
            environment: [:],
            documentsDirectory: root,
            machineIdentifierProvider: { "iPhone16,1" },
            isSimulatorProvider: { false }
        ).inspect()

        if case let .presentUnverified(source, byteCount) = status.placementState {
            XCTAssertEqual(source, .documentsDefault)
            XCTAssertEqual(byteCount, Int64(payload.count))
        } else {
            XCTFail("Expected presentUnverified at default path")
        }
        XCTAssertTrue(status.expectedPathPresent)
        XCTAssertEqual(QWONLocalModelStatusPresentation.statusChipLabel(for: status), "Present (unverified)")
        XCTAssertEqual(QWONLocalModelStatusPresentation.expectedRuntimeLabel(for: status), "llama.cpp On-Device Runtime")
        XCTAssertTrue(QWONUILabelCopy.ModelStatus.diagnosticsMappingDetail(for: status).contains("llama.cpp On-Device Runtime"))

        try FileManager.default.removeItem(at: root)
    }

    func testQWONLocalModelStatusUsesMatisseExpectedHeuristicCopy() {
        let status = QWONLocalModelStatus(
            placementState: .missing,
            chipTier: .unsupported,
            machineIdentifier: "iPhone11,6",
            isSimulator: false,
            resolvedFileName: nil,
            expectedPathPresent: false
        )

        XCTAssertEqual(QWONLocalModelStatusPresentation.tierChipLabel(for: status), "Matisse-class (A12)")
        XCTAssertEqual(QWONLocalModelStatusPresentation.expectedRuntimeLabel(for: status), "Embedded Heuristic Runtime")
        XCTAssertTrue(QWONUILabelCopy.ModelStatus.summaryDetail(for: status).contains("expected local path"))
        XCTAssertFalse(QWONUILabelCopy.ModelStatus.diagnosticsMappingDetail(for: status).contains("Matisse failed"))
    }

    func testQWONLocalModelStatusUsesSimulatorCopy() {
        let status = QWONLocalModelStatus(
            placementState: .missing,
            chipTier: .a17ProOrNewer,
            machineIdentifier: "iPhone16,1",
            isSimulator: true,
            resolvedFileName: nil,
            expectedPathPresent: false
        )

        XCTAssertEqual(QWONLocalModelStatusPresentation.statusChipLabel(for: status), "Simulator")
        XCTAssertEqual(QWONLocalModelStatusPresentation.expectedRuntimeLabel(for: status), "Simulator Mock Runtime")
        XCTAssertTrue(QWONUILabelCopy.ModelStatus.summaryDetail(for: status).contains("Simulator uses a stub runtime"))
    }

    func testGuidedPlacementCommandsTargetExpectedOpsScripts() {
        XCTAssertEqual(
            QWONLocalModelGuidedPlacementCommands.fetchLocalModel,
            "./tools/scripts/fetch_local_model.sh"
        )
        XCTAssertEqual(
            QWONLocalModelGuidedPlacementCommands.pushLocalModelTemplate,
            "./tools/scripts/push_local_model_to_device.sh \"DEVICE_NAME\""
        )
        XCTAssertEqual(
            QWONLocalModelGuidedPlacementCommands.pushLocalModel(deviceName: "Wang"),
            "./tools/scripts/push_local_model_to_device.sh \"Wang\""
        )
        XCTAssertTrue(QWONUILabelCopy.GuidedPlacement.stepPushModelDetail.contains("Documents/Models/prexus-local-mvp.gguf"))
        XCTAssertTrue(QWONUILabelCopy.GuidedPlacement.matisseExpectation.contains("Embedded Heuristic Runtime"))
        XCTAssertTrue(QWONUILabelCopy.GuidedPlacement.wangExpectation.contains("llama.cpp On-Device Runtime"))
    }

    func testFallbackLocalModelClientUsesFallbackWhenPrimaryFails() async throws {
        struct FailingPrimary: LocalModelClient {
            let descriptor = LocalModelDescriptor(
                backend: .deviceRuntime,
                name: "Failing",
                summary: "Always fails"
            )

            func generate(prompt: String) async throws -> String {
                throw LocalModelError.modelAssetUnavailable
            }
        }

        let fallback = EmbeddedHeuristicLocalModelClient()
        let client = FallbackLocalModelClient(primary: FailingPrimary(), fallback: fallback)
        let response = try await client.generate(prompt: "User:\nReview routing policy")

        XCTAssertTrue(response.localizedCaseInsensitiveContains("embedded local runtime"))
    }

    func testFallbackLocalModelClientRecordsTraceOnPrimarySuccess() async throws {
        struct SuccessPrimary: LocalModelClient {
            let descriptor = LocalModelDescriptor(
                backend: .deviceRuntime,
                name: "Primary OK",
                summary: "Succeeds"
            )

            func generate(prompt: String) async throws -> String {
                "primary-response"
            }
        }

        LocalModelExecutionTrace.reset()
        let client = FallbackLocalModelClient(
            primary: SuccessPrimary(),
            fallback: EmbeddedHeuristicLocalModelClient()
        )
        _ = try await client.generate(prompt: "hello")

        XCTAssertEqual(LocalModelExecutionTrace.current?.respondingBackend, "Primary OK")
        XCTAssertNil(LocalModelExecutionTrace.current?.primaryFailure)
    }

    func testNestedFallbackPreservesInnerRespondingBackend() async throws {
        struct FailingLiteRT: LocalModelClient {
            let descriptor = LocalModelDescriptor(
                backend: .deviceRuntime,
                name: "LiteRT-LM Prototype Runtime",
                summary: "Fails"
            )

            func generate(prompt: String) async throws -> String {
                throw LocalModelError.backendUnavailable("LiteRT engine missing")
            }
        }

        struct FailingLlama: LocalModelClient {
            let descriptor = LocalModelDescriptor(
                backend: .deviceRuntime,
                name: "llama.cpp On-Device Runtime",
                summary: "Fails"
            )

            func generate(prompt: String) async throws -> String {
                throw LocalModelError.modelAssetUnavailable
            }
        }

        LocalModelExecutionTrace.reset()
        let qwenChain = FallbackLocalModelClient(
            primary: FailingLlama(),
            fallback: EmbeddedHeuristicLocalModelClient()
        )
        let outer = FallbackLocalModelClient(
            primary: FailingLiteRT(),
            fallback: qwenChain
        )
        _ = try await outer.generate(prompt: "User:\nReview routing policy")

        XCTAssertEqual(
            LocalModelExecutionTrace.current?.respondingBackend,
            "Embedded Heuristic Runtime"
        )
        XCTAssertTrue(LocalModelExecutionTrace.current?.primaryFailure?.contains("LiteRT") == true)
        XCTAssertEqual(LocalModelExecutionTrace.current?.fallbackReason, "embedded_heuristic")
        let detail = LocalModelExecutionTrace.formattedDetail(base: nil)
        XCTAssertTrue(detail?.contains("fallback_reason=embedded_heuristic") == true)
        LocalModelExecutionTrace.reset()
    }

    func testFallbackLocalModelClientPreservesPrimaryMetricsDetail() async throws {
        struct MetricsPrimary: LocalModelClient {
            let descriptor = LocalModelDescriptor(
                backend: .deviceRuntime,
                name: "LiteRT-LM Prototype Runtime",
                summary: "Records metrics before fallback wrapper re-records"
            )

            func generate(prompt: String) async throws -> String {
                LocalModelExecutionTrace.record(
                    respondingBackend: descriptor.name,
                    metricsDetail: "cold_load_ms=1768.8 first_token_ms=591.2 total_ms=2671.0"
                )
                return "litert-response"
            }
        }

        LocalModelExecutionTrace.reset()
        let client = FallbackLocalModelClient(
            primary: MetricsPrimary(),
            fallback: EmbeddedHeuristicLocalModelClient()
        )
        _ = try await client.generate(prompt: "hello")

        XCTAssertEqual(LocalModelExecutionTrace.current?.respondingBackend, "LiteRT-LM Prototype Runtime")
        XCTAssertEqual(
            LocalModelExecutionTrace.current?.metricsDetail,
            "cold_load_ms=1768.8 first_token_ms=591.2 total_ms=2671.0"
        )
        let detail = LocalModelExecutionTrace.formattedDetail(base: nil)
        XCTAssertTrue(detail?.contains("cold_load_ms=1768.8") == true)
        LocalModelExecutionTrace.reset()
    }

    func testFallbackLocalModelClientRecordsTraceOnFallback() async throws {
        struct FailingPrimary: LocalModelClient {
            let descriptor = LocalModelDescriptor(
                backend: .deviceRuntime,
                name: "Primary Fail",
                summary: "Fails"
            )

            func generate(prompt: String) async throws -> String {
                throw LocalModelError.modelAssetUnavailable
            }
        }

        LocalModelExecutionTrace.reset()
        let fallback = EmbeddedHeuristicLocalModelClient()
        let client = FallbackLocalModelClient(primary: FailingPrimary(), fallback: fallback)
        _ = try await client.generate(prompt: "User:\nReview routing policy")

        XCTAssertEqual(LocalModelExecutionTrace.current?.respondingBackend, fallback.descriptor.name)
        XCTAssertTrue(LocalModelExecutionTrace.current?.primaryFailure?.contains("model_asset_unavailable") == true)
    }

    func testLocalModelErrorDiagnosticDescriptionForMissingModel() {
        XCTAssertEqual(
            LocalModelError.modelAssetUnavailable.diagnosticCode,
            "model_asset_unavailable"
        )
        XCTAssertTrue(
            LocalModelError.modelAssetUnavailable.diagnosticDescription.contains("prexus-local-mvp.gguf")
        )
    }

    func testLocalModelExecutionTraceFormattedDetailMergesBase() {
        LocalModelExecutionTrace.record(
            respondingBackend: "LiteRT-LM Prototype Runtime",
            metricsDetail: "cold_load_ms=100.0 first_token_ms=50.0 total_ms=200.0"
        )

        let detail = LocalModelExecutionTrace.formattedDetail(base: "summary line")
        XCTAssertTrue(detail?.contains("answered_by=LiteRT-LM Prototype Runtime") == true)
        XCTAssertTrue(detail?.contains("cold_load_ms=100.0") == true)
        XCTAssertTrue(detail?.contains("summary line") == true)
        LocalModelExecutionTrace.reset()
    }

    func testLocalModelExecutionTraceIncludesFallbackReasonAfterPrimaryFailure() {
        LocalModelExecutionTrace.record(
            respondingBackend: "Embedded Heuristic Runtime",
            primaryFailure: LocalModelError.modelAssetUnavailable.diagnosticDescription,
            fallbackReason: "embedded_heuristic"
        )

        let detail = LocalModelExecutionTrace.formattedDetail(base: nil)
        XCTAssertTrue(detail?.contains("fallback_reason=embedded_heuristic") == true)
        XCTAssertTrue(detail?.contains("primary_failure=") == true)
        LocalModelExecutionTrace.reset()
    }

    func testNestedFallbackDoesNotEmitEmbeddedHeuristicReasonWhenQwenAnswers() async throws {
        struct FailingLiteRT: LocalModelClient {
            let descriptor = LocalModelDescriptor(
                backend: .deviceRuntime,
                name: "LiteRT-LM Prototype Runtime",
                summary: "Fails"
            )

            func generate(prompt: String) async throws -> String {
                throw LocalModelError.backendUnavailable("LiteRT engine missing")
            }
        }

        struct SuccessLlama: LocalModelClient {
            let descriptor = LocalModelDescriptor(
                backend: .deviceRuntime,
                name: "llama.cpp On-Device Runtime",
                summary: "Succeeds"
            )

            func generate(prompt: String) async throws -> String {
                "qwen-local-response"
            }
        }

        LocalModelExecutionTrace.reset()
        let qwenChain = FallbackLocalModelClient(
            primary: SuccessLlama(),
            fallback: EmbeddedHeuristicLocalModelClient()
        )
        let outer = FallbackLocalModelClient(
            primary: FailingLiteRT(),
            fallback: qwenChain
        )
        _ = try await outer.generate(prompt: "User:\nReview routing policy")

        XCTAssertEqual(
            LocalModelExecutionTrace.current?.respondingBackend,
            "llama.cpp On-Device Runtime"
        )
        XCTAssertTrue(LocalModelExecutionTrace.current?.primaryFailure?.contains("LiteRT") == true)
        XCTAssertNil(LocalModelExecutionTrace.current?.fallbackReason)

        let detail = LocalModelExecutionTrace.formattedDetail(base: nil)
        XCTAssertTrue(detail?.contains("answered_by=llama.cpp On-Device Runtime") == true)
        XCTAssertFalse(detail?.contains("fallback_reason=embedded_heuristic") == true)
        LocalModelExecutionTrace.reset()
    }

    func testRunTurnMarksFallbackWhenLlamaPrimaryFails() async throws {
        struct FailingLlama: LocalModelClient {
            let descriptor = LocalModelDescriptor(
                backend: .deviceRuntime,
                name: "llama.cpp On-Device Runtime",
                summary: "Unavailable for test"
            )

            func generate(prompt: String) async throws -> String {
                throw LocalModelError.modelAssetUnavailable
            }
        }

        let localModel = FallbackLocalModelClient(
            primary: FailingLlama(),
            fallback: EmbeddedHeuristicLocalModelClient()
        )
        let runtime = RuntimeContainer.live(
            config: .default,
            apiKeyStore: InMemoryAPIKeyStore(),
            memoryStore: InMemoryEpisodicMemoryStore(),
            localModel: localModel,
            cloudModel: MockCloudModelClient()
        )

        let output = try await runtime.runTurn(
            userText: "Hello from alpha smoke",
            transcript: [ChatMessage(role: .user, content: "Hello from alpha smoke")]
        )

        XCTAssertEqual(output.route.target, .local)
        XCTAssertEqual(output.execution.mode, .fallback)
        XCTAssertEqual(output.execution.model, "Embedded Heuristic Runtime")
        XCTAssertTrue(output.execution.detail?.contains("primary_failure=") == true)
        XCTAssertTrue(output.execution.detail?.contains("fallback_reason=embedded_heuristic") == true)
        XCTAssertTrue(output.response.localizedCaseInsensitiveContains("embedded local runtime"))
    }

    func testLiteRTModelPlacementUsesEvalArtifactFileName() {
        XCTAssertEqual(
            LiteRTModelPlacement.evaluationModelFileName,
            "prexus-eval-gemma4-e2b.litertlm"
        )
    }

    func testStrictJSONEvalPromptSetHasTwelveFrozenPrompts() {
        XCTAssertEqual(StrictJSONEvalPromptSet.frozenPrompts.count, 12)
        let categories = Set(StrictJSONEvalPromptSet.frozenPrompts.map(\.category))
        XCTAssertEqual(categories, Set(StrictJSONEvalCategory.allCases))
    }

    func testStrictJSONScorerAcceptsValidRoutingJSON() {
        let response = """
        {"intent":"summarize","confidence":0.92,"needs_cloud":false}
        """
        let score = StrictJSONEvalScorer.score(response: response, category: .routingClassification)
        XCTAssertTrue(score.strictPass)
        XCTAssertFalse(score.hadMarkdownFence)
    }

    func testStrictJSONScorerRejectsSemicolonSeparatedJSON() {
        let response = """
        {
          "intent": "tool_request";
          "confidence": 0.9;
          "needs_cloud": true
        }
        """
        let score = StrictJSONEvalScorer.score(response: response, category: .routingClassification)
        XCTAssertFalse(score.strictParsePass)
        XCTAssertFalse(score.strictPass)
        XCTAssertEqual(score.parseError, "semicolon_separator")
    }

    func testStrictJSONScorerRejectsWangStyleInlineSemicolonJSON() {
        let response = #"{   "intent": "chat";   "confidence": 0.9;   "needs_cloud": true }"#
        let score = StrictJSONEvalScorer.score(response: response, category: .routingClassification)
        XCTAssertFalse(score.strictPass)
        XCTAssertEqual(score.parseError, "semicolon_separator")
    }

    func testStrictJSONScorerStripsMarkdownFenceAndValidates() {
        let response = """
        ```json
        {"intent":"chat","confidence":0.5,"needs_cloud":false}
        ```
        """
        let score = StrictJSONEvalScorer.score(response: response, category: .routingClassification)
        XCTAssertTrue(score.hadMarkdownFence)
        XCTAssertTrue(score.strictPass)
    }

    func testStrictJSONScorerValidatesSummarizationMetadata() {
        let response = """
        {"summary":"Short recap","todos":["share doc","request review"],"local_sufficient":true}
        """
        let score = StrictJSONEvalScorer.score(response: response, category: .summarizationMetadata)
        XCTAssertTrue(score.strictPass)
    }

    func testStrictJSONScorerValidatesMemoryExtractionSensitivityEnum() {
        let response = """
        {"should_write_memory":true,"memory_summary":"Meeting Wed 15:00","sensitivity":"localOnly"}
        """
        let score = StrictJSONEvalScorer.score(response: response, category: .memoryExtraction)
        XCTAssertTrue(score.strictPass)
    }

    func testStrictJSONScorerRejectsNumericBooleanFields() {
        let response = """
        {"intent":"chat","confidence":0.9,"needs_cloud":1}
        """
        let score = StrictJSONEvalScorer.score(response: response, category: .routingClassification)
        XCTAssertFalse(score.strictPass)
        XCTAssertEqual(score.parseError, "json_decode_error")
    }

    func testStrictJSONScorerRejectsStringBooleanFields() {
        let response = """
        {"summary":"ok","todos":["a"],"local_sufficient":"yes"}
        """
        let score = StrictJSONEvalScorer.score(response: response, category: .summarizationMetadata)
        XCTAssertFalse(score.strictPass)
    }

    func testLocalModelGenerationCoordinatorCancelsSupersededTurn() async {
        let coordinator = LocalModelGenerationCoordinator()
        let firstStarted = expectation(description: "first started")

        let first = Task {
            do {
                _ = try await coordinator.generate(prompt: "first") { _ in
                    firstStarted.fulfill()
                    try await Task.sleep(for: .seconds(2))
                    return "first"
                }
                XCTFail("Expected cancellation")
            } catch {
                XCTAssertEqual(error as? LocalModelError, .generationCancelled)
            }
        }

        await fulfillment(of: [firstStarted], timeout: 2)
        _ = try? await coordinator.generate(prompt: "second") { _ in "second" }
        await first.value
    }

    func testStructuredContextCompressorLabelsRolesAndDeduplicatesSystemLines() {
        let compressor = StructuredContextCompressor(recencyWindow: 8)
        let messages = [
            RuntimeMessage(role: .system, content: "QWON runtime initialized."),
            RuntimeMessage(role: .system, content: "QWON runtime initialized."),
            RuntimeMessage(role: .user, content: "First question"),
            RuntimeMessage(role: .assistant, content: "First answer"),
            RuntimeMessage(role: .user, content: "Second question")
        ]

        let result = compressor.compress(messages: messages, maxEstimatedTokens: 256)

        XCTAssertTrue(result.text.contains("System: QWON runtime initialized."))
        XCTAssertTrue(result.text.contains("User: First question"))
        XCTAssertTrue(result.text.contains("Assistant: First answer"))
        XCTAssertEqual(result.metrics.deduplicatedMessageCount, 1)
        XCTAssertEqual(result.metrics.includedMessageCount, 4)
    }

    func testStructuredContextCompressorReducesLongTranscriptsVersusSuffixFourBaseline() {
        let messages = (1...20).map { index in
            RuntimeMessage(
                role: index.isMultiple(of: 2) ? .assistant : .user,
                content: String(repeating: "a", count: 120) + " message \(index)"
            )
        }

        let structured = StructuredContextCompressor(recencyWindow: 12)
            .compress(messages: messages, maxEstimatedTokens: 96)
        let legacy = LegacySuffixFourContextCompressor()
            .compress(messages: messages, maxEstimatedTokens: 10_000)
        let naiveJoin = messages.map(\.content).joined(separator: "\n")

        XCTAssertLessThan(structured.metrics.outputCharacterCount, naiveJoin.count)
        XCTAssertLessThan(structured.metrics.outputCharacterCount, legacy.text.count)
        XCTAssertLessThanOrEqual(structured.metrics.estimatedTokenCount, 96)
        XCTAssertTrue(structured.text.contains("User:"))
    }

    func testStructuredContextCompressorKeepsChronologicalOrderWhenAllBlocksFit() {
        let messages = [
            RuntimeMessage(role: .user, content: "first"),
            RuntimeMessage(role: .assistant, content: "second"),
            RuntimeMessage(role: .user, content: "third")
        ]

        let result = StructuredContextCompressor(recencyWindow: 8)
            .compress(messages: messages, maxEstimatedTokens: 256)

        XCTAssertEqual(
            result.text,
            """
            User: first
            Assistant: second
            User: third
            """
        )
    }

    func testStructuredContextCompressorRetainsNewestOversizedBlock() {
        let messages = [
            RuntimeMessage(role: .user, content: "older small message"),
            RuntimeMessage(role: .assistant, content: "older assistant reply"),
            RuntimeMessage(role: .user, content: String(repeating: "Z", count: 400))
        ]

        let result = StructuredContextCompressor(recencyWindow: 8)
            .compress(messages: messages, maxEstimatedTokens: 24)

        XCTAssertTrue(result.text.contains("Z"))
        XCTAssertTrue(result.text.hasSuffix("Z") || result.text.contains("…[trimmed]"))
        let lastLine = result.text.split(separator: "\n", omittingEmptySubsequences: false).last.map(String.init) ?? ""
        XCTAssertTrue(lastLine.contains("Z") || lastLine.contains("trimmed"))
    }

    func testStructuredContextCompressorEnforcesTokenBudget() {
        let messages = (1...6).map { index in
            RuntimeMessage(role: .user, content: String(repeating: "x", count: 200) + " \(index)")
        }

        let result = StructuredContextCompressor(recencyWindow: 6)
            .compress(messages: messages, maxEstimatedTokens: 48)

        XCTAssertLessThanOrEqual(result.metrics.estimatedTokenCount, 48)
        XCTAssertGreaterThan(result.metrics.includedMessageCount, 0)
    }
}

private struct LegacySuffixFourContextCompressor: ContextCompressor {
    func compress(messages: [RuntimeMessage], maxEstimatedTokens: Int) -> ContextCompressionResult {
        let text = messages.suffix(4).map(\.content).joined(separator: "\n")
        return ContextCompressionResult(
            text: text,
            metrics: ContextCompressionMetrics(
                inputMessageCount: messages.count,
                includedMessageCount: min(4, messages.count),
                droppedMessageCount: max(0, messages.count - 4),
                deduplicatedMessageCount: 0,
                outputCharacterCount: text.count,
                estimatedTokenCount: TokenEstimate.fromCharacterCount(text.count)
            )
        )
    }
}

private final class CapturingLocalModelClient: LocalModelClient {
    let descriptor = LocalModelDescriptor(
        backend: .embeddedHeuristic,
        name: "Capturing Local Runtime",
        summary: "Test-only local runtime that records prompts."
    )

    private let lock = NSLock()
    private var releaseContinuation: CheckedContinuation<Void, Never>?
    /// True only after `releaseContinuation` is installed; `waitUntilHolding()` waits on this.
    private var isHoldingReady = false

    private(set) var lastPrompt: String?

    func generate(prompt: String) async throws -> String {
        lock.lock()
        lastPrompt = prompt
        lock.unlock()

        try await withTaskCancellationHandler {
            try await holdUntilReleased()
        } onCancel: {
            self.resumeHold()
        }

        try Task.checkCancellation()
        return "Captured local runtime response."
    }

    func waitUntilHolding() async {
        while true {
            lock.lock()
            let ready = isHoldingReady
            lock.unlock()
            if ready { return }
            await Task.yield()
        }
    }

    func releaseActiveTurn() {
        resumeHold()
    }

    private func holdUntilReleased() async throws {
        try await withCheckedContinuation { continuation in
            lock.lock()
            releaseContinuation = continuation
            isHoldingReady = true
            lock.unlock()
        }

        lock.lock()
        isHoldingReady = false
        releaseContinuation = nil
        lock.unlock()
    }

    private func resumeHold() {
        lock.lock()
        let continuation = releaseContinuation
        releaseContinuation = nil
        isHoldingReady = false
        lock.unlock()
        continuation?.resume()
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
