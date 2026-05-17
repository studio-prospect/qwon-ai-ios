import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var selectedSensitivity: SensitivityLevel = .localPreferred
    @Published private(set) var messages: [ChatMessage] = [
        ChatMessage(role: .system, content: "PREXUS runtime initialized.")
    ]
    @Published private(set) var isSending = false
    @Published private(set) var latestExecution: RuntimeExecutionMetadata?

    private let environment: AppEnvironment

    init(environment: AppEnvironment) {
        self.environment = environment
    }

    func send(text: String) {
        let userMessage = ChatMessage(role: .user, content: text)
        let sensitivity = selectedSensitivity
        messages.append(userMessage)
        isSending = true

        let transcript = messages
        Task {
            do {
                let output = try await environment.runtime.runTurn(
                    input: .text(text, sensitivity: sensitivity),
                    transcript: transcript
                )
                let response = """
                Route: \(output.route.target.rawValue) | Tier: \(output.route.tier.rawValue)
                Reason: \(output.route.reasonSummary)
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

            isSending = false
        }
    }
}
