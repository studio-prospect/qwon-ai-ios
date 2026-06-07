import SwiftUI

#if QWON_M3_MODEL_DOWNLOAD_SPIKE

struct QWONM3ModelDownloadSpikeSection: View {
    let status: QWONLocalModelStatus
    @ObservedObject var store: QWONM3ModelDownloadStore
    var onStatusRefresh: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if status.chipTier == .unsupported {
                Text(QWONUILabelCopy.M3ModelDownload.matisseDetail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(QWONUILabelCopy.M3ModelDownload.progressDetail(for: store.phase))
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if store.requiresReplaceConfirmation {
                Toggle(
                    QWONUILabelCopy.M3ModelDownload.replaceToggleTitle,
                    isOn: $store.replaceExistingConfirmed
                )

                Text(QWONUILabelCopy.M3ModelDownload.replaceToggleDetail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(spacing: 12) {
                switch store.phase {
                case .downloading, .verifying, .promoting:
                    Button(QWONUILabelCopy.M3ModelDownload.cancelButtonTitle, role: .destructive) {
                        store.cancelDownload()
                    }
                    .accessibilityIdentifier(QWONAccessibilityID.Settings.m3CancelDownload)
                case .failed:
                    Button("Try Again") {
                        store.resetFailure()
                    }
                    .accessibilityIdentifier(QWONAccessibilityID.Settings.m3RetryDownload)

                    if store.canStartDownload {
                        downloadButton
                    }
                default:
                    if status.chipTier == .a17ProOrNewer, !status.manifestVerified {
                        downloadButton
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .onChange(of: store.phase) { _, newPhase in
            if case .completed = newPhase {
                onStatusRefresh()
            }
        }
    }

    @ViewBuilder
    private var downloadButton: some View {
        Button(QWONUILabelCopy.M3ModelDownload.downloadButtonTitle) {
            store.startDownload()
        }
        .disabled(!store.canStartDownload)
        .accessibilityIdentifier(QWONAccessibilityID.Settings.m3StartDownload)
    }
}

#endif
