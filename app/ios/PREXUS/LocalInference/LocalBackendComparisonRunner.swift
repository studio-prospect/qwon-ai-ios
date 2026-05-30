#if PREXUS_LITERT_LM_PROTOTYPE
import Foundation

/// Runs matched prompts across Qwen llama.cpp and LiteRT-LM for P1-4b device comparison.
enum LocalBackendComparisonRunner {
    static let launchEnvironmentKey = "PREXUS_RUN_BACKEND_COMPARISON"
    private static let logFileName = "prexus-backend-comparison.log"

    struct Prompt: Equatable {
        let label: String
        let text: String
    }

    static let comparisonPrompts: [Prompt] = [
        Prompt(
            label: "ja_short",
            text: """
            User:
            あなたはPREXUSのローカル補助モデルです。短く自然な日本語で答えてください。
            質問: 明日の予定を整理する時、最初に何を確認すべきですか？
            """
        ),
        Prompt(
            label: "routing_json",
            text: """
            Reply with compact JSON only. Keys: intent, confidence, needs_cloud.
            Classify intent as JSON: chat|summarize|memory_write|tool_request|cloud_needed.
            User: このメールを要約して
            """
        ),
        Prompt(
            label: "control_plane_medium",
            text: """
            User:
            次の会話をルーティング用に3行以内で要約し、ローカル処理で足りるか判断してください。
            User: 会議の議事録を短くまとめて、TODOだけ抽出して。
            Assistant: 了解しました。TODOは資料共有とレビュー依頼です。
            User: 明日までに共有できる形に整えて。
            """
        )
    ]

    static func runIfRequested() async {
        guard ProcessInfo.processInfo.environment[launchEnvironmentKey] == "1" else { return }
        await run()
    }

    static func run() async {
        var lines: [String] = ["backend,prompt,status,cold_load_ms,first_token_ms,total_ms,response_prefix"]

        let qwenChain = AppLocalModelFactory.makeQwenFallbackChain()

        for prompt in comparisonPrompts {
            lines.append(await runPrompt(prompt: prompt, backend: "qwen_llama_cpp", client: qwenChain))
        }

        if LiteRTPrototypeSettings.meetsHardwareAndArtifactGates {
            let litert = LiteRTLocalModelClient()
            for prompt in comparisonPrompts {
                lines.append(await runPrompt(prompt: prompt, backend: "litert_lm_gemma4", client: litert))
            }
        } else {
            lines.append("litert_lm_gemma4,all,skipped_device_or_artifact,,,,")
        }

        writeLog(lines.joined(separator: "\n"))
    }

    private static func runPrompt(prompt: Prompt, backend: String, client: LocalModelClient) async -> String {
        LocalModelExecutionTrace.reset()
        let start = CFAbsoluteTimeGetCurrent()
        do {
            let response = try await client.generate(prompt: prompt.text)
            let totalMs = (CFAbsoluteTimeGetCurrent() - start) * 1000.0
            let metrics = LocalModelExecutionTrace.current?.metricsDetail ?? ""
            let cold = extractMetric(metrics, key: "cold_load_ms") ?? ""
            let first = extractMetric(metrics, key: "first_token_ms") ?? ""
            let prefix = response.prefix(120).replacingOccurrences(of: ",", with: ";")
            return "\(backend),\(prompt.label),ok,\(cold),\(first),\(String(format: "%.1f", totalMs)),\(prefix)"
        } catch {
            let totalMs = (CFAbsoluteTimeGetCurrent() - start) * 1000.0
            let failure = String(describing: error).replacingOccurrences(of: ",", with: ";")
            return "\(backend),\(prompt.label),failed,,,\(String(format: "%.1f", totalMs)),\(failure)"
        }
    }

    private static func extractMetric(_ detail: String, key: String) -> String? {
        guard let range = detail.range(of: "\(key)=") else { return nil }
        let tail = detail[range.upperBound...]
        return tail.split(separator: " ").first.map(String.init)
    }

    private static func writeLog(_ body: String) {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return
        }

        let logURL = documentsDirectory.appendingPathComponent(logFileName)
        try? body.write(to: logURL, atomically: true, encoding: .utf8)
        print("[PREXUS][backend-comparison]\n\(body)")
    }
}
#endif
