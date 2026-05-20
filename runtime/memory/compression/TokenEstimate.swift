import Foundation

enum TokenEstimate {
    static let charactersPerToken = 4

    static func fromCharacterCount(_ count: Int) -> Int {
        guard count > 0 else { return 0 }
        return (count + charactersPerToken - 1) / charactersPerToken
    }

    static func characterBudget(forTokens tokens: Int) -> Int {
        max(0, tokens) * charactersPerToken
    }
}
