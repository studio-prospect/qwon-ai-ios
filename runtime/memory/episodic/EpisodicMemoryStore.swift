import Foundation

struct EpisodicMemory: Codable, Equatable {
    let id: UUID
    let summary: String
    let sensitivity: SensitivityLevel
    let createdAt: Date
}

protocol EpisodicMemoryStore {
    func save(_ memory: EpisodicMemory)
    func all() -> [EpisodicMemory]
    func recent(limit: Int) -> [EpisodicMemory]
    func delete(id: UUID)
    func removeAll()
}

final class InMemoryEpisodicMemoryStore: EpisodicMemoryStore {
    private var storage: [EpisodicMemory] = []

    func save(_ memory: EpisodicMemory) {
        storage.append(memory)
    }

    func all() -> [EpisodicMemory] {
        storage.sorted { $0.createdAt > $1.createdAt }
    }

    func recent(limit: Int) -> [EpisodicMemory] {
        Array(storage.suffix(limit))
    }

    func delete(id: UUID) {
        storage.removeAll { $0.id == id }
    }

    func removeAll() {
        storage.removeAll()
    }
}
