import Foundation

final class LlamaCppCancellationHandle: @unchecked Sendable {
    private let token = QWONLlamaCancellationToken()

    func cancel() {
        token.cancel()
    }

    var bridgeToken: QWONLlamaCancellationToken {
        token
    }
}

final class LlamaCppInferenceEngine: @unchecked Sendable {
    private let lock = NSLock()
    private var bridge: QWONLlamaBridge?
    private var loadedModelPath: String?

    var isReady: Bool {
        lock.lock()
        defer { lock.unlock() }
        return bridge?.isReady ?? false
    }

    func prepare(modelPath: String) throws {
        lock.lock()
        defer { lock.unlock() }

        if loadedModelPath == modelPath, bridge?.isReady == true {
            return
        }

        bridge?.unload()
        bridge = nil
        loadedModelPath = nil

        do {
            let loadedBridge = try QWONLlamaBridge(modelPath: modelPath)
            bridge = loadedBridge
            loadedModelPath = modelPath
        } catch {
            throw LocalModelError.generationFailed(error.localizedDescription)
        }
    }

    func generate(prompt: String, maxTokens: Int, cancellation: LlamaCppCancellationHandle) throws -> String {
        lock.lock()
        let activeBridge = bridge
        lock.unlock()

        guard let activeBridge, activeBridge.isReady else {
            throw LocalModelError.backendUnavailable("llama.cpp bridge is not ready.")
        }

        do {
            let output = try activeBridge.generate(
                fromPrompt: prompt,
                maxTokens: maxTokens,
                cancellation: cancellation.bridgeToken
            )

            guard !output.isEmpty else {
                throw LocalModelError.generationFailed("llama.cpp returned an empty completion.")
            }

            if let metrics = activeBridge.lastGenerationMetrics {
#if DEBUG
                let shouldLogBenchmark = true
#else
                let shouldLogBenchmark = ProcessInfo.processInfo.environment["PREXUS_LOCAL_INFERENCE_BENCHMARK"] != nil
#endif
                if shouldLogBenchmark {
                let line = """
                    [PREXUS][local-inference-benchmark] \
                    cold_load_ms=\(metrics.coldLoadMs) \
                    first_token_ms=\(metrics.firstTokenLatencyMs) \
                    total_gen_ms=\(metrics.totalGenerationMs) \
                    tokens=\(metrics.generatedTokenCount) \
                    decode_tps=\(String(format: "%.2f", metrics.decodeTokensPerSecond))
                    """
                print(line)
#if DEBUG && !targetEnvironment(simulator)
                LocalDeviceEvalLog.append(line)
#endif
                }
            }

            return output
        } catch let error as NSError {
            if error.domain == QWONLlamaBridgeErrorDomain,
               error.code == QWONLlamaBridgeError.cancelled.rawValue {
                throw LocalModelError.generationCancelled
            }
            throw LocalModelError.generationFailed(error.localizedDescription)
        }
    }

    func unload() {
        lock.lock()
        bridge?.unload()
        bridge = nil
        loadedModelPath = nil
        lock.unlock()
    }
}
