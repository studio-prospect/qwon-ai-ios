import SwiftUI

struct ChatView: View {
    @State private var draft = ""
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

            HStack(alignment: .bottom, spacing: 12) {
                TextField("Ask PREXUS", text: $draft, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(1...6)

                Button("Send") {
                    let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !text.isEmpty else { return }
                    viewModel.send(text: text)
                    draft = ""
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isSending)
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
