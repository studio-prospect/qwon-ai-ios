import Foundation

struct FallbackLocalModelClient: LocalModelClient {
    let primary: LocalModelClient
    let fallback: LocalModelClient

    var descriptor: LocalModelDescriptor {
        LocalModelDescriptor(
            backend: primary.descriptor.backend,
            name: primary.descriptor.name,
            summary: "\(primary.descriptor.summary) Falls back to \(fallback.descriptor.name) when unavailable."
        )
    }

    func generate(prompt: String) async throws -> String {
        do {
            return try await primary.generate(prompt: prompt)
        } catch {
            return try await fallback.generate(prompt: prompt)
        }
    }
}
