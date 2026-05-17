import Foundation

struct RuntimeDiagnosticEntry: Identifiable {
    let id: UUID
    let timestamp: Date
    let route: RouteDecision
    let execution: RuntimeExecutionMetadata
    let userText: String
}

@MainActor
final class RuntimeDiagnosticsStore: ObservableObject {
    @Published private(set) var entries: [RuntimeDiagnosticEntry] = []

    private let maxEntries: Int

    init(maxEntries: Int = 20) {
        self.maxEntries = maxEntries
    }

    func record(route: RouteDecision, execution: RuntimeExecutionMetadata, userText: String) {
        entries.insert(
            RuntimeDiagnosticEntry(
                id: UUID(),
                timestamp: Date(),
                route: route,
                execution: execution,
                userText: userText
            ),
            at: 0
        )

        if entries.count > maxEntries {
            entries.removeLast(entries.count - maxEntries)
        }
    }

    func clear() {
        entries.removeAll()
    }
}
