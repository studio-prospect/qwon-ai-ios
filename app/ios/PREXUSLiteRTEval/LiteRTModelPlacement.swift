import Foundation

/// Resolves the evaluation-only `.litertlm` artifact (never the Qwen GGUF MVP).
enum LiteRTModelPlacement {
    static let evaluationModelFileName = "prexus-eval-gemma4-e2b.litertlm"

    static var resolvedModelPath: String? {
        if let override = ProcessInfo.processInfo.environment["PREXUS_LITERT_MODEL_PATH"],
           !override.isEmpty,
           FileManager.default.fileExists(atPath: override) {
            return override
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
            .path

        return FileManager.default.fileExists(atPath: candidate) ? candidate : nil
    }
}
