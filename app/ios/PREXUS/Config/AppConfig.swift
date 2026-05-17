import Foundation

struct AppConfig: Codable, Equatable {
    var allowsCloudEscalation: Bool
    var maxCloudContextTokens: Int

    static let `default` = AppConfig(
        allowsCloudEscalation: true,
        maxCloudContextTokens: 2_048
    )
}
