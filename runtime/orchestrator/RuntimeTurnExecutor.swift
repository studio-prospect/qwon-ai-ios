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

    static func image(_ userText: String, sensitivity: SensitivityLevel = .localPreferred) -> RuntimeTurnInput {
        RuntimeTurnInput(
            userText: userText,
            modality: .image,
            sensitivity: sensitivity
        )
    }

    static func audio(_ userText: String, sensitivity: SensitivityLevel = .localPreferred) -> RuntimeTurnInput {
        RuntimeTurnInput(
            userText: userText,
            modality: .audio,
            sensitivity: sensitivity
        )
    }

    static func sensor(_ userText: String, sensitivity: SensitivityLevel = .localPreferred) -> RuntimeTurnInput {
        RuntimeTurnInput(
            userText: userText,
            modality: .sensor,
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
    func previewRoute(input: RuntimeTurnInput) -> RouteDecision {
        let request = RuntimeRequest(
            text: input.userText,
            modality: input.modality,
            sensitivity: input.sensitivity
        )

        return effectiveRoute(for: router.route(request: request))
    }

    func runTurn(input: RuntimeTurnInput, transcript: [RuntimeMessage]) async throws -> RuntimeTurnOutput {
        let request = RuntimeRequest(
            text: input.userText,
            modality: input.modality,
            sensitivity: input.sensitivity
        )
        let route = previewRoute(input: input)
        let compressionBudgetTokens = max(64, config.maxCloudContextTokens / 2)
        let compression = compressor.compress(
            messages: transcript,
            maxEstimatedTokens: compressionBudgetTokens
        )
        let compressedContext = compression.text
        let memoryContext = memoryStore.recent(limit: 3).map(\.summary).joined(separator: "\n")

        let prompt = promptForExecution(
            route: route,
            memoryContext: memoryContext,
            compressedContext: compressedContext,
            userText: input.userText
        )

        let executionResult = try await execute(
            route: route,
            prompt: prompt,
            compressionMetrics: compression.metrics
        )

        if request.sensitivity.allowsAutomaticEpisodicMemory {
            memoryStore.save(
                EpisodicMemory(
                    id: UUID(),
                    summary: input.userText,
                    sensitivity: request.sensitivity,
                    createdAt: Date()
                )
            )
        }

        return RuntimeTurnOutput(
            route: route,
            prompt: prompt,
            response: executionResult.response,
            execution: executionResult.execution
        )
    }

    func runTurn(userText: String, transcript: [RuntimeMessage]) async throws -> RuntimeTurnOutput {
        try await runTurn(
            input: .text(userText),
            transcript: transcript
        )
    }

    private struct TurnExecutionResult {
        let response: String
        let execution: RuntimeExecutionMetadata
    }

    private func execute(
        route: RouteDecision,
        prompt: String,
        compressionMetrics: ContextCompressionMetrics
    ) async throws -> TurnExecutionResult {
        switch route.target {
        case .local:
            LocalModelExecutionTrace.reset()
            let response = try await localModel.generate(prompt: prompt)
            return TurnExecutionResult(
                response: response,
                execution: localModelExecutionMetadata()
            )
        case .openAI, .anthropic, .gemini:
            guard let provider = route.target.cloudProvider else {
                return try await localExecution(prompt: prompt)
            }
            return try await executeCloud(
                provider: provider,
                prompt: prompt,
                compressionMetrics: compressionMetrics
            )
        }
    }

    private func executeCloud(
        provider: CloudProvider,
        prompt: String,
        compressionMetrics: ContextCompressionMetrics
    ) async throws -> TurnExecutionResult {
        guard let apiKey = apiKeyStore.apiKey(for: provider) else {
            return try await localFallback(
                provider: provider,
                prompt: prompt,
                detail: "API key missing. \(localModel.descriptor.summary)"
            )
        }

        do {
            let response = try await cloudModel.generate(
                prompt: prompt,
                provider: provider,
                apiKey: apiKey
            )
            return TurnExecutionResult(
                response: response,
                execution: RuntimeExecutionMetadata(
                    mode: .cloud,
                    provider: provider,
                    model: cloudModelLabel(for: provider),
                    detail: compressionDetail(compressionMetrics, suffix: "Escalated after local routing.")
                )
            )
        } catch {
            LocalModelExecutionTrace.reset()
            let fallbackResponse = try await localModel.generate(prompt: prompt)
            var metadata = localModelExecutionMetadata(provider: provider)
            if metadata.mode == .local {
                metadata = RuntimeExecutionMetadata(
                    mode: .fallback,
                    provider: provider,
                    model: metadata.model,
                    detail: "Cloud request failed. \(metadata.detail ?? localModel.descriptor.summary)"
                )
            }
            return TurnExecutionResult(
                response: "\(provider.displayLabel) request failed. Local fallback used.\n\n\(fallbackResponse)",
                execution: metadata
            )
        }
    }

    private func localExecution(prompt: String) async throws -> TurnExecutionResult {
        LocalModelExecutionTrace.reset()
        let response = try await localModel.generate(prompt: prompt)
        return TurnExecutionResult(
            response: response,
            execution: localModelExecutionMetadata()
        )
    }

    private func localFallback(
        provider: CloudProvider,
        prompt: String,
        detail: String
    ) async throws -> TurnExecutionResult {
        LocalModelExecutionTrace.reset()
        let response = try await localModel.generate(prompt: prompt)
        var metadata = localModelExecutionMetadata(provider: provider, baseDetail: detail)
        if metadata.mode == .local {
            metadata = RuntimeExecutionMetadata(
                mode: .fallback,
                provider: provider,
                model: metadata.model,
                detail: detail
            )
        }
        return TurnExecutionResult(
            response: "\(provider.displayLabel) API key is missing. Local fallback used.\n\n\(response)",
            execution: metadata
        )
    }

    private func localModelExecutionMetadata(
        provider: CloudProvider? = nil,
        baseDetail: String? = nil
    ) -> RuntimeExecutionMetadata {
        let trace = LocalModelExecutionTrace.current
        let usedEmbeddedFallback = trace?.primaryFailure != nil
        let detail = LocalModelExecutionTrace.formattedDetail(
            base: baseDetail ?? localModel.descriptor.summary
        )
        return RuntimeExecutionMetadata(
            mode: usedEmbeddedFallback ? .fallback : .local,
            provider: provider,
            model: trace?.respondingBackend ?? localModel.descriptor.name,
            detail: detail
        )
    }

    private func cloudModelLabel(for provider: CloudProvider) -> String {
        switch provider {
        case .openAI:
            return config.openAIModel
        case .anthropic:
            return "Anthropic"
        case .gemini:
            return "Gemini"
        }
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

    private func compressionDetail(_ metrics: ContextCompressionMetrics, suffix: String) -> String {
        let summary = "Context compressed to ~\(metrics.estimatedTokenCount) tokens (\(metrics.inputMessageCount)→\(metrics.includedMessageCount) messages, \(metrics.deduplicatedMessageCount) deduped)."
        return "\(summary) \(suffix)"
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

private extension RouteTarget {
    var cloudProvider: CloudProvider? {
        switch self {
        case .local:
            return nil
        case .openAI:
            return .openAI
        case .anthropic:
            return .anthropic
        case .gemini:
            return .gemini
        }
    }
}
