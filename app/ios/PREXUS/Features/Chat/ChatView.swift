import SwiftUI

struct ChatView: View {
    @State private var draft = ""
    @StateObject private var viewModel: ChatViewModel

    init(viewModel: ChatViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
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
}
