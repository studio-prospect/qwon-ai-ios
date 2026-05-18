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

    var compactDisplayLabel: String {
        switch self {
        case .localOnly:
            return "Local"
        case .localPreferred:
            return "Prefer"
        case .escalationAllowed:
            return "Escalate"
        case .providerRestricted:
            return "Restricted"
        }
    }

    var helperDescription: String {
        switch self {
        case .localOnly:
            return "Run only on device."
        case .localPreferred:
            return "Prefer on-device handling, with fallback if needed."
        case .escalationAllowed:
            return "Allow cloud escalation when it helps."
        case .providerRestricted:
            return "Allow cloud use only through approved providers."
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

    static func primaryReasonCode(from codes: [String]) -> String? {
        let uniqueCodes = deduplicatedReasonCodes(from: codes)
        guard !uniqueCodes.isEmpty else { return nil }

        let rankedCodes = Dictionary(
            uniqueKeysWithValues: uniqueCodes.enumerated().map { index, code in
                (code, (rank: reasonPriority(for: code), index: index))
            }
        )

        return uniqueCodes.min { lhs, rhs in
            guard let lhsMetadata = rankedCodes[lhs], let rhsMetadata = rankedCodes[rhs] else {
                return false
            }

            if lhsMetadata.rank == rhsMetadata.rank {
                return lhsMetadata.index < rhsMetadata.index
            }

            return lhsMetadata.rank < rhsMetadata.rank
        }
    }

    private static func deduplicatedReasonCodes(from codes: [String]) -> [String] {
        var seen = Set<String>()
        var orderedCodes: [String] = []

        for code in codes where seen.insert(code).inserted {
            orderedCodes.append(code)
        }

        return orderedCodes
    }

    private static func reasonPriority(for code: String) -> Int {
        switch code {
        case "provider_not_approved":
            return 0
        case "cloud_disabled":
            return 1
        case "openai_key_unavailable", "anthropic_key_unavailable", "gemini_key_unavailable":
            return 2
        case "local_only":
            return 3
        case "provider_restricted":
            return 4
        case "high_complexity", "quality_preferred", "multimodal_candidate":
            return 5
        case "local_default":
            return 6
        case "generalChat", "summarization", "ocrExtraction", "codeAnalysis", "creativeWriting", "visionReasoning":
            return 100
        default:
            return 50
        }
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
