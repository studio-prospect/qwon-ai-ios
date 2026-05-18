import SwiftUI

struct MemoryLibraryView: View {
    @StateObject private var viewModel: MemoryLibraryViewModel

    init(viewModel: MemoryLibraryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            if viewModel.memories.isEmpty {
                LazyVStack(alignment: .leading, spacing: 14) {
                    screenIntro

                    PREXUSEmptyState(
                        title: "No Local Memory Yet",
                        systemImage: "memorychip",
                        message: "PREXUS will keep compact local episodes here after eligible runtime turns.",
                        tint: .purple
                    )
                    .accessibilityIdentifier(PREXUSAccessibilityID.Memory.empty)
                }
                .padding()
                .padding(.top, 24)
            } else {
                LazyVStack(alignment: .leading, spacing: 14) {
                    screenIntro

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
                    .accessibilityIdentifier(PREXUSAccessibilityID.Memory.clearAll)
                }
            }
        }
        .onAppear {
            viewModel.refresh()
        }
        .accessibilityIdentifier(PREXUSAccessibilityID.Memory.screen)
    }

    private var screenIntro: some View {
        PREXUSScreenIntro(
            eyebrow: "Local context",
            title: "Memory",
            message: "Browse the compact on-device episodes PREXUS retained for future context."
        )
    }

    private var summaryCard: some View {
        PREXUSSurfaceCard {
            VStack(alignment: .leading, spacing: 8) {
                Text("Local Memory Overview")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    PREXUSStatusChip("\(viewModel.memories.count) stored", tint: .purple)
                    PREXUSStatusChip("On-device only", tint: .secondary)
                }

                Text("Episodes are compact summaries PREXUS keeps locally for future context. Retention follows the sensitivity policy, so local-only and provider-restricted turns are excluded from automatic storage.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityIdentifier(PREXUSAccessibilityID.Memory.summary)
    }

    private func memoryCard(_ memory: EpisodicMemory) -> some View {
        PREXUSSurfaceCard(borderTint: Color(uiColor: .quaternaryLabel)) {
            VStack(alignment: .leading, spacing: 10) {
                Text(memory.summary)
                    .font(.body)
                    .foregroundStyle(.primary)

                memoryChipRow(memory)
            }
        }
    }

    private func memoryChipRow(_ memory: EpisodicMemory) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
                PREXUSStatusChip(memory.sensitivity.displayLabel, tint: sensitivityColor(for: memory.sensitivity))
                PREXUSStatusChip(memory.createdAt.formatted(date: .abbreviated, time: .shortened), tint: .secondary)
            }

            VStack(alignment: .leading, spacing: 6) {
                PREXUSStatusChip(memory.sensitivity.displayLabel, tint: sensitivityColor(for: memory.sensitivity))
                PREXUSStatusChip(memory.createdAt.formatted(date: .abbreviated, time: .shortened), tint: .secondary)
            }
        }
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

#Preview("Compact") {
    MemoryLibraryView.preview()
        .frame(width: 320, height: 760)
}

#Preview("Empty") {
    NavigationStack {
        MemoryLibraryView(viewModel: MemoryLibraryViewModel(memoryStore: InMemoryEpisodicMemoryStore()))
    }
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
