import Foundation

struct RuntimeContainer {
    let config: AppConfig
    let router: RoutingEngine
    let compressor: ContextCompressor
    let localModel: LocalModelClient
    let cloudModel: CloudModelClient
    let memoryStore: EpisodicMemoryStore
    let apiKeyStore: APIKeyStore

    static func live(
        config: AppConfig,
        apiKeyStore: APIKeyStore,
        memoryStore: EpisodicMemoryStore,
        localModel: LocalModelClient? = nil,
        cloudModel: CloudModelClient? = nil
    ) -> RuntimeContainer {
        let policy = ExecutionPolicy(
            allowsCloudEscalation: config.allowsCloudEscalation,
            maxCloudContextTokens: config.maxCloudContextTokens,
            approvedProvidersForRestrictedMode: Set(config.approvedProvidersForRestrictedMode)
        )
        let classifier = HeuristicIntentClassifier()
        let compressor = HeuristicContextCompressor()
        let localModel = localModel ?? LocalModelFactory.makeClient(preferred: config.localModelBackend)
        let cloudModel = cloudModel ?? DefaultCloudModelClient(
            openAIClient: OpenAIResponsesClient(
                transport: URLSessionHTTPTransport(),
                model: config.openAIModel
            )
        )
        let router = DefaultRoutingEngine(
            classifier: classifier,
            policy: policy
        )

        return RuntimeContainer(
            config: config,
            router: router,
            compressor: compressor,
            localModel: localModel,
            cloudModel: cloudModel,
            memoryStore: memoryStore,
            apiKeyStore: apiKeyStore
        )
    }
}
