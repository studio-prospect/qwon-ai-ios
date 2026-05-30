#if PREXUS_LITERT_LM_PROTOTYPE
import Foundation
import LiteRTLM

/// Debug-gated LiteRT-LM client for Gemma 4 E2B `.litertlm` evaluation on A17 Pro+.
final class LiteRTLocalModelClient: LocalModelClient {
    private let engineHolder = LiteRTEngineHolder()

    var descriptor: LocalModelDescriptor {
        LocalModelDescriptor(
            backend: .deviceRuntime,
            name: "LiteRT-LM Prototype Runtime",
            summary: "LiteRT-LM Gemma 4 E2B (.litertlm) on Metal — debug prototype only."
        )
    }

    func generate(prompt: String) async throws -> String {
        guard LiteRTPrototypeSettings.isRuntimeAvailable else {
            throw LocalModelError.backendUnavailable("LiteRT prototype unavailable (toggle, device class, or model artifact).")
        }

        guard let modelPath = LiteRTModelPlacement.resolvedModelURL?.path else {
            throw LocalModelError.modelAssetUnavailable
        }

        let metrics = try await engineHolder.generate(prompt: prompt, modelPath: modelPath)
        LocalModelExecutionTrace.record(
            respondingBackend: descriptor.name,
            metricsDetail: metrics.formatted
        )
        return metrics.response
    }
}

private struct LiteRTGenerationMetrics {
    let response: String
    let coldLoadMs: Double
    let firstTokenMs: Double
    let totalMs: Double

    var formatted: String {
        String(
            format: "cold_load_ms=%.1f first_token_ms=%.1f total_ms=%.1f",
            coldLoadMs,
            firstTokenMs,
            totalMs
        )
    }
}

private actor LiteRTEngineHolder {
    private var engine: Engine?

    func generate(prompt: String, modelPath: String) async throws -> LiteRTGenerationMetrics {
        let coldStart = CFAbsoluteTimeGetCurrent()
        if engine == nil {
            let config = try EngineConfig(
                modelPath: modelPath,
                backend: .gpu,
                maxNumTokens: 512,
                cacheDir: NSTemporaryDirectory()
            )
            let created = Engine(engineConfig: config)
            try await created.initialize()
            engine = created
        }
        let coldLoadMs = (CFAbsoluteTimeGetCurrent() - coldStart) * 1000.0

        guard let engine else {
            throw LocalModelError.backendUnavailable("LiteRT engine missing after init")
        }

        let conversation = try await engine.createConversation(
            with: ConversationConfig(
                systemMessage: Message("You are PREXUS local assistant. Reply briefly in natural Japanese when asked in Japanese.")
            )
        )

        let generationStart = CFAbsoluteTimeGetCurrent()
        var firstTokenMs: Double?
        var response = ""

        for try await chunk in conversation.sendMessageStream(Message(prompt)) {
            if firstTokenMs == nil {
                firstTokenMs = (CFAbsoluteTimeGetCurrent() - generationStart) * 1000.0
            }
            response += chunk.toString
        }

        let totalMs = (CFAbsoluteTimeGetCurrent() - generationStart) * 1000.0
        let trimmed = response.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw LocalModelError.generationFailed("LiteRT returned empty output")
        }

        return LiteRTGenerationMetrics(
            response: trimmed,
            coldLoadMs: coldLoadMs,
            firstTokenMs: firstTokenMs ?? totalMs,
            totalMs: totalMs
        )
    }
}
#endif
