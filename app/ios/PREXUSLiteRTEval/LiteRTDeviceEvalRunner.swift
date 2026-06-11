import Darwin.Mach
import Foundation
import LiteRTLM

enum LiteRTDeviceEvalRunner {
    private static var completedKey: String {
        LiteRTModelPlacement.isE4BEvaluation
            ? "prexus.litertDeviceEval.completed.e4b.v1"
            : "prexus.litertDeviceEval.completed.v2"
    }

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
            LiteRTDeviceEvalLog.append(
                "blocked model-missing path=Documents/Models/\(LiteRTModelPlacement.evaluationModelFileName)"
            )
            return false
        }

        let variant = LiteRTModelPlacement.isE4BEvaluation ? "e4b" : "e2b"
        LiteRTDeviceEvalLog.append(
            "eval-start variant=\(variant) model=\(URL(fileURLWithPath: modelPath).lastPathComponent) backend=gpu"
        )

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
            if let footprintMB = physicalMemoryFootprintMB() {
                LiteRTDeviceEvalLog.append(String(format: "memory_footprint_mb=%.1f", footprintMB))
            }

            if LiteRTModelPlacement.isE4BEvaluation {
                try await runE4BJapaneseSmoke(engine: engine)
                try await runE4BRoutingJSONSmoke(engine: engine)
                try await runE4BControlPlaneSummarySmoke(engine: engine)
            } else {
                try await runJapaneseSmoke(engine: engine)
                try await runRoutingJSONSmoke(engine: engine)
            }

            LiteRTDeviceEvalLog.append("eval-complete")
            return true
        } catch {
            let blocker = classifyFailure(error)
            LiteRTDeviceEvalLog.append("eval-failed blocker=\(blocker) error=\(error.localizedDescription)")
            return false
        }
    }

    private static func classifyFailure(_ error: Error) -> String {
        let message = error.localizedDescription.lowercased()
        if message.contains("memory") || message.contains("oom") {
            return "memory"
        }
        if message.contains("engine") || message.contains("load") || message.contains("model") {
            return "runtime_support"
        }
        return "model_behavior"
    }

    private static func physicalMemoryFootprintMB() -> Double? {
        var info = task_vm_info_data_t()
        var count = mach_msg_type_number_t(
            MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<natural_t>.size
        )
        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        guard result == KERN_SUCCESS else { return nil }
        return Double(info.phys_footprint) / 1_048_576.0
    }

    private static func runJapaneseSmoke(engine: Engine) async throws {
        let config = ConversationConfig(
            systemMessage: Message("You are PREXUS local assistant. Reply briefly in natural Japanese.")
        )
        let conversation = try await engine.createConversation(with: config)
        let prompt = Message("明日の予定を整理する時、最初に何を確認すべきですか？")
        try await logStreamingGeneration(
            conversation: conversation,
            prompt: prompt,
            prefix: "ja"
        )
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

    private static func runE4BJapaneseSmoke(engine: Engine) async throws {
        let config = ConversationConfig(
            systemMessage: Message("あなたはQWONのローカル補助モデルです。短く自然な日本語で答えてください。")
        )
        let conversation = try await engine.createConversation(with: config)
        let prompt = Message("明日の予定を整理する時、最初に何を確認すべきですか？")
        try await logStreamingGeneration(
            conversation: conversation,
            prompt: prompt,
            prefix: "ja"
        )
    }

    private static func runE4BRoutingJSONSmoke(engine: Engine) async throws {
        let config = ConversationConfig(
            systemMessage: Message(
                "Return only valid JSON with keys: intent, confidence, needs_cloud."
            )
        )
        let conversation = try await engine.createConversation(with: config)
        let prompt = Message(
            """
            Classify the user intent as one of: chat, summarize, memory_write, tool_request, cloud_needed.
            User: この長いメモを3点に要約して、あとで見返せるようにして
            """
        )
        let generationStart = CFAbsoluteTimeGetCurrent()
        let response = try await conversation.sendMessage(prompt)
        let totalMs = (CFAbsoluteTimeGetCurrent() - generationStart) * 1000.0
        let text = response.toString
        LiteRTDeviceEvalLog.append(String(format: "routing_total_ms=%.1f", totalMs))
        LiteRTDeviceEvalLog.append("routing-response=\(text.prefix(240))")
    }

    private static func runE4BControlPlaneSummarySmoke(engine: Engine) async throws {
        let config = ConversationConfig(
            systemMessage: Message(
                "Summarize into exactly three bullets. Preserve decisions and open questions. Do not add facts."
            )
        )
        let conversation = try await engine.createConversation(with: config)
        let prompt = Message(
            """
            Context: QWON prefers local-first processing. Cloud escalation is allowed only when local confidence is low. The next task is model evaluation.
            """
        )
        let generationStart = CFAbsoluteTimeGetCurrent()
        let response = try await conversation.sendMessage(prompt)
        let totalMs = (CFAbsoluteTimeGetCurrent() - generationStart) * 1000.0
        let text = response.toString
        LiteRTDeviceEvalLog.append(String(format: "summary_total_ms=%.1f", totalMs))
        LiteRTDeviceEvalLog.append("summary-response=\(text.prefix(240))")
    }

    private static func logStreamingGeneration(
        conversation: Conversation,
        prompt: Message,
        prefix: String
    ) async throws {
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
                format: "%@-first_token_ms=%.1f %@-total_ms=%.1f %@-decode_tps=%.1f",
                prefix,
                firstTokenMs ?? -1,
                prefix,
                totalMs,
                prefix,
                decodeTps
            )
        )
        LiteRTDeviceEvalLog.append("\(prefix)-response=\(response.prefix(240))")
    }
}
