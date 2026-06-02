import Foundation

#if DEBUG && !targetEnvironment(simulator)
/// Runs one local inference smoke prompt on device for large-model evaluation sessions.
enum LocalLlamaDeviceEvalRunner {
    private static let completedKey = "prexus.localDeviceEval.completed.v3"
    private static let largeModelThresholdBytes: Int64 = 1_000_000_000

    static func runLargeModelSmokeTestIfNeeded(modelURL: URL, engine: LlamaCppInferenceEngine) {
        guard UserDefaults.standard.bool(forKey: completedKey) == false else { return }

        let fileSize = (try? modelURL.resourceValues(forKeys: [.fileSizeKey]).fileSize).map(Int64.init) ?? 0
        guard fileSize >= largeModelThresholdBytes else { return }
        guard engine.isReady else { return }

        Task.detached(priority: .utility) {
            do {
                let handle = LlamaCppCancellationHandle()
                let prompt = """
                User:
                あなたはQWONのローカル補助モデルです。短く自然な日本語で答えてください。
                質問: 明日の予定を整理する時、最初に何を確認すべきですか？
                """
                let generationStart = CFAbsoluteTimeGetCurrent()
                let response = try engine.generate(prompt: prompt, maxTokens: 48, cancellation: handle)
                let generationMs = (CFAbsoluteTimeGetCurrent() - generationStart) * 1000.0
                LocalDeviceEvalLog.append(
                    "smoke-ok generation_ms=\(String(format: "%.1f", generationMs)) response=\(response.prefix(240))"
                )
            } catch {
                LocalDeviceEvalLog.append("smoke-failed error=\(error.localizedDescription)")
            }

            UserDefaults.standard.set(true, forKey: completedKey)
        }
    }
}
#else
enum LocalLlamaDeviceEvalRunner {
    static func runLargeModelSmokeTestIfNeeded(modelURL: URL, engine: LlamaCppInferenceEngine) {}
}
#endif
