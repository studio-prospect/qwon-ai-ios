import SwiftUI

struct RuntimeDiagnosticsView: View {
    @ObservedObject var diagnostics: RuntimeDiagnosticsStore

    var body: some View {
        List {
            if diagnostics.entries.isEmpty {
                ContentUnavailableView(
                    "No Runtime Diagnostics Yet",
                    systemImage: "waveform.path.ecg",
                    description: Text("PREXUS will capture recent route and execution decisions here.")
                )
                .listRowBackground(Color.clear)
            } else {
                ForEach(diagnostics.entries) { entry in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry.userText)
                            .font(.body)
                            .foregroundStyle(.primary)
                            .lineLimit(2)

                        Text(entry.execution.statusSummary)
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        Text("Route: \(entry.route.target.rawValue) | Tier: \(entry.route.tier.rawValue)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(entry.timestamp.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Runtime Diagnostics")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !diagnostics.entries.isEmpty {
                    Button("Clear", role: .destructive) {
                        diagnostics.clear()
                    }
                }
            }
        }
    }
}
