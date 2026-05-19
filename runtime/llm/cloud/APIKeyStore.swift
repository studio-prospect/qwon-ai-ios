import Foundation

protocol APIKeyStore {
    func apiKey(for provider: CloudProvider) -> String?
    func setAPIKey(_ apiKey: String, for provider: CloudProvider)
    func removeAPIKey(for provider: CloudProvider)
}

final class InMemoryAPIKeyStore: APIKeyStore {
    private var storage: [CloudProvider: String] = [:]

    func apiKey(for provider: CloudProvider) -> String? {
        storage[provider]
    }

    func setAPIKey(_ apiKey: String, for provider: CloudProvider) {
        storage[provider] = apiKey
    }

    func removeAPIKey(for provider: CloudProvider) {
        storage.removeValue(forKey: provider)
    }
}
