import Foundation

final class PersistentMemoryStore: EpisodicMemoryStore {
    private let defaults: UserDefaults
    private let storageKey = "prexus.episodic-memory"
    private var storage: [EpisodicMemory]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([EpisodicMemory].self, from: data) {
            storage = decoded
        } else {
            storage = []
        }
    }

    func save(_ memory: EpisodicMemory) {
        storage.append(memory)
        persist()
    }

    func all() -> [EpisodicMemory] {
        storage.sorted { $0.createdAt > $1.createdAt }
    }

    func recent(limit: Int) -> [EpisodicMemory] {
        Array(storage.suffix(limit))
    }

    func delete(id: UUID) {
        storage.removeAll { $0.id == id }
        persist()
    }

    func removeAll() {
        storage.removeAll()
        persist()
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(storage) else { return }
        defaults.set(data, forKey: storageKey)
    }
}
