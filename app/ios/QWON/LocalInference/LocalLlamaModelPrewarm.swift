import Foundation

/// Loads the on-device GGUF in the background so the first chat turn avoids a cold-start failure.
enum LocalLlamaModelPrewarm {
    static func startIfNeeded() {
        #if targetEnvironment(simulator)
        return
        #else
        guard LocalInferenceDeviceGate.supportsOnDeviceLlamaCppForCurrentPlatform else { return }
        guard let modelURL = LocalGGUFModelPlacement().resolvedModelURL else { return }

        Task.detached(priority: .utility) {
            LocalDeviceEvalLog.append("prewarm-start model=\(modelURL.lastPathComponent)")
            let engine = LlamaCppInferenceEngine()
            do {
                let loadStart = CFAbsoluteTimeGetCurrent()
                try engine.prepare(modelPath: modelURL.path)
                let loadMs = (CFAbsoluteTimeGetCurrent() - loadStart) * 1000.0
                LocalDeviceEvalLog.append(String(format: "prewarm-ready load_ms=%.1f", loadMs))
                LocalLlamaDeviceEvalRunner.runLargeModelSmokeTestIfNeeded(
                    modelURL: modelURL,
                    engine: engine
                )
            } catch {
                LocalDeviceEvalLog.append("prewarm-failed error=\(error.localizedDescription)")
            }
        }
        #endif
    }
}
