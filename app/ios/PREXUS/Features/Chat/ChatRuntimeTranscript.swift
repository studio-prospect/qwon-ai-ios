import Foundation

enum ChatRuntimeTranscript {
    static func messages(
        from messages: [ChatMessage],
        replacingInFlightTurn: Bool
    ) -> [ChatMessage] {
        var transcript = messages
        if replacingInFlightTurn,
           let lastMessage = transcript.last,
           lastMessage.role == .user {
            transcript.removeLast()
        }
        return transcript
    }
}
