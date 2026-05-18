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
        activeRoute: RouteDecision?
    ) {
        self.environment = environment
        self.selectedSensitivity = selectedSensitivity
        self.draftText = draftText
        self.messages = messages
        self.isSending = isSending
        self.latestExecution = latestExecution
        self.activeTurnSensitivity = activeTurnSensitivity
        self.activeRoute = activeRoute
    }

    var previewRoute: RouteDecision? {
        let trimmed = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return environment.runtime.previewRoute(
            input: .text(trimmed, sensitivity: selectedSensitivity)
        )
    }

    var displayedRoute: RouteDecision? {
        isSending ? activeRoute : previewRoute
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
            activeRoute: nil
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
            )
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
            activeRoute: nil
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
        return AppEnvironment(
            settings: settings,
            apiKeyStore: apiKeyStore,
            memoryStore: InMemoryEpisodicMemoryStore()
        )
    }
}
#endif
