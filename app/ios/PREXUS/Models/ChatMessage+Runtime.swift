import Foundation

extension ChatMessage {
    var runtimeMessage: RuntimeMessage {
        RuntimeMessage(role: RuntimeMessage.Role(chatRole: role), content: content)
    }
}

extension Array where Element == ChatMessage {
    var runtimeTranscript: [RuntimeMessage] {
        map(\.runtimeMessage)
    }
}

extension RuntimeContainer {
    func runTurn(input: RuntimeTurnInput, transcript: [ChatMessage]) async throws -> RuntimeTurnOutput {
        try await runTurn(input: input, transcript: transcript.runtimeTranscript)
    }

    func runTurn(userText: String, transcript: [ChatMessage]) async throws -> RuntimeTurnOutput {
        try await runTurn(userText: userText, transcript: transcript.runtimeTranscript)
    }
}

private extension RuntimeMessage.Role {
    init(chatRole: ChatMessage.Role) {
        switch chatRole {
        case .system:
            self = .system
        case .user:
            self = .user
        case .assistant:
            self = .assistant
        }
    }
}
