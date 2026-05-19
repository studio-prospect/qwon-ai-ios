import Foundation

struct RuntimeMessage: Equatable {
    enum Role: String, Equatable {
        case system
        case user
        case assistant
    }

    let role: Role
    let content: String
}
