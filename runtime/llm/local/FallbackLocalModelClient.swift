import Foundation

struct FallbackLocalModelClient: LocalModelClient {
    let primary: LocalModelClient
    let fallback: LocalModelClient

    var descriptor: LocalModelDescriptor {
        LocalModelDescriptor(
            backend: primary.descriptor.backend,
            name: primary.descriptor.name,
            summary: "\(primary.descriptor.summary) Falls back to \(fallback.descriptor.name) when unavailable."
        )
    }

    func generate(prompt: String) async throws -> String {
        do {
            let response = try await primary.generate(prompt: prompt)
            let priorMetrics = LocalModelExecutionTrace.current?.metricsDetail
            LocalModelExecutionTrace.record(
                respondingBackend: primary.descriptor.name,
                primaryFailure: nil,
                metricsDetail: priorMetrics
            )
            return response
        } catch is CancellationError {
            throw CancellationError()
        } catch LocalModelError.generationCancelled {
            throw LocalModelError.generationCancelled
        } catch {
            let failure = (error as? LocalModelError)?.diagnosticDescription ?? String(describing: error)
            let response = try await fallback.generate(prompt: prompt)
            let fallbackTrace = LocalModelExecutionTrace.current
            let respondingBackend = fallbackTrace?.respondingBackend ?? fallback.descriptor.name
            let embeddedName = EmbeddedHeuristicLocalModelClient().descriptor.name
            let fallbackReason = respondingBackend == embeddedName ? "embedded_heuristic" : nil
            LocalModelExecutionTrace.record(
                respondingBackend: respondingBackend,
                primaryFailure: failure,
                fallbackReason: fallbackReason,
                metricsDetail: fallbackTrace?.metricsDetail
            )
            return response
        }
    }
}
