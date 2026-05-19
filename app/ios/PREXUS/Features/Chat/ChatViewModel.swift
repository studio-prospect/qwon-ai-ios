import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var selectedSensitivity: SensitivityLevel = .localPreferred
    @Published var draftText = ""
    @Published private(set) var messages: [ChatMessage] = [
        ChatMessage(role: .system, content: "PREXUS runtime initialized.")
    ]
    @Published private(set) var isSending = false
    @Published private(set) var latestExecution: RuntimeExecutionMetadata?
    @Published private(set) var activeTurnSensitivity: SensitivityLevel?
    @Published private(set) var activeRoute: RouteDecision?
    @Published private(set) var forcedPreviewRoute: RouteDecision?

    private let environment: AppEnvironment

    init(environment: AppEnvironment) {
        self.environment = environment
    }

    init(
        environment: AppEnvironment,
        selectedSensitivity: SensitivityLevel,
        draftText: String,
        messages: [ChatMessage],
        isSending: Bool,
        latestExecution: RuntimeExecutionMetadata?,
        activeTurnSensitivity: SensitivityLevel?,
        activeRoute: RouteDecision?,
        forcedPreviewRoute: RouteDecision? = nil
    ) {
        self.environment = environment
        self.selectedSensitivity = selectedSensitivity
        self.draftText = draftText
        self.messages = messages
        self.isSending = isSending
        self.latestExecution = latestExecution
        self.activeTurnSensitivity = activeTurnSensitivity
        self.activeRoute = activeRoute
        self.forcedPreviewRoute = forcedPreviewRoute
    }

    var previewRoute: RouteDecision? {
        let trimmed = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return environment.runtime.previewRoute(
            input: .text(trimmed, sensitivity: selectedSensitivity)
        )
    }

    var displayedRoute: RouteDecision? {
        isSending ? activeRoute : (forcedPreviewRoute ?? previewRoute)
    }

    var displayedSensitivity: SensitivityLevel {
        if isSending, let activeTurnSensitivity {
            return activeTurnSensitivity
        }

        return selectedSensitivity
    }

    var routeBannerTitle: String {
        isSending ? "Executing Route" : "Planned Route"
    }

    var sendStateSummary: String? {
        guard isSending, let activeRoute else { return nil }
        return "\(displayedSensitivity.displayLabel) | \(activeRoute.statusSummary)"
    }

    func send(text: String) {
        let userMessage = ChatMessage(role: .user, content: text)
        let sensitivity = selectedSensitivity
        let route = environment.runtime.previewRoute(
            input: .text(text, sensitivity: sensitivity)
        )
        messages.append(userMessage)
        isSending = true
        forcedPreviewRoute = nil
        activeTurnSensitivity = sensitivity
        activeRoute = route
        draftText = ""

        let transcript = messages
        Task {
            do {
                let output = try await environment.runtime.runTurn(
                    input: .text(text, sensitivity: sensitivity),
                    transcript: transcript
                )
                messages.append(ChatMessage(role: .assistant, content: output.response))
                latestExecution = output.execution
                environment.runtimeDiagnostics.record(
                    route: output.route,
                    execution: output.execution,
                    userText: text
                )
                environment.memoryLibrary.refresh()
            } catch {
                latestExecution = nil
                messages.append(
                    ChatMessage(
                        role: .assistant,
                        content: "Runtime error: \(error.localizedDescription)"
                    )
                )
            }

            activeTurnSensitivity = nil
            activeRoute = nil
            isSending = false
        }
    }

}

extension ChatViewModel {
    static func seededRuntimeSurfaces(environment: AppEnvironment) -> ChatViewModel {
        let selectedSensitivity: SensitivityLevel = .providerRestricted
        let draftText = "Review this runtime policy branch for fallback risks."

        return ChatViewModel(
            environment: environment,
            selectedSensitivity: selectedSensitivity,
            draftText: draftText,
            messages: [
                ChatMessage(role: .system, content: "PREXUS runtime initialized."),
                ChatMessage(role: .user, content: "Give me a quick routing sanity check."),
                ChatMessage(role: .assistant, content: "I can preview the route, show why it stays local or escalates, and keep the secondary runtime surfaces ready for capture.")
            ],
            isSending: false,
            latestExecution: nil,
            activeTurnSensitivity: nil,
            activeRoute: nil,
            forcedPreviewRoute: RouteDecision(
                tier: .tier3,
                target: .local,
                reasonCodes: ["codeAnalysis", "provider_restricted", "provider_not_approved"]
            )
        )
    }
}

#if DEBUG
extension ChatViewModel {
    static func previewPlannedRoute() -> ChatViewModel {
        let environment = previewEnvironment()
        return ChatViewModel(
            environment: environment,
            selectedSensitivity: .escalationAllowed,
            draftText: "Review this runtime policy change for edge cases.",
            messages: [
                ChatMessage(role: .system, content: "PREXUS runtime initialized."),
                ChatMessage(role: .user, content: "Can you help audit the routing policy?"),
                ChatMessage(role: .assistant, content: "Yes — I can review the policy and call out escalation and fallback risks.")
            ],
            isSending: false,
            latestExecution: RuntimeExecutionMetadata(
                mode: .local,
                provider: nil,
                model: "On-device runtime",
                detail: "Recent turns stayed local."
            ),
            activeTurnSensitivity: nil,
            activeRoute: nil,
            forcedPreviewRoute: nil
        )
    }

    static func previewInFlight() -> ChatViewModel {
        let environment = previewEnvironment()
        return ChatViewModel(
            environment: environment,
            selectedSensitivity: .providerRestricted,
            draftText: "",
            messages: [
                ChatMessage(role: .system, content: "PREXUS runtime initialized."),
                ChatMessage(role: .user, content: "Inspect this code path for concurrency issues.")
            ],
            isSending: true,
            latestExecution: nil,
            activeTurnSensitivity: .providerRestricted,
            activeRoute: RouteDecision(
                tier: .tier3,
                target: .openAI,
                reasonCodes: ["codeAnalysis", "provider_restricted"]
            ),
            forcedPreviewRoute: nil
        )
    }

    static func previewConversation() -> ChatViewModel {
        let environment = previewEnvironment()
        return ChatViewModel(
            environment: environment,
            selectedSensitivity: .localPreferred,
            draftText: "",
            messages: [
                ChatMessage(role: .system, content: "PREXUS runtime initialized."),
                ChatMessage(role: .user, content: "Summarize the latest routing changes."),
                ChatMessage(role: .assistant, content: "The runtime now treats restricted providers as an allowlist policy, keeps local-only turns on device, and surfaces routing reasons through compact status chips."),
                ChatMessage(role: .user, content: "What should we polish next?"),
                ChatMessage(role: .assistant, content: "The next highest-value pass is visual: tighten the message rhythm, keep runtime state compact, and verify the composer still reads as one control surface.")
            ],
            isSending: false,
            latestExecution: RuntimeExecutionMetadata(
                mode: .fallback,
                provider: .openAI,
                model: "gpt-5-mini",
                detail: "Cloud key unavailable, local fallback used."
            ),
            activeTurnSensitivity: nil,
            activeRoute: nil,
            forcedPreviewRoute: nil
        )
    }

    private static func previewEnvironment() -> AppEnvironment {
        let apiKeyStore = InMemoryAPIKeyStore()
        let suiteName = "PREXUS.ChatViewModelPreview.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        let settings = AppSettingsStore(defaults: defaults, apiKeyStore: apiKeyStore)
        settings.config.allowsCloudEscalation = true
        settings.config.approvedProvidersForRestrictedMode = [.openAI]
        apiKeyStore.setAPIKey("preview-openai-key", for: .openAI)
        let diagnosticsStore = RuntimeDiagnosticsStore(defaults: defaults)
        return AppEnvironment(
            settings: settings,
            apiKeyStore: apiKeyStore,
            memoryStore: InMemoryEpisodicMemoryStore(),
            runtimeDiagnosticsStore: diagnosticsStore,
            launchScenario: .standard
        )
    }
}
#endif
