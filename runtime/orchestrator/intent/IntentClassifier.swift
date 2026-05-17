import Foundation

enum RuntimeIntent: String {
    case generalChat
    case summarization
    case ocrExtraction
    case codeAnalysis
    case creativeWriting
    case visionReasoning
}

protocol IntentClassifier {
    func classify(request: RuntimeRequest) -> RuntimeIntent
}

struct HeuristicIntentClassifier: IntentClassifier {
    func classify(request: RuntimeRequest) -> RuntimeIntent {
        let lowercased = request.text.lowercased()

        if request.modality == .image {
            return .visionReasoning
        }
        if lowercased.contains("summarize") || lowercased.contains("summary") {
            return .summarization
        }
        if lowercased.contains("ocr") || lowercased.contains("extract text") {
            return .ocrExtraction
        }
        if lowercased.contains("code") || lowercased.contains("swift") || lowercased.contains("bug") {
            return .codeAnalysis
        }
        if lowercased.contains("write") || lowercased.contains("story") || lowercased.contains("creative") {
            return .creativeWriting
        }

        return .generalChat
    }
}
