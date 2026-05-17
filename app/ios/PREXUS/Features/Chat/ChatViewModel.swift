import Foundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = [
        ChatMessage(role: .system, content: "PREXUS runtime initialized.")
    ]

    private let runtime: RuntimeContainer

    init(runtime: RuntimeContainer) {
        self.runtime = runtime
    }

    func send(text: String) {
        let userMessage = ChatMessage(role: .user, content: text)
        messages.append(userMessage)

        let decision = runtime.router.route(
            request: RuntimeRequest(
                text: text,
                modality: .text,
                sensitivity: .localPreferred
            )
        )

        let response = "Route: \(decision.target.rawValue) | Tier: \(decision.tier.rawValue) | Reason: \(decision.reasonSummary)"
        messages.append(ChatMessage(role: .assistant, content: response))
    }
}
