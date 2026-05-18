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
                let response = """
                Route: \(output.route.statusSummary)
                Reason: \(output.route.displayReasonSummary)
                Execution: \(output.execution.statusSummary)

                \(output.response)
                """
                messages.append(ChatMessage(role: .assistant, content: response))
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
