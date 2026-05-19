import Foundation

protocol ContextCompressor {
    func compress(messages: [RuntimeMessage]) -> String
}

struct HeuristicContextCompressor: ContextCompressor {
    func compress(messages: [RuntimeMessage]) -> String {
        messages.suffix(4).map(\.content).joined(separator: "\n")
    }
}
