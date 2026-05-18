import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel

    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isSending, let stateSummary = viewModel.sendStateSummary {
                turnStateBanner(stateSummary)
            } else if let execution = viewModel.latestExecution {
                runtimeStatusBanner(execution)
            }

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(message.role.label)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(message.content)
                                .font(.body)
                                .textSelection(.enabled)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding()
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                if let route = viewModel.displayedRoute {
                    previewRouteBanner(route)
                }

                composerCard
            }
            .padding()
            .background(.bar)
        }
        .navigationTitle("PREXUS")
    }

    @ViewBuilder
    private var sensitivityPicker: some View {
        ViewThatFits(in: .horizontal) {
            sensitivitySegmentedPicker(useCompactLabels: false)

            sensitivitySegmentedPicker(useCompactLabels: true)

            sensitivityMenuPicker
        }
    }

    private var sensitivityMenuPicker: some View {
        Picker("Sensitivity", selection: $viewModel.selectedSensitivity) {
            ForEach(SensitivityLevel.allCases, id: \.self) { level in
                Text(level.displayLabel).tag(level)
            }
        }
        .pickerStyle(.menu)
        .padding(.horizontal, 2)
    }

    private var sensitivityDescription: LocalizedStringKey {
        LocalizedStringKey(viewModel.displayedSensitivity.helperDescription)
    }

    private var composerCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Sensitivity")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                sensitivityPicker

                Text(sensitivityDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(alignment: .bottom, spacing: 12) {
                TextField("Ask PREXUS", text: $viewModel.draftText, axis: .vertical)
                    .font(.body)
                    .lineLimit(1...6)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.background)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(.quaternary, lineWidth: 1)
                    )
                    .disabled(viewModel.isSending)

                Button {
                    let text = viewModel.draftText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !text.isEmpty else { return }
                    viewModel.send(text: text)
                } label: {
                    Group {
                        if viewModel.isSending {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                        } else {
                            Text("Send")
                                .fontWeight(.medium)
                        }
                    }
                    .frame(minWidth: 74)
                    .frame(height: 44)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isSending)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.quaternary.opacity(0.6), lineWidth: 1)
        )
    }

    @ViewBuilder
    private func turnStateBanner(_ summary: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            ProgressView()
                .controlSize(.small)
                .tint(.blue)

            VStack(alignment: .leading, spacing: 2) {
                Text("Turn In Progress")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(summary)
                    .font(.footnote)
                    .foregroundStyle(.primary)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.bar)
    }

    @ViewBuilder
    private func runtimeStatusBanner(_ execution: RuntimeExecutionMetadata) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: iconName(for: execution.mode))
                .font(.caption)
                .foregroundStyle(accentColor(for: execution.mode))

            VStack(alignment: .leading, spacing: 2) {
                Text("Runtime Status")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(execution.statusSummary)
                    .font(.footnote)
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.bar)
    }

    @ViewBuilder
    private func previewRouteBanner(_ route: RouteDecision) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: route.target == .local ? "arrow.triangle.branch" : "arrow.up.right.square")
                .font(.caption)
                .foregroundStyle(route.target == .local ? .green : .blue)

            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.routeBannerTitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(route.statusSummary)
                    .font(.footnote)
                    .foregroundStyle(.primary)
                Text(viewModel.displayedSensitivity.displayLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text(route.displayReasonSummary)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    private func sensitivitySegmentedPicker(useCompactLabels: Bool) -> some View {
        Picker("Sensitivity", selection: $viewModel.selectedSensitivity) {
            ForEach(SensitivityLevel.allCases, id: \.self) { level in
                Text(useCompactLabels ? level.compactDisplayLabel : level.displayLabel)
                    .tag(level)
            }
        }
        .pickerStyle(.segmented)
        .disabled(viewModel.isSending)
    }

    private func iconName(for mode: RuntimeExecutionMode) -> String {
        switch mode {
        case .local:
            return "iphone"
        case .cloud:
            return "cloud"
        case .fallback:
            return "arrow.trianglehead.clockwise"
        }
    }

    private func accentColor(for mode: RuntimeExecutionMode) -> Color {
        switch mode {
        case .local:
            return .green
        case .cloud:
            return .blue
        case .fallback:
            return .orange
        }
    }
}
