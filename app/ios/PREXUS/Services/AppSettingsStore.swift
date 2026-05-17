import Foundation

@MainActor
final class AppSettingsStore: ObservableObject {
    @Published var config: AppConfig {
        didSet { persistConfig() }
    }

    @Published var openAIKey: String {
        didSet { persistAPIKey(openAIKey, provider: .openAI) }
    }

    @Published var anthropicKey: String {
        didSet { persistAPIKey(anthropicKey, provider: .anthropic) }
    }

    @Published var geminiKey: String {
        didSet { persistAPIKey(geminiKey, provider: .gemini) }
    }

    private let defaults: UserDefaults
    private let apiKeyStore: APIKeyStore
    private let configKey = "prexus.app-config"

    init(defaults: UserDefaults = .standard, apiKeyStore: APIKeyStore) {
        self.defaults = defaults
        self.apiKeyStore = apiKeyStore

        if let data = defaults.data(forKey: configKey),
           let decoded = try? JSONDecoder().decode(AppConfig.self, from: data) {
            config = decoded
        } else {
            config = .default
        }

        openAIKey = apiKeyStore.apiKey(for: .openAI) ?? ""
        anthropicKey = apiKeyStore.apiKey(for: .anthropic) ?? ""
        geminiKey = apiKeyStore.apiKey(for: .gemini) ?? ""
    }

    private func persistConfig() {
        guard let data = try? JSONEncoder().encode(config) else { return }
        defaults.set(data, forKey: configKey)
    }

    private func persistAPIKey(_ value: String, provider: CloudProvider) {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            apiKeyStore.removeAPIKey(for: provider)
        } else {
            apiKeyStore.setAPIKey(trimmed, for: provider)
        }
    }
}
