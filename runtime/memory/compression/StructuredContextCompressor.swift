import Foundation

struct StructuredContextCompressor: ContextCompressor {
    var recencyWindow: Int = 12
    var minimumReservedTokens: Int = 32

    func compress(messages: [RuntimeMessage], maxEstimatedTokens: Int) -> ContextCompressionResult {
        let inputCount = messages.count
        guard inputCount > 0 else { return .empty }

        let budgetTokens = max(minimumReservedTokens, maxEstimatedTokens)
        let characterBudget = TokenEstimate.characterBudget(forTokens: budgetTokens)

        let normalized = normalize(messages: messages)
        let deduplicated = deduplicate(messages: normalized)
        let deduplicatedCount = normalized.count - deduplicated.count

        let windowed = Array(deduplicated.suffix(recencyWindow))
        let blocks = windowed.map(formatBlock)
        let packed = packBlocks(blocks, characterBudget: characterBudget)

        let output = packed.text
        let metrics = ContextCompressionMetrics(
            inputMessageCount: inputCount,
            includedMessageCount: packed.includedBlockCount,
            droppedMessageCount: max(0, deduplicated.count - packed.includedBlockCount),
            deduplicatedMessageCount: deduplicatedCount,
            outputCharacterCount: output.count,
            estimatedTokenCount: TokenEstimate.fromCharacterCount(output.count)
        )

        return ContextCompressionResult(text: output, metrics: metrics)
    }

    private func normalize(messages: [RuntimeMessage]) -> [RuntimeMessage] {
        messages.compactMap { message in
            let trimmed = message.content.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return nil }
            return RuntimeMessage(role: message.role, content: trimmed)
        }
    }

    private func deduplicate(messages: [RuntimeMessage]) -> [RuntimeMessage] {
        var seen = Set<String>()
        var result: [RuntimeMessage] = []

        for message in messages {
            let key = "\(message.role.rawValue)|\(message.content)"
            guard seen.insert(key).inserted else { continue }
            result.append(message)
        }

        return result
    }

    private func formatBlock(_ message: RuntimeMessage) -> String {
        "\(roleLabel(for: message.role)): \(message.content)"
    }

    private func roleLabel(for role: RuntimeMessage.Role) -> String {
        switch role {
        case .system:
            return "System"
        case .user:
            return "User"
        case .assistant:
            return "Assistant"
        }
    }

    private func packBlocks(_ blocks: [String], characterBudget: Int) -> (text: String, includedBlockCount: Int) {
        guard !blocks.isEmpty else { return ("", 0) }

        var selected: [String] = []
        var usedCharacters = 0

        for block in blocks.reversed() {
            let separatorCost = selected.isEmpty ? 0 : 1
            let blockCost = block.count + separatorCost
            if usedCharacters + blockCost > characterBudget {
                continue
            }
            selected.append(block)
            usedCharacters += blockCost
        }

        if selected.isEmpty, let last = blocks.last {
            let truncated = truncateBlock(last, maxCharacters: max(characterBudget, 1))
            return (truncated, 1)
        }

        return (selected.reversed().joined(separator: "\n"), selected.count)
    }

    private func truncateBlock(_ block: String, maxCharacters: Int) -> String {
        guard block.count > maxCharacters else { return block }
        let limit = max(1, maxCharacters - 12)
        return String(block.prefix(limit)) + "…[trimmed]"
    }
}
