import Foundation

struct AppConfig: Codable, Equatable {
    var allowsCloudEscalation: Bool
    var maxCloudContextTokens: Int
    var openAIModel: String
    var localModelBackend: LocalModelBackend
    var approvedProvidersForRestrictedMode: [CloudProvider]

    enum CodingKeys: String, CodingKey {
        case allowsCloudEscalation
        case maxCloudContextTokens
        case openAIModel
        case localModelBackend
        case approvedProvidersForRestrictedMode
    }

    init(
        allowsCloudEscalation: Bool,
        maxCloudContextTokens: Int,
        openAIModel: String,
        localModelBackend: LocalModelBackend,
        approvedProvidersForRestrictedMode: [CloudProvider] = []
    ) {
        self.allowsCloudEscalation = allowsCloudEscalation
        self.maxCloudContextTokens = maxCloudContextTokens
        self.openAIModel = openAIModel
        self.localModelBackend = localModelBackend
        self.approvedProvidersForRestrictedMode = approvedProvidersForRestrictedMode
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        allowsCloudEscalation = try container.decode(Bool.self, forKey: .allowsCloudEscalation)
        maxCloudContextTokens = try container.decode(Int.self, forKey: .maxCloudContextTokens)
        openAIModel = try container.decodeIfPresent(String.self, forKey: .openAIModel) ?? AppConfig.default.openAIModel
        localModelBackend = try container.decodeIfPresent(LocalModelBackend.self, forKey: .localModelBackend) ?? AppConfig.default.localModelBackend
        approvedProvidersForRestrictedMode = try container.decodeIfPresent([CloudProvider].self, forKey: .approvedProvidersForRestrictedMode) ?? []
    }

    static let `default` = AppConfig(
        allowsCloudEscalation: true,
        maxCloudContextTokens: 2_048,
        openAIModel: "gpt-5-mini",
        localModelBackend: .automatic,
        approvedProvidersForRestrictedMode: []
    )
}
