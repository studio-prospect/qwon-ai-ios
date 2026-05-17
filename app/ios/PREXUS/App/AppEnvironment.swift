import Foundation

@MainActor
final class AppEnvironment: ObservableObject {
    let settings: AppSettingsStore
    let memoryLibrary: MemoryLibraryViewModel
    let runtimeDiagnostics: RuntimeDiagnosticsStore
    private let apiKeyStore: APIKeyStore
    private let memoryStore: EpisodicMemoryStore

    var runtime: RuntimeContainer {
        RuntimeContainer.live(
            config: settings.config,
            apiKeyStore: apiKeyStore,
            memoryStore: memoryStore
        )
    }

    static func bootstrap() -> AppEnvironment {
        let apiKeyStore = KeychainAPIKeyStore()
        let settings = AppSettingsStore(apiKeyStore: apiKeyStore)
        let memoryStore = PersistentMemoryStore()
        return AppEnvironment(
            settings: settings,
            apiKeyStore: apiKeyStore,
            memoryStore: memoryStore
        )
    }

    init(settings: AppSettingsStore, apiKeyStore: APIKeyStore, memoryStore: EpisodicMemoryStore) {
        self.settings = settings
        self.memoryLibrary = MemoryLibraryViewModel(memoryStore: memoryStore)
        self.runtimeDiagnostics = RuntimeDiagnosticsStore()
        self.apiKeyStore = apiKeyStore
        self.memoryStore = memoryStore
    }
}
