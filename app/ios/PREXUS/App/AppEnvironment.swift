import Foundation

enum AppLaunchScenario: Equatable {
    static let seededRuntimeSurfacesArgument = "PREXUS_UI_TEST_SEEDED_SURFACES"

    case standard
    case seededRuntimeSurfaces

    static func current(processInfo: ProcessInfo = .processInfo) -> AppLaunchScenario {
        processInfo.arguments.contains(seededRuntimeSurfacesArgument) ? .seededRuntimeSurfaces : .standard
    }
}

@MainActor
final class AppEnvironment: ObservableObject {
    let settings: AppSettingsStore
    let memoryLibrary: MemoryLibraryViewModel
    let runtimeDiagnostics: RuntimeDiagnosticsStore
    let launchScenario: AppLaunchScenario
    private let apiKeyStore: APIKeyStore
    private let memoryStore: EpisodicMemoryStore
    private let runtimeOverride: RuntimeContainer?

    var runtime: RuntimeContainer {
        runtimeOverride ?? RuntimeContainer.live(
            config: settings.config,
            apiKeyStore: apiKeyStore,
            memoryStore: memoryStore,
            localModel: AppLocalModelFactory.makeClient(preferred: settings.config.localModelBackend)
        )
    }

    static func bootstrap(processInfo: ProcessInfo = .processInfo) -> AppEnvironment {
        bootstrap(launchScenario: AppLaunchScenario.current(processInfo: processInfo))
    }

    static func bootstrap(launchScenario: AppLaunchScenario) -> AppEnvironment {
        let apiKeyStore = KeychainAPIKeyStore()
        let settings = AppSettingsStore(apiKeyStore: apiKeyStore)
        let memoryStore: EpisodicMemoryStore
        let diagnosticsStore: RuntimeDiagnosticsStore

        switch launchScenario {
        case .standard:
            memoryStore = PersistentMemoryStore()
            diagnosticsStore = RuntimeDiagnosticsStore()
        case .seededRuntimeSurfaces:
            memoryStore = seededMemoryStore()
            diagnosticsStore = seededDiagnosticsStore()
        }

        return AppEnvironment(
            settings: settings,
            apiKeyStore: apiKeyStore,
            memoryStore: memoryStore,
            runtimeDiagnosticsStore: diagnosticsStore,
            launchScenario: launchScenario
        )
    }

    init(
        settings: AppSettingsStore,
        apiKeyStore: APIKeyStore,
        memoryStore: EpisodicMemoryStore,
        runtimeDiagnosticsStore: RuntimeDiagnosticsStore,
        launchScenario: AppLaunchScenario = .standard,
        runtimeOverride: RuntimeContainer? = nil
    ) {
        self.settings = settings
        self.memoryLibrary = MemoryLibraryViewModel(memoryStore: memoryStore)
        self.runtimeDiagnostics = runtimeDiagnosticsStore
        self.launchScenario = launchScenario
        self.apiKeyStore = apiKeyStore
        self.memoryStore = memoryStore
        self.runtimeOverride = runtimeOverride
    }

    private static func seededMemoryStore() -> EpisodicMemoryStore {
        let store = InMemoryEpisodicMemoryStore()
        store.save(
            EpisodicMemory(
                id: UUID(),
                summary: "Captured a local-only conversation summary about a private architecture review.",
                sensitivity: .localPreferred,
                createdAt: Date().addingTimeInterval(-300)
            )
        )
        store.save(
            EpisodicMemory(
                id: UUID(),
                summary: "Stored a concise OCR snapshot of shipping label fields for later reference.",
                sensitivity: .escalationAllowed,
                createdAt: Date().addingTimeInterval(-120)
            )
        )
        return store
    }

    private static func seededDiagnosticsStore() -> RuntimeDiagnosticsStore {
        let suiteName = "PREXUS.UITests.Diagnostics.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        let store = RuntimeDiagnosticsStore(defaults: defaults)
        store.record(
            route: RouteDecision(
                tier: .tier2,
                target: .local,
                reasonCodes: ["generalChat", "local_default"]
            ),
            execution: RuntimeExecutionMetadata(
                mode: .local,
                provider: nil,
                model: "Embedded Runtime",
                detail: "Handled fully on device."
            ),
            userText: "Summarize the local project brief."
        )
        store.record(
            route: RouteDecision(
                tier: .tier3,
                target: .openAI,
                reasonCodes: ["codeAnalysis", "high_complexity"]
            ),
            execution: RuntimeExecutionMetadata(
                mode: .cloud,
                provider: .openAI,
                model: "gpt-4.1-mini",
                detail: "Escalated for higher-quality code reasoning."
            ),
            userText: "Review this runtime routing branch for edge cases."
        )
        return store
    }
}
