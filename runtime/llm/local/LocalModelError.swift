import Foundation

enum LocalModelError: Error, Equatable {
    case deviceNotSupported
    case modelAssetUnavailable
    case backendUnavailable(String)
    case generationCancelled
    case generationFailed(String)
}
