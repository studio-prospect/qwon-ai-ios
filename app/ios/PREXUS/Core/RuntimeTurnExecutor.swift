import Foundation

struct RuntimeTurnOutput {
    let route: RouteDecision
    let prompt: String
    let response: String
}

extension RuntimeContainer {
    func runTurn(userText: String, transcript: [ChatMessage]) async throws -> RuntimeTurnOutput {
        let request = RuntimeRequest(
            text: userText,
            modality: .text,
            sensitivity: .localPreferred
        )
        let route = router.route(request: request)
        let compressedContext = compressor.compress(messages: transcript)
        let memoryContext = memoryStore.recent(limit: 3).map(\.summary).joined(separator: "\n")

        let prompt = [
            "Intent route: \(route.reasonSummary)",
            memoryContext.isEmpty ? nil : "Memory:\n\(memoryContext)",
            compressedContext.isEmpty ? nil : "Context:\n\(compressedContext)",
            "User:\n\(userText)"
        ]
        .compactMap { $0 }
        .joined(separator: "\n\n")

        let response: String
        switch route.target {
        case .local:
            response = try await localModel.generate(prompt: prompt)
        case .openAI:
            if apiKeyStore.apiKey(for: .openAI) == nil {
                response = "OpenAI API key is missing. Local fallback used.\n\n" + (try await localModel.generate(prompt: prompt))
            } else {
                response = try await cloudModel.generate(prompt: prompt, provider: .openAI)
            }
        case .anthropic:
            if apiKeyStore.apiKey(for: .anthropic) == nil {
                response = "Anthropic API key is missing. Local fallback used.\n\n" + (try await localModel.generate(prompt: prompt))
            } else {
                response = try await cloudModel.generate(prompt: prompt, provider: .anthropic)
            }
        case .gemini:
            if apiKeyStore.apiKey(for: .gemini) == nil {
                response = "Gemini API key is missing. Local fallback used.\n\n" + (try await localModel.generate(prompt: prompt))
            } else {
                response = try await cloudModel.generate(prompt: prompt, provider: .gemini)
            }
        }

        memoryStore.save(
            EpisodicMemory(
                id: UUID(),
                summary: userText,
                sensitivity: request.sensitivity,
                createdAt: Date()
            )
        )

        return RuntimeTurnOutput(
            route: route,
            prompt: prompt,
            response: response
        )
    }
}
