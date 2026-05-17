import Foundation

struct OCRResult {
    let text: String
    let confidence: Double
}

protocol OCRProcessor {
    func extractText(from sourceIdentifier: String) async throws -> OCRResult
}
