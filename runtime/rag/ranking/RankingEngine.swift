import Foundation

protocol RankingEngine {
    func rank(documents: [String], query: String) -> [String]
}
