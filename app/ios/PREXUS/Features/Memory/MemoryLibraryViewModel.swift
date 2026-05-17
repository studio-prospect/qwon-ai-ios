import Foundation

@MainActor
final class MemoryLibraryViewModel: ObservableObject {
    @Published private(set) var memories: [EpisodicMemory] = []

    private let memoryStore: EpisodicMemoryStore

    init(memoryStore: EpisodicMemoryStore) {
        self.memoryStore = memoryStore
        refresh()
    }

    func refresh() {
        memories = memoryStore.all()
    }

    func delete(_ memory: EpisodicMemory) {
        memoryStore.delete(id: memory.id)
        refresh()
    }

    func clearAll() {
        memoryStore.removeAll()
        refresh()
    }
}
