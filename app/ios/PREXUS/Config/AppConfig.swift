import Foundation

struct AppConfig {
    let allowsCloudEscalation: Bool
    let maxCloudContextTokens: Int

    static let `default` = AppConfig(
        allowsCloudEscalation: true,
        maxCloudContextTokens: 2_048
    )
}
