import Foundation

enum RuntimeExecutionMode: String, Equatable {
    case local
    case cloud
    case fallback
}

struct RuntimeExecutionMetadata: Equatable {
    let mode: RuntimeExecutionMode
    let provider: CloudProvider?
    let model: String?
    let detail: String?

    var statusSummary: String {
        let headline: String
        switch mode {
        case .local:
            headline = "Local runtime"
        case .cloud:
            headline = "Cloud execution"
        case .fallback:
            headline = "Local fallback"
        }

        let providerPart = provider?.rawValue
        let modelPart = model
        let path = [providerPart, modelPart].compactMap { $0 }.joined(separator: " / ")

        if let detail, !detail.isEmpty {
            if path.isEmpty {
                return "\(headline) | \(detail)"
            }
            return "\(headline) | \(path) | \(detail)"
        }

        if path.isEmpty {
            return headline
        }

        return "\(headline) | \(path)"
    }
}

struct RuntimeTurnOutput {
    let route: RouteDecision
    let prompt: String
    let response: String
    let execution: RuntimeExecutionMetadata
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
        let execution: RuntimeExecutionMetadata
        switch route.target {
        case .local:
            response = try await localModel.generate(prompt: prompt)
            execution = RuntimeExecutionMetadata(
                mode: .local,
                provider: nil,
                model: nil,
                detail: "Handled on device."
            )
        case .openAI:
            if let apiKey = apiKeyStore.apiKey(for: .openAI) {
                do {
                    response = try await cloudModel.generate(
                        prompt: prompt,
                        provider: .openAI,
                        apiKey: apiKey
                    )
                    execution = RuntimeExecutionMetadata(
                        mode: .cloud,
                        provider: .openAI,
                        model: config.openAIModel,
                        detail: "Escalated after local routing."
                    )
                } catch {
                    response = "OpenAI request failed. Local fallback used.\n\n" + (try await localModel.generate(prompt: prompt))
                    execution = RuntimeExecutionMetadata(
                        mode: .fallback,
                        provider: .openAI,
                        model: nil,
                        detail: "Cloud request failed."
                    )
                }
            } else {
                response = "OpenAI API key is missing. Local fallback used.\n\n" + (try await localModel.generate(prompt: prompt))
                execution = RuntimeExecutionMetadata(
                    mode: .fallback,
                    provider: .openAI,
                    model: nil,
                    detail: "API key missing."
                )
            }
        case .anthropic:
            if let apiKey = apiKeyStore.apiKey(for: .anthropic) {
                response = try await cloudModel.generate(
                    prompt: prompt,
                    provider: .anthropic,
                    apiKey: apiKey
                )
                execution = RuntimeExecutionMetadata(
                    mode: .cloud,
                    provider: .anthropic,
                    model: "Anthropic",
                    detail: "Escalated after local routing."
                )
            } else {
                response = "Anthropic API key is missing. Local fallback used.\n\n" + (try await localModel.generate(prompt: prompt))
                execution = RuntimeExecutionMetadata(
                    mode: .fallback,
                    provider: .anthropic,
                    model: nil,
                    detail: "API key missing."
                )
            }
        case .gemini:
            if let apiKey = apiKeyStore.apiKey(for: .gemini) {
                response = try await cloudModel.generate(
                    prompt: prompt,
                    provider: .gemini,
                    apiKey: apiKey
                )
                execution = RuntimeExecutionMetadata(
                    mode: .cloud,
                    provider: .gemini,
                    model: "Gemini",
                    detail: "Escalated after local routing."
                )
            } else {
                response = "Gemini API key is missing. Local fallback used.\n\n" + (try await localModel.generate(prompt: prompt))
                execution = RuntimeExecutionMetadata(
                    mode: .fallback,
                    provider: .gemini,
                    model: nil,
                    detail: "API key missing."
                )
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
            response: response,
            execution: execution
        )
    }
}
