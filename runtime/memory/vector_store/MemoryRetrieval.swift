import Foundation

protocol MemoryRetrieval {
    func recall(query: String, limit: Int) -> [EpisodicMemory]
}

struct EmptyMemoryRetrieval: MemoryRetrieval {
    func recall(query: String, limit: Int) -> [EpisodicMemory] {
        []
    }
}
