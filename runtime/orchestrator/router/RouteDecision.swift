import Foundation

enum RuntimeModality: String {
    case text
    case audio
    case image
    case sensor
}

enum SensitivityLevel: String {
    case localOnly
    case localPreferred
    case escalationAllowed
    case providerRestricted
}

struct RuntimeRequest {
    let text: String
    let modality: RuntimeModality
    let sensitivity: SensitivityLevel
}

enum RouteTier: String {
    case tier1
    case tier2
    case tier3
}

enum RouteTarget: String {
    case local
    case openAI
    case anthropic
    case gemini
}

struct RouteDecision {
    let tier: RouteTier
    let target: RouteTarget
    let reasonCodes: [String]

    var reasonSummary: String {
        reasonCodes.joined(separator: ", ")
    }
}
