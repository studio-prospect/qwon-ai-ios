import Foundation

enum CloudProvider: String {
    case openAI
    case anthropic
    case gemini
}

protocol CloudModelClient {
    func generate(prompt: String, provider: CloudProvider) async throws -> String
}

struct MockCloudModelClient: CloudModelClient {
    func generate(prompt: String, provider: CloudProvider) async throws -> String {
        "\(provider.rawValue) handled the escalated request."
    }
}
