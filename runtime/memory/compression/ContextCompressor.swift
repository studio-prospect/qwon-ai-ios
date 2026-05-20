import Foundation

protocol ContextCompressor {
    func compress(messages: [RuntimeMessage], maxEstimatedTokens: Int) -> ContextCompressionResult
}

/// Default Phase 1 compressor (P1-2): structured blocks, dedup, and token budget.
typealias HeuristicContextCompressor = StructuredContextCompressor

extension ContextCompressor {
    func compress(messages: [RuntimeMessage]) -> ContextCompressionResult {
        compress(messages: messages, maxEstimatedTokens: 512)
    }
}
