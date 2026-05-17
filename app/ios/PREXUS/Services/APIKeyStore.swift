import Foundation

protocol APIKeyStore {
    func apiKey(for provider: CloudProvider) -> String?
}

struct KeychainAPIKeyStore: APIKeyStore {
    func apiKey(for provider: CloudProvider) -> String? {
        nil
    }
}
