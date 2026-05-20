import Foundation

enum AppLocalModelFactory {
    static func makeClient(preferred backend: LocalModelBackend) -> LocalModelClient {
        switch LocalModelFactory.resolvedBackend(for: backend) {
        case .simulatorMock:
            return SimulatorMockLocalModelClient()
        case .embeddedHeuristic:
            return EmbeddedHeuristicLocalModelClient()
        case .deviceRuntime:
            return makeDeviceRuntimeClient()
        case .automatic:
            return makeAutomaticClient()
        }
    }

    private static func makeAutomaticClient() -> LocalModelClient {
        #if targetEnvironment(simulator)
        return SimulatorMockLocalModelClient()
        #else
        return makeDeviceRuntimeClient()
        #endif
    }

    private static func makeDeviceRuntimeClient() -> LocalModelClient {
        #if targetEnvironment(simulator)
        return SimulatorMockLocalModelClient()
        #else
        guard LocalInferenceDeviceGate.supportsOnDeviceLlamaCppForCurrentPlatform else {
            return EmbeddedHeuristicLocalModelClient()
        }

        return FallbackLocalModelClient(
            primary: LlamaCppLocalModelClient(),
            fallback: EmbeddedHeuristicLocalModelClient()
        )
        #endif
    }
}
