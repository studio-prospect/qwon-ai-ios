import Foundation

struct RuntimeTurnInput {
    let userText: String
    let modality: RuntimeModality
    let sensitivity: SensitivityLevel

    static func text(_ userText: String, sensitivity: SensitivityLevel = .localPreferred) -> RuntimeTurnInput {
        RuntimeTurnInput(
            userText: userText,
            modality: .text,
            sensitivity: sensitivity
        )
    }
}

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
    func runTurn(input: RuntimeTurnInput, transcript: [ChatMessage]) async throws -> RuntimeTurnOutput {
        let request = RuntimeRequest(
            text: input.userText,
            modality: input.modality,
            sensitivity: input.sensitivity
        )
        let route = effectiveRoute(for: router.route(request: request))
        let compressedContext = compressor.compress(messages: transcript)
        let memoryContext = memoryStore.recent(limit: 3).map(\.summary).joined(separator: "\n")

        let prompt = promptForExecution(
            route: route,
            memoryContext: memoryContext,
            compressedContext: compressedContext,
            userText: input.userText
        )

        let response: String
        let execution: RuntimeExecutionMetadata
        switch route.target {
        case .local:
            response = try await localModel.generate(prompt: prompt)
            execution = RuntimeExecutionMetadata(
                mode: .local,
                provider: nil,
                model: localModel.descriptor.name,
                detail: localModel.descriptor.summary
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
                        model: localModel.descriptor.name,
                        detail: "Cloud request failed. \(localModel.descriptor.summary)"
                    )
                }
            } else {
                response = "OpenAI API key is missing. Local fallback used.\n\n" + (try await localModel.generate(prompt: prompt))
                execution = RuntimeExecutionMetadata(
                    mode: .fallback,
                    provider: .openAI,
                    model: localModel.descriptor.name,
                    detail: "API key missing. \(localModel.descriptor.summary)"
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
                    model: localModel.descriptor.name,
                    detail: "API key missing. \(localModel.descriptor.summary)"
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
                    model: localModel.descriptor.name,
                    detail: "API key missing. \(localModel.descriptor.summary)"
                )
            }
        }

        memoryStore.save(
            EpisodicMemory(
                id: UUID(),
                summary: input.userText,
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

    func runTurn(userText: String, transcript: [ChatMessage]) async throws -> RuntimeTurnOutput {
        try await runTurn(
            input: .text(userText),
            transcript: transcript
        )
    }

    private func promptForExecution(
        route: RouteDecision,
        memoryContext: String,
        compressedContext: String,
        userText: String
    ) -> String {
        let shouldBudgetForCloud = route.target != .local
        let budgetedMemory = shouldBudgetForCloud
            ? trimToApproximateTokenBudget(memoryContext, maxTokens: config.maxCloudContextTokens / 4)
            : memoryContext
        let budgetedContext = shouldBudgetForCloud
            ? trimToApproximateTokenBudget(compressedContext, maxTokens: config.maxCloudContextTokens / 2)
            : compressedContext

        let prompt = [
            "Intent route: \(route.reasonSummary)",
            budgetedMemory.isEmpty ? nil : "Memory:\n\(budgetedMemory)",
            budgetedContext.isEmpty ? nil : "Context:\n\(budgetedContext)",
            "User:\n\(userText)"
        ]
        .compactMap { $0 }
        .joined(separator: "\n\n")

        return shouldBudgetForCloud
            ? trimToApproximateTokenBudget(prompt, maxTokens: config.maxCloudContextTokens)
            : prompt
    }

    private func effectiveRoute(for route: RouteDecision) -> RouteDecision {
        switch route.target {
        case .local:
            return route
        case .openAI:
            return apiKeyStore.apiKey(for: .openAI) == nil
                ? route.reroutedToLocal(appending: "openai_key_unavailable")
                : route
        case .anthropic:
            return apiKeyStore.apiKey(for: .anthropic) == nil
                ? route.reroutedToLocal(appending: "anthropic_key_unavailable")
                : route
        case .gemini:
            return apiKeyStore.apiKey(for: .gemini) == nil
                ? route.reroutedToLocal(appending: "gemini_key_unavailable")
                : route
        }
    }

    private func trimToApproximateTokenBudget(_ text: String, maxTokens: Int) -> String {
        guard !text.isEmpty else { return text }
        let safeBudget = max(32, maxTokens)
        let maxCharacters = safeBudget * 4

        guard text.count > maxCharacters else { return text }

        let trimmedPrefix = text.prefix(max(0, maxCharacters - 24))
        return String(trimmedPrefix) + "\n...[trimmed]"
    }
}
