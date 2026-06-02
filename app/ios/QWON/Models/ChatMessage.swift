import Foundation

struct ChatMessage: Identifiable, Equatable {
    enum Role: String {
        case system
        case user
        case assistant

        var label: String {
            rawValue.capitalized
        }
    }

    let id = UUID()
    let role: Role
    let content: String
}
