import Foundation

struct PromptEnvelope {
    let system: String
    let context: String
    let user: String
}

protocol ProviderAdapter {
    var provider: CloudProvider { get }
    func makePrompt(from envelope: PromptEnvelope) -> String
}
