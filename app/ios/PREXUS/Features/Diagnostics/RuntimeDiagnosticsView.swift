import SwiftUI

struct RuntimeDiagnosticsView: View {
    @ObservedObject var diagnostics: RuntimeDiagnosticsStore

    var body: some View {
        ScrollView {
            if diagnostics.entries.isEmpty {
                ContentUnavailableView(
                    "No Runtime Diagnostics Yet",
                    systemImage: "waveform.path.ecg",
                    description: Text("PREXUS will capture recent route and execution decisions here.")
                )
                .padding(.top, 80)
            } else {
                LazyVStack(alignment: .leading, spacing: 14) {
                    diagnosticsSummaryCard

                    ForEach(diagnostics.entries) { entry in
                        diagnosticCard(entry)
                    }
                }
                .padding()
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
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

    private var diagnosticsSummaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Recent Runtime Decisions")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                statusChip("\(diagnostics.entries.count) kept", tint: .blue)
                statusChip("Local-only history", tint: .secondary)
            }

            Text("Entries show the route target, execution path, and primary reason first so you can scan policy behavior without opening raw logs.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(.quaternary.opacity(0.8), lineWidth: 1)
        )
    }

    private func diagnosticCard(_ entry: RuntimeDiagnosticEntry) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(entry.userText)
                .font(.body)
                .foregroundStyle(.primary)
                .lineLimit(3)

            diagnosticChipRow(entry)

            if !entry.secondaryReasonSummary.isEmpty {
                Text(entry.secondaryReasonSummary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack(alignment: .center, spacing: 8) {
                if let detail = entry.executionDetail, !detail.isEmpty {
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                Text(entry.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.background)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(.quaternary.opacity(0.8), lineWidth: 1)
        )
    }

    private func diagnosticChipRow(_ entry: RuntimeDiagnosticEntry) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
                statusChip(entry.executionBadgeLabel, tint: color(for: entry.executionTint))
                statusChip(entry.routeBadgeLabel, tint: color(for: entry.routeTint))

                if !entry.primaryReasonSummary.isEmpty {
                    statusChip(entry.primaryReasonSummary, tint: .secondary)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    statusChip(entry.executionBadgeLabel, tint: color(for: entry.executionTint))
                    statusChip(entry.routeBadgeLabel, tint: color(for: entry.routeTint))
                }

                if !entry.primaryReasonSummary.isEmpty {
                    statusChip(entry.primaryReasonSummary, tint: .secondary)
                }
            }
        }
    }

    private func statusChip(_ title: String, tint: Color) -> some View {
        Text(title)
            .font(.caption.weight(.medium))
            .foregroundStyle(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(tint.opacity(0.12))
            )
    }

    private func color(for token: ColorToken) -> Color {
        switch token {
        case .blue:
            return .blue
        case .green:
            return .green
        case .orange:
            return .orange
        case .secondary:
            return .secondary
        }
    }
}

#if DEBUG
#Preview {
    RuntimeDiagnosticsView.preview()
}

private extension RuntimeDiagnosticsView {
    static func preview() -> RuntimeDiagnosticsView {
        let suiteName = "PREXUS.DiagnosticsPreview.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        let store = RuntimeDiagnosticsStore(defaults: defaults)
        store.record(
            route: RouteDecision(tier: .tier3, target: .openAI, reasonCodes: ["codeAnalysis", "provider_restricted"]),
            execution: RuntimeExecutionMetadata(mode: .cloud, provider: .openAI, model: "gpt-5-mini", detail: "Escalated for code-quality review."),
            userText: "Review this runtime container for hidden escalation bugs."
        )
        store.record(
            route: RouteDecision(tier: .tier2, target: .local, reasonCodes: ["generalChat", "local_default"]),
            execution: RuntimeExecutionMetadata(mode: .local, provider: nil, model: "On-device runtime", detail: "Handled locally as default chat."),
            userText: "Summarize what changed in the settings screen."
        )
        return RuntimeDiagnosticsView(diagnostics: store)
    }
}
#endif
