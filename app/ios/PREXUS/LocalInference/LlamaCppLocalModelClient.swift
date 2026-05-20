import Foundation

final class LlamaCppLocalModelClient: LocalModelClient {
    private let placement: LocalGGUFModelPlacement
    private let engine: LlamaCppInferenceEngine
    private let coordinator = LocalModelGenerationCoordinator()
    private let maxGeneratedTokens: Int
    private var cancellationHandle = LlamaCppCancellationHandle()

    var descriptor: LocalModelDescriptor {
        LocalModelDescriptor(
            backend: .deviceRuntime,
            name: "llama.cpp On-Device Runtime",
            summary: placement.isModelAvailable
                ? "llama.cpp GGUF inference on A17 Pro-class hardware."
                : "llama.cpp runtime waiting for a GGUF model asset."
        )
    }

    init(
        placement: LocalGGUFModelPlacement = LocalGGUFModelPlacement(),
        engine: LlamaCppInferenceEngine = LlamaCppInferenceEngine(),
        maxGeneratedTokens: Int = 192
    ) {
        self.placement = placement
        self.engine = engine
        self.maxGeneratedTokens = maxGeneratedTokens
    }

    func generate(prompt: String) async throws -> String {
        guard LocalInferenceDeviceGate.supportsOnDeviceLlamaCppForCurrentPlatform else {
            throw LocalModelError.deviceNotSupported
        }

        guard let modelURL = placement.resolvedModelURL else {
            throw LocalModelError.modelAssetUnavailable
        }

        return try await withTaskCancellationHandler {
            try await coordinator.generate(prompt: prompt) { [self] activePrompt in
                let handle = LlamaCppCancellationHandle()
                self.cancellationHandle.cancel()
                self.cancellationHandle = handle

                try Task.checkCancellation()
                try self.engine.prepare(modelPath: modelURL.path)

                return try await Task.detached(priority: .userInitiated) {
                    try Task.checkCancellation()
                    return try self.engine.generate(
                        prompt: activePrompt,
                        maxTokens: self.maxGeneratedTokens,
                        cancellation: handle
                    )
                }.value
            }
        } onCancel: {
            self.cancellationHandle.cancel()
        }
    }
}
