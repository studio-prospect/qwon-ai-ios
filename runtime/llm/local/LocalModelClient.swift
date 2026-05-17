import Foundation

protocol LocalModelClient {
    func generate(prompt: String) async throws -> String
}

struct MockLocalModelClient: LocalModelClient {
    func generate(prompt: String) async throws -> String {
        "local-response"
    }
}
