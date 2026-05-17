import Foundation

struct VisionSummary {
    let summary: String
    let confidence: Double
}

protocol VisionAnalyzer {
    func analyze(sourceIdentifier: String) async throws -> VisionSummary
}
