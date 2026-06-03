import SwiftUI

struct RuntimeDiagnosticsView: View {
    @ObservedObject var diagnostics: RuntimeDiagnosticsStore

    var body: some View {
        ScrollView {
            if diagnostics.entries.isEmpty {
                LazyVStack(alignment: .leading, spacing: 14) {
                    screenIntro

                    QWONEmptyState(
                        title: "No Runtime Diagnostics Yet",
                        systemImage: "waveform.path.ecg",
                        message: QWONUILabelCopy.Diagnostics.emptyMessage,
                        tint: .blue
                    )
                    .accessibilityIdentifier(QWONAccessibilityID.Diagnostics.empty)
                }
                .padding()
                .padding(.top, 24)
            } else {
                LazyVStack(alignment: .leading, spacing: 14) {
                    screenIntro

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
                    .accessibilityIdentifier(QWONAccessibilityID.Diagnostics.clear)
                }
            }
        }
        .accessibilityIdentifier(QWONAccessibilityID.Diagnostics.screen)
    }

    private var screenIntro: some View {
        QWONScreenIntro(
            eyebrow: "Runtime visibility",
            title: "Diagnostics",
            message: QWONUILabelCopy.Diagnostics.introMessage
        )
    }

    private var diagnosticsSummaryCard: some View {
        QWONSurfaceCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Recent Runtime Decisions")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    QWONStatusChip("\(diagnostics.entries.count) kept", tint: .blue)
                    QWONStatusChip("Local-only history", tint: .secondary)
                }

                Text(QWONUILabelCopy.Diagnostics.summaryDetail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityIdentifier(QWONAccessibilityID.Diagnostics.summary)
    }

    private func diagnosticCard(_ entry: RuntimeDiagnosticEntry) -> some View {
        QWONSurfaceCard(borderTint: Color(uiColor: .quaternaryLabel)) {
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
        }
    }

    private func diagnosticChipRow(_ entry: RuntimeDiagnosticEntry) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
                QWONStatusChip(entry.executionBadgeLabel, tint: color(for: entry.executionTint))
                QWONStatusChip(entry.routeBadgeLabel, tint: color(for: entry.routeTint))

                if !entry.primaryReasonSummary.isEmpty {
                    QWONStatusChip(entry.primaryReasonSummary, tint: .secondary)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    QWONStatusChip(entry.executionBadgeLabel, tint: color(for: entry.executionTint))
                    QWONStatusChip(entry.routeBadgeLabel, tint: color(for: entry.routeTint))
                }

                if !entry.primaryReasonSummary.isEmpty {
                    QWONStatusChip(entry.primaryReasonSummary, tint: .secondary)
                }
            }
        }
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

#Preview("Compact") {
    RuntimeDiagnosticsView.preview()
        .frame(width: 320, height: 760)
}

#Preview("Empty") {
    NavigationStack {
        RuntimeDiagnosticsView(diagnostics: RuntimeDiagnosticsStore(defaults: UserDefaults(suiteName: "QWON.DiagnosticsEmptyPreview.\(UUID().uuidString)")!))
    }
}

private extension RuntimeDiagnosticsView {
    static func preview() -> RuntimeDiagnosticsView {
        let suiteName = "QWON.DiagnosticsPreview.\(UUID().uuidString)"
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
