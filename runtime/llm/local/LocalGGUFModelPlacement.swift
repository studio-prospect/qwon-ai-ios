import Foundation

struct LocalGGUFModelPlacement {
    static let defaultModelFileName = "prexus-local-mvp.gguf"
    /// Evaluation-only Gemma artifact; used when the default MVP file is absent on device.
    static let evaluationGemmaModelFileName = "prexus-eval-gemma4-e2b-it.gguf"

    private let fileManager: FileManager
    private let environment: [String: String]
    private let documentsDirectory: URL?

    init(
        fileManager: FileManager = .default,
        environment: [String: String] = ProcessInfo.processInfo.environment,
        documentsDirectory: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    ) {
        self.fileManager = fileManager
        self.environment = environment
        self.documentsDirectory = documentsDirectory
    }

    var resolvedModelURL: URL? {
        if let override = environment["PREXUS_LOCAL_MODEL_PATH"], !override.isEmpty {
            let url = URL(fileURLWithPath: override)
            return fileManager.fileExists(atPath: url.path) ? url : nil
        }

        if let bundled = Bundle.main.url(forResource: "prexus-local-mvp", withExtension: "gguf") {
            return bundled
        }

        guard let documentsDirectory else { return nil }

        let documentsCandidate = documentsDirectory
            .appendingPathComponent("Models", isDirectory: true)
            .appendingPathComponent(Self.defaultModelFileName)

        if fileManager.fileExists(atPath: documentsCandidate.path) {
            return documentsCandidate
        }

        let evaluationCandidate = documentsDirectory
            .appendingPathComponent("Models", isDirectory: true)
            .appendingPathComponent(Self.evaluationGemmaModelFileName)

        if fileManager.fileExists(atPath: evaluationCandidate.path) {
            return evaluationCandidate
        }

        return nil
    }

    var isModelAvailable: Bool {
        resolvedModelURL != nil
    }
}
