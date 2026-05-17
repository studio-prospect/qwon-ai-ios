import Foundation

struct EpisodicMemory: Codable, Equatable {
    let id: UUID
    let summary: String
    let sensitivity: SensitivityLevel
    let createdAt: Date
}

protocol EpisodicMemoryStore {
    func save(_ memory: EpisodicMemory)
    func recent(limit: Int) -> [EpisodicMemory]
}

final class InMemoryEpisodicMemoryStore: EpisodicMemoryStore {
    private var storage: [EpisodicMemory] = []

    func save(_ memory: EpisodicMemory) {
        storage.append(memory)
    }

    func recent(limit: Int) -> [EpisodicMemory] {
        Array(storage.suffix(limit))
    }
}
