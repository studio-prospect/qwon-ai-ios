import Foundation

struct ContextCompressionMetrics: Equatable {
    let inputMessageCount: Int
    let includedMessageCount: Int
    let droppedMessageCount: Int
    let deduplicatedMessageCount: Int
    let outputCharacterCount: Int
    let estimatedTokenCount: Int
}

struct ContextCompressionResult: Equatable {
    let text: String
    let metrics: ContextCompressionMetrics

    static let empty = ContextCompressionResult(
        text: "",
        metrics: ContextCompressionMetrics(
            inputMessageCount: 0,
            includedMessageCount: 0,
            droppedMessageCount: 0,
            deduplicatedMessageCount: 0,
            outputCharacterCount: 0,
            estimatedTokenCount: 0
        )
    )
}
