import Foundation

struct RuntimeDiagnosticEntry: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let routeTier: String
    let routeTarget: String
    let routeReasons: [String]
    let executionMode: String
    let executionProvider: String?
    let executionModel: String?
    let executionDetail: String?
    let userText: String

    init(id: UUID, timestamp: Date, route: RouteDecision, execution: RuntimeExecutionMetadata, userText: String) {
        self.id = id
        self.timestamp = timestamp
        self.routeTier = route.tier.rawValue
        self.routeTarget = route.target.rawValue
        self.routeReasons = route.reasonCodes
        self.executionMode = execution.mode.rawValue
        self.executionProvider = execution.provider?.rawValue
        self.executionModel = execution.model
        self.executionDetail = execution.detail
        self.userText = userText
    }

    var routeSummary: String {
        "Route: \(routeTarget) | Tier: \(routeTier)"
    }

    var reasonSummary: String {
        routeReasons.joined(separator: ", ")
    }

    var executionStatusSummary: String {
        let headline: String
        switch executionMode {
        case RuntimeExecutionMode.local.rawValue:
            headline = "Local runtime"
        case RuntimeExecutionMode.cloud.rawValue:
            headline = "Cloud execution"
        case RuntimeExecutionMode.fallback.rawValue:
            headline = "Local fallback"
        default:
            headline = executionMode.capitalized
        }

        let path = [executionProvider, executionModel]
            .compactMap { $0 }
            .joined(separator: " / ")

        if let executionDetail, !executionDetail.isEmpty {
            return path.isEmpty
                ? "\(headline) | \(executionDetail)"
                : "\(headline) | \(path) | \(executionDetail)"
        }

        return path.isEmpty ? headline : "\(headline) | \(path)"
    }
}

@MainActor
final class RuntimeDiagnosticsStore: ObservableObject {
    @Published private(set) var entries: [RuntimeDiagnosticEntry] = []

    private let defaults: UserDefaults
    private let maxEntries: Int
    private let storageKey = "prexus.runtime-diagnostics"

    init(defaults: UserDefaults = .standard, maxEntries: Int = 20) {
        self.defaults = defaults
        self.maxEntries = maxEntries
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([RuntimeDiagnosticEntry].self, from: data) {
            entries = Array(decoded.prefix(maxEntries))
        }
    }

    func record(route: RouteDecision, execution: RuntimeExecutionMetadata, userText: String) {
        entries.insert(
            RuntimeDiagnosticEntry(id: UUID(), timestamp: Date(), route: route, execution: execution, userText: userText),
            at: 0
        )

        if entries.count > maxEntries {
            entries.removeLast(entries.count - maxEntries)
        }

        persist()
    }

    func clear() {
        entries.removeAll()
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        defaults.set(data, forKey: storageKey)
    }
}
