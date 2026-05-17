import Foundation

protocol EscalationCoordinator {
    func shouldEscalate(_ decision: RouteDecision, policy: ExecutionPolicy) -> Bool
}

struct DefaultEscalationCoordinator: EscalationCoordinator {
    func shouldEscalate(_ decision: RouteDecision, policy: ExecutionPolicy) -> Bool {
        policy.allowsCloudEscalation && decision.tier == .tier3
    }
}
