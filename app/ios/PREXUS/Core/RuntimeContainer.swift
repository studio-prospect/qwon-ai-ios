import Foundation

struct RuntimeContainer {
    let router: RoutingEngine
    let compressor: ContextCompressor
    let localModel: LocalModelClient
    let cloudModel: CloudModelClient
    let memoryStore: EpisodicMemoryStore

    static func live(config: AppConfig) -> RuntimeContainer {
        let policy = ExecutionPolicy(
            allowsCloudEscalation: config.allowsCloudEscalation,
            maxCloudContextTokens: config.maxCloudContextTokens
        )
        let classifier = HeuristicIntentClassifier()
        let compressor = HeuristicContextCompressor()
        let localModel = MockLocalModelClient()
        let cloudModel = MockCloudModelClient()
        let memoryStore = InMemoryEpisodicMemoryStore()
        let router = DefaultRoutingEngine(
            classifier: classifier,
            policy: policy
        )

        return RuntimeContainer(
            router: router,
            compressor: compressor,
            localModel: localModel,
            cloudModel: cloudModel,
            memoryStore: memoryStore
        )
    }
}
