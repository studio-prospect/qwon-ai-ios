import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel

    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            if let execution = viewModel.latestExecution {
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
                if let route = viewModel.previewRoute {
                    previewRouteBanner(route)
                }

                Picker("Sensitivity", selection: $viewModel.selectedSensitivity) {
                    Text("Local Only").tag(SensitivityLevel.localOnly)
                    Text("Local Preferred").tag(SensitivityLevel.localPreferred)
                    Text("Escalation Allowed").tag(SensitivityLevel.escalationAllowed)
                }
                .pickerStyle(.segmented)

                HStack(alignment: .bottom, spacing: 12) {
                    TextField("Ask PREXUS", text: $viewModel.draftText, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(1...6)

                    Button("Send") {
                        let text = viewModel.draftText.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !text.isEmpty else { return }
                        viewModel.send(text: text)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isSending)
                }
            }
            .padding()
        }
        .navigationTitle("PREXUS")
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
                Text("Planned Route")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(route.target.rawValue) | \(route.tier.rawValue)")
                    .font(.footnote)
                    .foregroundStyle(.primary)
                Text(route.reasonSummary)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
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
