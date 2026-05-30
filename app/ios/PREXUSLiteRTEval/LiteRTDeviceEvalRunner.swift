import Foundation
import LiteRTLM

enum LiteRTDeviceEvalRunner {
    private static let completedKey = "prexus.litertDeviceEval.completed.v2"

    static func runIfNeeded() {
        guard UserDefaults.standard.bool(forKey: completedKey) == false else { return }
        Task(priority: .userInitiated) {
            let didComplete = await run()
            if didComplete {
                UserDefaults.standard.set(true, forKey: completedKey)
            }
        }
    }

    @discardableResult
    static func run() async -> Bool {
        guard let modelPath = LiteRTModelPlacement.resolvedModelPath else {
            LiteRTDeviceEvalLog.append("blocked model-missing path=Documents/Models/\(LiteRTModelPlacement.evaluationModelFileName)")
            return false
        }

        LiteRTDeviceEvalLog.append("eval-start model=\(URL(fileURLWithPath: modelPath).lastPathComponent) backend=gpu")

        let coldStart = CFAbsoluteTimeGetCurrent()
        do {
            let engineConfig = try EngineConfig(
                modelPath: modelPath,
                backend: .gpu,
                maxNumTokens: 512,
                cacheDir: NSTemporaryDirectory()
            )
            let engine = Engine(engineConfig: engineConfig)
            try await engine.initialize()
            let coldLoadMs = (CFAbsoluteTimeGetCurrent() - coldStart) * 1000.0
            LiteRTDeviceEvalLog.append(String(format: "cold_load_ms=%.1f", coldLoadMs))

            try await runJapaneseSmoke(engine: engine)
            try await runRoutingJSONSmoke(engine: engine)

            LiteRTDeviceEvalLog.append("eval-complete")
            return true
        } catch {
            LiteRTDeviceEvalLog.append("eval-failed error=\(error.localizedDescription)")
            return false
        }
    }

    private static func runJapaneseSmoke(engine: Engine) async throws {
        let config = ConversationConfig(
            systemMessage: Message("You are PREXUS local assistant. Reply briefly in natural Japanese.")
        )
        let conversation = try await engine.createConversation(with: config)
        let prompt = Message("明日の予定を整理する時、最初に何を確認すべきですか？")
        let generationStart = CFAbsoluteTimeGetCurrent()
        var firstTokenMs: Double?
        var response = ""

        for try await chunk in conversation.sendMessageStream(prompt) {
            if firstTokenMs == nil {
                firstTokenMs = (CFAbsoluteTimeGetCurrent() - generationStart) * 1000.0
            }
            response += chunk.toString
        }

        let totalMs = (CFAbsoluteTimeGetCurrent() - generationStart) * 1000.0
        let tokenEstimate = max(1, response.split { $0.isWhitespace || $0.isNewline }.count)
        let decodeTps = tokenEstimate > 0 ? Double(tokenEstimate) / (totalMs / 1000.0) : 0

        LiteRTDeviceEvalLog.append(
            String(
                format: "ja-first_token_ms=%.1f ja_total_ms=%.1f ja_decode_tps=%.1f",
                firstTokenMs ?? -1,
                totalMs,
                decodeTps
            )
        )
        LiteRTDeviceEvalLog.append("ja-response=\(response.prefix(240))")
    }

    private static func runRoutingJSONSmoke(engine: Engine) async throws {
        let config = ConversationConfig(
            systemMessage: Message(
                "Reply with compact JSON only. Keys: intent, confidence, needs_cloud."
            )
        )
        let conversation = try await engine.createConversation(with: config)
        let prompt = Message(
            """
            Classify intent as JSON: chat|summarize|memory_write|tool_request|cloud_needed.
            User: このメールを要約して
            """
        )
        let generationStart = CFAbsoluteTimeGetCurrent()
        let response = try await conversation.sendMessage(prompt)
        let totalMs = (CFAbsoluteTimeGetCurrent() - generationStart) * 1000.0
        let text = response.toString
        LiteRTDeviceEvalLog.append(String(format: "routing_total_ms=%.1f", totalMs))
        LiteRTDeviceEvalLog.append("routing-response=\(text.prefix(240))")
    }
}
