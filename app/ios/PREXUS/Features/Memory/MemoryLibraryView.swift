import SwiftUI

struct MemoryLibraryView: View {
    @StateObject private var viewModel: MemoryLibraryViewModel

    init(viewModel: MemoryLibraryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            if viewModel.memories.isEmpty {
                ContentUnavailableView(
                    "No Local Memory Yet",
                    systemImage: "memorychip",
                    description: Text("PREXUS will keep compact local episodes here after runtime turns.")
                )
                .listRowBackground(Color.clear)
            } else {
                ForEach(viewModel.memories, id: \.id) { memory in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(memory.summary)
                            .font(.body)
                            .foregroundStyle(.primary)

                        HStack(spacing: 8) {
                            Text(memory.sensitivity.rawValue)
                            Text(memory.createdAt.formatted(date: .abbreviated, time: .shortened))
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.delete(memory)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle("Local Memory")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if !viewModel.memories.isEmpty {
                    Button("Clear All", role: .destructive) {
                        viewModel.clearAll()
                    }
                }
            }
        }
        .onAppear {
            viewModel.refresh()
        }
    }
}
