import Foundation

protocol LocalModelClient {
    func generate(prompt: String) async throws -> String
}

struct MockLocalModelClient: LocalModelClient {
    func generate(prompt: String) async throws -> String {
        "Local runtime handled the request with compressed context."
    }
}
