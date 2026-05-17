import Foundation

struct AudioTranscript {
    let text: String
    let confidence: Double
}

protocol AudioInputProcessor {
    func transcribe() async throws -> AudioTranscript
}
