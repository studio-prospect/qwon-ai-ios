import Foundation

struct AppEnvironment {
    let config: AppConfig
    let runtime: RuntimeContainer

    static func bootstrap() -> AppEnvironment {
        let config = AppConfig.default
        let runtime = RuntimeContainer.live(config: config)
        return AppEnvironment(config: config, runtime: runtime)
    }
}
