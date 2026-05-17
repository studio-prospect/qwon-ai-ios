import Foundation

protocol DocumentIndexer {
    func index(documentID: String, content: String) async throws
}
