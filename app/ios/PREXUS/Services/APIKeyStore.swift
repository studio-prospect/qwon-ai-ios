import Foundation
import Security

protocol APIKeyStore {
    func apiKey(for provider: CloudProvider) -> String?
    func setAPIKey(_ apiKey: String, for provider: CloudProvider)
    func removeAPIKey(for provider: CloudProvider)
}

struct KeychainAPIKeyStore: APIKeyStore {
    private let service = "com.prexus.api-keys"

    func apiKey(for provider: CloudProvider) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: provider.rawValue,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func setAPIKey(_ apiKey: String, for provider: CloudProvider) {
        let data = Data(apiKey.utf8)
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: provider.rawValue
        ]
        let attributes: [CFString: Any] = [
            kSecValueData: data
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        if status == errSecItemNotFound {
            let createQuery: [CFString: Any] = query.merging(attributes) { _, new in new }
            SecItemAdd(createQuery as CFDictionary, nil)
        }
    }

    func removeAPIKey(for provider: CloudProvider) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: provider.rawValue
        ]
        SecItemDelete(query as CFDictionary)
    }
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
