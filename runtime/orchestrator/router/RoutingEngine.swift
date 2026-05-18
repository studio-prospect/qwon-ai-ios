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
            return restrictedRoute(for: intent)
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

    private func restrictedRoute(for intent: RuntimeIntent) -> RouteDecision {
        guard policy.allowsCloudEscalation else {
            return RouteDecision(
                tier: .tier2,
                target: .local,
                reasonCodes: [intent.rawValue, "provider_restricted", "cloud_disabled"]
            )
        }

        guard let preferredProvider = preferredCloudProvider(for: intent) else {
            return RouteDecision(
                tier: .tier2,
                target: .local,
                reasonCodes: [intent.rawValue, "provider_restricted", "local_default"]
            )
        }

        guard policy.approvedProvidersForRestrictedMode.contains(preferredProvider) else {
            return RouteDecision(
                tier: .tier2,
                target: .local,
                reasonCodes: [intent.rawValue, "provider_restricted", "provider_not_approved"]
            )
        }

        return RouteDecision(
            tier: .tier3,
            target: routeTarget(for: preferredProvider),
            reasonCodes: [intent.rawValue, "provider_restricted"]
        )
    }

    private func preferredCloudProvider(for intent: RuntimeIntent) -> CloudProvider? {
        switch intent {
        case .codeAnalysis:
            return .openAI
        case .creativeWriting:
            return .anthropic
        case .visionReasoning:
            return .gemini
        case .generalChat, .summarization, .ocrExtraction:
            return nil
        }
    }

    private func routeTarget(for provider: CloudProvider) -> RouteTarget {
        switch provider {
        case .openAI:
            return .openAI
        case .anthropic:
            return .anthropic
        case .gemini:
            return .gemini
        }
    }
}
