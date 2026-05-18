import Foundation

enum RuntimeModality: String {
    case text
    case audio
    case image
    case sensor
}

enum SensitivityLevel: String, Codable, CaseIterable {
    case localOnly
    case localPreferred
    case escalationAllowed
    case providerRestricted

    var displayLabel: String {
        switch self {
        case .localOnly:
            return "Local Only"
        case .localPreferred:
            return "Local Preferred"
        case .escalationAllowed:
            return "Escalation Allowed"
        case .providerRestricted:
            return "Provider Restricted"
        }
    }
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

    var targetLabel: String {
        switch target {
        case .local:
            return "Local"
        case .openAI:
            return "OpenAI"
        case .anthropic:
            return "Anthropic"
        case .gemini:
            return "Gemini"
        }
    }

    var tierLabel: String {
        switch tier {
        case .tier1:
            return "Tier 1"
        case .tier2:
            return "Tier 2"
        case .tier3:
            return "Tier 3"
        }
    }

    var statusSummary: String {
        "\(targetLabel) | \(tierLabel)"
    }

    var displayReasonSummary: String {
        reasonCodes
            .map(Self.displayLabel(forReasonCode:))
            .joined(separator: " | ")
    }

    var reasonSummary: String {
        reasonCodes.joined(separator: ", ")
    }

    func reroutedToLocal(appending reasonCode: String) -> RouteDecision {
        RouteDecision(
            tier: .tier2,
            target: .local,
            reasonCodes: reasonCodes + [reasonCode]
        )
    }

    static func displayLabel(forReasonCode code: String) -> String {
        switch code {
        case "local_only":
            return "Local-only policy"
        case "local_default":
            return "Local default"
        case "provider_restricted":
            return "Provider restricted"
        case "provider_not_approved":
            return "Provider not approved"
        case "cloud_disabled":
            return "Cloud disabled"
        case "high_complexity":
            return "High complexity"
        case "quality_preferred":
            return "Quality preferred"
        case "multimodal_candidate":
            return "Multimodal candidate"
        case "openai_key_unavailable":
            return "OpenAI key unavailable"
        case "anthropic_key_unavailable":
            return "Anthropic key unavailable"
        case "gemini_key_unavailable":
            return "Gemini key unavailable"
        case "generalChat":
            return "General chat"
        case "summarization":
            return "Summarization"
        case "ocrExtraction":
            return "OCR extraction"
        case "codeAnalysis":
            return "Code analysis"
        case "creativeWriting":
            return "Creative writing"
        case "visionReasoning":
            return "Vision reasoning"
        default:
            return code.replacingOccurrences(of: "_", with: " ").capitalized
        }
    }
}
