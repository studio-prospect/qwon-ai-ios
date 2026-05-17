import Foundation

protocol ContextCompressor {
    func compress(messages: [ChatMessage]) -> String
}

struct HeuristicContextCompressor: ContextCompressor {
    func compress(messages: [ChatMessage]) -> String {
        messages.suffix(4).map(\.content).joined(separator: "\n")
    }
}
