import Foundation

enum ProviderAvailabilityStatus: Equatable {
    case cloudReady
    case localPrimary
    case disabled

    var label: String {
        switch self {
        case .cloudReady:
            return "Cloud Ready"
        case .localPrimary:
            return "Local Primary"
        case .disabled:
            return "Disabled"
        }
    }
}

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
            config = Self.normalizedConfig(decoded)
        } else {
            config = .default
        }

        openAIKey = apiKeyStore.apiKey(for: .openAI) ?? ""
        anthropicKey = apiKeyStore.apiKey(for: .anthropic) ?? ""
        geminiKey = apiKeyStore.apiKey(for: .gemini) ?? ""
    }

    private func persistConfig() {
        let normalized = Self.normalizedConfig(config)
        guard let data = try? JSONEncoder().encode(normalized) else { return }
        defaults.set(data, forKey: configKey)
    }

    private static func normalizedConfig(_ config: AppConfig) -> AppConfig {
        var normalized = config
        #if !targetEnvironment(simulator)
        if normalized.localModelBackend == .simulatorMock {
            normalized.localModelBackend = .automatic
        }
        #endif
        return normalized
    }

    func availabilityStatus(for provider: CloudProvider) -> ProviderAvailabilityStatus {
        if !config.allowsCloudEscalation {
            return .disabled
        }

        return apiKey(for: provider).isEmpty ? .localPrimary : .cloudReady
    }

    func apiKey(for provider: CloudProvider) -> String {
        switch provider {
        case .openAI:
            return openAIKey.trimmingCharacters(in: .whitespacesAndNewlines)
        case .anthropic:
            return anthropicKey.trimmingCharacters(in: .whitespacesAndNewlines)
        case .gemini:
            return geminiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    func isApprovedForRestrictedMode(_ provider: CloudProvider) -> Bool {
        config.approvedProvidersForRestrictedMode.contains(provider)
    }

    func setApprovedForRestrictedMode(_ approved: Bool, provider: CloudProvider) {
        var providers = config.approvedProvidersForRestrictedMode
        if approved {
            if !providers.contains(provider) {
                providers.append(provider)
            }
        } else {
            providers.removeAll { $0 == provider }
        }

        config.approvedProvidersForRestrictedMode = CloudProvider.allCases.filter(providers.contains)
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
