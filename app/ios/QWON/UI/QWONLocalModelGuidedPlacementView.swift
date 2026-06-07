import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

struct QWONLocalModelGuidedPlacementView: View {
    let status: QWONLocalModelStatus
    @State private var copiedCommandID: String?

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 14) {
                QWONScreenIntro(
                    eyebrow: "External ops",
                    title: "Place GGUF via Mac",
                    message: QWONUILabelCopy.GuidedPlacement.introMessage
                )

                QWONLocalModelStatusCard(status: status)

                placementStepsCard

                deviceExpectationsCard

                supportNoteCard
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .navigationTitle("Place GGUF via Mac")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityIdentifier(QWONAccessibilityID.Settings.guidedPlacementScreen)
    }

    private var placementStepsCard: some View {
        QWONSurfaceCard(borderTint: Color.blue.opacity(0.16)) {
            VStack(alignment: .leading, spacing: 14) {
                Text(QWONUILabelCopy.GuidedPlacement.stepsTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                guidedStep(
                    id: "prepare-mac",
                    number: 1,
                    title: QWONUILabelCopy.GuidedPlacement.stepPrepareMacTitle,
                    detail: QWONUILabelCopy.GuidedPlacement.stepPrepareMacDetail
                )

                guidedCommandStep(
                    id: "fetch-model",
                    number: 2,
                    title: QWONUILabelCopy.GuidedPlacement.stepFetchModelTitle,
                    detail: QWONUILabelCopy.GuidedPlacement.stepFetchModelDetail,
                    command: QWONLocalModelGuidedPlacementCommands.fetchLocalModel
                )

                guidedStep(
                    id: "connect-device",
                    number: 3,
                    title: QWONUILabelCopy.GuidedPlacement.stepConnectDeviceTitle,
                    detail: QWONUILabelCopy.GuidedPlacement.stepConnectDeviceDetail
                )

                guidedCommandStep(
                    id: "push-model",
                    number: 4,
                    title: QWONUILabelCopy.GuidedPlacement.stepPushModelTitle,
                    detail: QWONUILabelCopy.GuidedPlacement.stepPushModelDetail,
                    command: QWONLocalModelGuidedPlacementCommands.pushLocalModelTemplate
                )

                guidedStep(
                    id: "verify-settings",
                    number: 5,
                    title: QWONUILabelCopy.GuidedPlacement.stepVerifyTitle,
                    detail: QWONUILabelCopy.GuidedPlacement.stepVerifyDetail
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var deviceExpectationsCard: some View {
        QWONSurfaceCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(QWONUILabelCopy.GuidedPlacement.deviceExpectationsTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(QWONUILabelCopy.GuidedPlacement.wangExpectation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(QWONUILabelCopy.GuidedPlacement.matisseExpectation)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var supportNoteCard: some View {
        QWONSurfaceCard(borderTint: Color.orange.opacity(0.14)) {
            VStack(alignment: .leading, spacing: 8) {
                Text(QWONUILabelCopy.GuidedPlacement.supportTitle)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(QWONUILabelCopy.GuidedPlacement.supportDetail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func guidedStep(id: String, number: Int, title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(number). \(title)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)

            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityIdentifier("\(QWONAccessibilityID.Settings.guidedPlacementStep).\(id)")
    }

    private func guidedCommandStep(
        id: String,
        number: Int,
        title: String,
        detail: String,
        command: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            guidedStep(id: id, number: number, title: title, detail: detail)

            HStack(alignment: .top, spacing: 10) {
                Text(command)
                    .font(.caption.monospaced())
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Button(copyButtonTitle(for: id)) {
                    copyToClipboard(command, commandID: id)
                }
                .font(.caption.weight(.semibold))
                .buttonStyle(.bordered)
                .accessibilityIdentifier("\(QWONAccessibilityID.Settings.guidedPlacementCopy).\(id)")
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            )
        }
    }

    private func copyButtonTitle(for commandID: String) -> String {
        copiedCommandID == commandID
            ? QWONUILabelCopy.GuidedPlacement.copiedButtonTitle
            : QWONUILabelCopy.GuidedPlacement.copyButtonTitle
    }

    private func copyToClipboard(_ text: String, commandID: String) {
        #if canImport(UIKit)
        UIPasteboard.general.string = text
        #endif
        copiedCommandID = commandID
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        QWONLocalModelGuidedPlacementView(
            status: QWONLocalModelStatus(
            placementState: .missing,
            chipTier: .a17ProOrNewer,
            machineIdentifier: "iPhone16,1",
            isSimulator: false,
            resolvedFileName: nil,
            expectedPathPresent: false,
            manifestVerified: false
        )
        )
    }
}
#endif
