import Foundation

protocol EmbeddingProvider {
    func embed(text: String) -> [Float]
}

struct StubEmbeddingProvider: EmbeddingProvider {
    func embed(text: String) -> [Float] {
        Array(repeating: 0, count: min(text.count, 8))
    }
}
