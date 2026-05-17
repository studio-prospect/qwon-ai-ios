import Foundation

protocol RoutingEngine {
    func route(request: RuntimeRequest) -> RouteDecision
}

struct DefaultRoutingEngine: RoutingEngine {
    let classifier: IntentClassifier
    let policy: ExecutionPolicy

    func route(request: RuntimeRequest) -> RouteDecision {
        let intent = classifier.classify(request: request)

        if request.sensitivity == .localOnly {
            return RouteDecision(
                tier: .tier2,
                target: .local,
                reasonCodes: [intent.rawValue, "local_only"]
            )
        }

        if request.sensitivity == .providerRestricted {
            return RouteDecision(
                tier: .tier2,
                target: .local,
                reasonCodes: [intent.rawValue, "provider_restricted"]
            )
        }

        if !policy.allowsCloudEscalation {
            return RouteDecision(
                tier: .tier2,
                target: .local,
                reasonCodes: [intent.rawValue, "cloud_disabled"]
            )
        }

        switch intent {
        case .codeAnalysis:
            return RouteDecision(tier: .tier3, target: .openAI, reasonCodes: [intent.rawValue, "high_complexity"])
        case .creativeWriting:
            return RouteDecision(tier: .tier3, target: .anthropic, reasonCodes: [intent.rawValue, "quality_preferred"])
        case .visionReasoning:
            return RouteDecision(tier: .tier3, target: .gemini, reasonCodes: [intent.rawValue, "multimodal_candidate"])
        case .generalChat, .summarization, .ocrExtraction:
            return RouteDecision(tier: .tier2, target: .local, reasonCodes: [intent.rawValue, "local_default"])
        }
    }
}
