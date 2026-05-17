import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = [
        ChatMessage(role: .system, content: "PREXUS runtime initialized.")
    ]
    @Published private(set) var isSending = false

    private let environment: AppEnvironment

    init(environment: AppEnvironment) {
        self.environment = environment
    }

    func send(text: String) {
        let userMessage = ChatMessage(role: .user, content: text)
        messages.append(userMessage)
        isSending = true

        let transcript = messages
        Task {
            do {
                let output = try await environment.runtime.runTurn(userText: text, transcript: transcript)
                let response = """
                Route: \(output.route.target.rawValue) | Tier: \(output.route.tier.rawValue)
                Reason: \(output.route.reasonSummary)

                \(output.response)
                """
                messages.append(ChatMessage(role: .assistant, content: response))
                environment.memoryLibrary.refresh()
            } catch {
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
