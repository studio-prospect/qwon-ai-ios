import SwiftUI

struct QWONLocalModelStatusCard: View {
    let status: QWONLocalModelStatus
    var showsDiagnosticsMapping: Bool = false

    var body: some View {
        QWONSurfaceCard(borderTint: borderTint) {
            VStack(alignment: .leading, spacing: 10) {
                Text(QWONUILabelCopy.ModelStatus.cardTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) {
                        QWONStatusChip(
                            QWONLocalModelStatusPresentation.statusChipLabel(for: status),
                            tint: chipColor(for: QWONLocalModelStatusPresentation.statusChipTint(for: status))
                        )
                        QWONStatusChip(
                            QWONLocalModelStatusPresentation.tierChipLabel(for: status),
                            tint: .blue
                        )
                        QWONStatusChip(
                            QWONLocalModelStatusPresentation.expectedRuntimeLabel(for: status),
                            tint: .secondary
                        )
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            QWONStatusChip(
                                QWONLocalModelStatusPresentation.statusChipLabel(for: status),
                                tint: chipColor(for: QWONLocalModelStatusPresentation.statusChipTint(for: status))
                            )
                            QWONStatusChip(
                                QWONLocalModelStatusPresentation.tierChipLabel(for: status),
                                tint: .blue
                            )
                        }
                        QWONStatusChip(
                            QWONLocalModelStatusPresentation.expectedRuntimeLabel(for: status),
                            tint: .secondary
                        )
                    }
                }

                modelFileDetail

                Text(QWONLocalModelStatusPresentation.summaryDetail(for: status))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                if showsDiagnosticsMapping {
                    Text(QWONLocalModelStatusPresentation.diagnosticsMappingDetail(for: status))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var modelFileDetail: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Expected file: \(QWONLocalModelStatus.expectedFileName)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)

            Text("Placement: \(QWONLocalModelStatus.expectedRelativePlacement)")
                .font(.caption)
                .foregroundStyle(.secondary)

            if let resolvedFileName = status.resolvedFileName {
                Text("Resolved file: \(resolvedFileName)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if case let .presentUnverified(_, byteCount) = status.placementState, byteCount > 0 {
                Text("Size: \(ByteCountFormatter.string(fromByteCount: byteCount, countStyle: .file))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var borderTint: Color {
        switch QWONLocalModelStatusPresentation.statusChipTint(for: status) {
        case .green:
            return Color.green.opacity(0.18)
        case .orange:
            return Color.orange.opacity(0.18)
        case .blue:
            return Color.blue.opacity(0.18)
        case .secondary:
            return Color(uiColor: .quaternaryLabel)
        }
    }

    private func chipColor(for tint: QWONModelStatusChipTint) -> Color {
        switch tint {
        case .green:
            return .green
        case .orange:
            return .orange
        case .blue:
            return .blue
        case .secondary:
            return .secondary
        }
    }
}

#if DEBUG
#Preview("Missing Wang-class") {
    QWONLocalModelStatusCard(
        status: QWONLocalModelStatus(
            placementState: .missing,
            chipTier: .a17ProOrNewer,
            machineIdentifier: "iPhone16,1",
            isSimulator: false,
            resolvedFileName: nil,
            expectedPathPresent: false
        )
    )
    .padding()
}

#Preview("Diagnostics mapping") {
    QWONLocalModelStatusCard(
        status: QWONLocalModelStatus(
            placementState: .missing,
            chipTier: .unsupported,
            machineIdentifier: "iPhone11,6",
            isSimulator: false,
            resolvedFileName: nil,
            expectedPathPresent: false
        ),
        showsDiagnosticsMapping: true
    )
    .padding()
}
#endif
