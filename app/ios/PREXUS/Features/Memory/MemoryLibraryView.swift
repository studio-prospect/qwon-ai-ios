import SwiftUI

struct MemoryLibraryView: View {
    @StateObject private var viewModel: MemoryLibraryViewModel

    init(viewModel: MemoryLibraryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            if viewModel.memories.isEmpty {
                ContentUnavailableView(
                    "No Local Memory Yet",
                    systemImage: "memorychip",
                    description: Text("PREXUS will keep compact local episodes here after runtime turns.")
                )
                .padding(.top, 80)
            } else {
                LazyVStack(alignment: .leading, spacing: 14) {
                    summaryCard

                    ForEach(viewModel.memories, id: \.id) { memory in
                        memoryCard(memory)
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.delete(memory)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .padding()
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
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

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Local Memory Overview")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                statusChip("\(viewModel.memories.count) stored", tint: .purple)
                statusChip("On-device only", tint: .secondary)
            }

            Text("Episodes are compact summaries PREXUS keeps locally for future context. Retention follows the sensitivity policy, so local-only and provider-restricted turns are excluded from automatic storage.")
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

    private func memoryCard(_ memory: EpisodicMemory) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(memory.summary)
                .font(.body)
                .foregroundStyle(.primary)

            memoryChipRow(memory)
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

    private func memoryChipRow(_ memory: EpisodicMemory) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
                statusChip(memory.sensitivity.displayLabel, tint: sensitivityColor(for: memory.sensitivity))
                statusChip(memory.createdAt.formatted(date: .abbreviated, time: .shortened), tint: .secondary)
            }

            VStack(alignment: .leading, spacing: 6) {
                statusChip(memory.sensitivity.displayLabel, tint: sensitivityColor(for: memory.sensitivity))
                statusChip(memory.createdAt.formatted(date: .abbreviated, time: .shortened), tint: .secondary)
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

    private func sensitivityColor(for sensitivity: SensitivityLevel) -> Color {
        switch sensitivity {
        case .localOnly:
            return .secondary
        case .localPreferred:
            return .green
        case .escalationAllowed:
            return .blue
        case .providerRestricted:
            return .orange
        }
    }
}

#if DEBUG
#Preview {
    MemoryLibraryView.preview()
}

private extension MemoryLibraryView {
    static func preview() -> MemoryLibraryView {
        let store = InMemoryEpisodicMemoryStore()
        store.save(
            EpisodicMemory(
                id: UUID(),
                summary: "Summarized the current routing contract and sensitivity behavior for the iOS scaffold.",
                sensitivity: .localPreferred,
                createdAt: .now
            )
        )
        store.save(
            EpisodicMemory(
                id: UUID(),
                summary: "Captured a concise note about diagnostics chip ordering after the latest UI polish pass.",
                sensitivity: .escalationAllowed,
                createdAt: .now.addingTimeInterval(-3_600)
            )
        )
        return MemoryLibraryView(viewModel: MemoryLibraryViewModel(memoryStore: store))
    }
}
#endif
