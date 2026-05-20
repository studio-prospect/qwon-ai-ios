import Foundation

enum AppLocalModelFactory {
    /// Maps persisted settings to the backend actually used on this platform.
    static func effectiveBackend(for preferred: LocalModelBackend) -> LocalModelBackend {
        #if targetEnvironment(simulator)
        return preferred
        #else
        if preferred == .simulatorMock {
            return .automatic
        }
        return preferred
        #endif
    }

    static func makeClient(preferred backend: LocalModelBackend) -> LocalModelClient {
        switch LocalModelFactory.resolvedBackend(for: effectiveBackend(for: backend)) {
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
