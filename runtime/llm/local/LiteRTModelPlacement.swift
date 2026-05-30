import Foundation

/// Evaluation-only LiteRT-LM artifact placement (separate from Qwen GGUF MVP).
enum LiteRTModelPlacement {
    static let evaluationModelFileName = "prexus-eval-gemma4-e2b.litertlm"

    static var resolvedModelURL: URL? {
        if let override = ProcessInfo.processInfo.environment["PREXUS_LITERT_MODEL_PATH"],
           !override.isEmpty {
            let url = URL(fileURLWithPath: override)
            return FileManager.default.fileExists(atPath: url.path) ? url : nil
        }

        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return nil
        }

        let candidate = documentsDirectory
            .appendingPathComponent("Models", isDirectory: true)
            .appendingPathComponent(evaluationModelFileName)

        return FileManager.default.fileExists(atPath: candidate.path) ? candidate : nil
    }

    static var isModelAvailable: Bool {
        resolvedModelURL != nil
    }
}
