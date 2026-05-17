import Foundation

protocol RetrievalEngine {
    func retrieve(query: String, limit: Int) async throws -> [String]
}
