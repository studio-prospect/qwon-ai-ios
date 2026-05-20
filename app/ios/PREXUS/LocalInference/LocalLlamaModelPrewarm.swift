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
            let engine = LlamaCppInferenceEngine()
            try? engine.prepare(modelPath: modelURL.path)
        }
        #endif
    }
}
