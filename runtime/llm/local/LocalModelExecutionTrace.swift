import Foundation

/// Captures which local backend answered and optional benchmark detail for diagnostics.
enum LocalModelExecutionTrace {
    struct Snapshot: Equatable {
        let respondingBackend: String
        let primaryFailure: String?
        let fallbackReason: String?
        let metricsDetail: String?
    }

    private static var lastSnapshot: Snapshot?

    static var current: Snapshot? {
        lastSnapshot
    }

    static func record(
        respondingBackend: String,
        primaryFailure: String? = nil,
        fallbackReason: String? = nil,
        metricsDetail: String? = nil
    ) {
        lastSnapshot = Snapshot(
            respondingBackend: respondingBackend,
            primaryFailure: primaryFailure,
            fallbackReason: fallbackReason,
            metricsDetail: metricsDetail
        )
    }

    static func reset() {
        lastSnapshot = nil
    }

    static func formattedDetail(base: String?) -> String? {
        guard let snapshot = lastSnapshot else {
            return base
        }

        var parts: [String] = []
        if let base, !base.isEmpty {
            parts.append(base)
        }
        parts.append("answered_by=\(snapshot.respondingBackend)")
        if let primaryFailure = snapshot.primaryFailure {
            parts.append("primary_failure=\(primaryFailure)")
        }
        if let fallbackReason = snapshot.fallbackReason {
            parts.append("fallback_reason=\(fallbackReason)")
        }
        if let metricsDetail = snapshot.metricsDetail {
            parts.append(metricsDetail)
        }
        return parts.isEmpty ? nil : parts.joined(separator: " | ")
    }
}
