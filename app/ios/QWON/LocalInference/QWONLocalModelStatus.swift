import Foundation

enum QWONLocalModelFileSource: Equatable {
    case documentsDefault
    case documentsEvaluation
    case bundledResource
    case environmentOverride
}

enum QWONLocalModelPlacementState: Equatable {
    case missing
    case presentUnverified(source: QWONLocalModelFileSource, byteCount: Int64)
    case emptyFile(source: QWONLocalModelFileSource)
}

struct QWONLocalModelStatus: Equatable {
    static let expectedFileName = LocalGGUFModelPlacement.defaultModelFileName
    static let expectedRelativePlacement = "Documents/Models/\(expectedFileName)"

    let placementState: QWONLocalModelPlacementState
    let chipTier: LocalInferenceChipTier
    let machineIdentifier: String
    let isSimulator: Bool
    let resolvedFileName: String?
    let expectedPathPresent: Bool
    let manifestVerified: Bool
}

struct QWONLocalModelStatusInspector {
    typealias MachineIdentifierProvider = () -> String
    typealias SimulatorFlagProvider = () -> Bool

    private let fileManager: FileManager
    private let environment: [String: String]
    private let documentsDirectory: URL?
    private let machineIdentifierProvider: MachineIdentifierProvider
    private let isSimulatorProvider: SimulatorFlagProvider

    init(
        fileManager: FileManager = .default,
        environment: [String: String] = ProcessInfo.processInfo.environment,
        documentsDirectory: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
        machineIdentifierProvider: @escaping MachineIdentifierProvider = { LocalInferenceDeviceGate.machineIdentifier() },
        isSimulatorProvider: @escaping SimulatorFlagProvider = {
            #if targetEnvironment(simulator)
            true
            #else
            false
            #endif
        }
    ) {
        self.fileManager = fileManager
        self.environment = environment
        self.documentsDirectory = documentsDirectory
        self.machineIdentifierProvider = machineIdentifierProvider
        self.isSimulatorProvider = isSimulatorProvider
    }

    func inspect() -> QWONLocalModelStatus {
        let machineIdentifier = machineIdentifierProvider()
        let resolved = resolvedFileLocation()
        let expectedPathPresent = expectedDefaultModelURL.map { fileManager.fileExists(atPath: $0.path) } ?? false

        let placementState: QWONLocalModelPlacementState
        if let resolved {
            let byteCount = fileByteCount(at: resolved.url)
            if byteCount == 0 {
                placementState = .emptyFile(source: resolved.source)
            } else {
                placementState = .presentUnverified(source: resolved.source, byteCount: byteCount)
            }
        } else {
            placementState = .missing
        }

        #if QWON_M3_MODEL_DOWNLOAD_SPIKE
        let manifestVerified = manifestVerified(
            placementState: placementState,
            resolvedURL: resolved?.url,
            expectedDefaultModelURL: expectedDefaultModelURL
        )
        #else
        let manifestVerified = false
        #endif

        return QWONLocalModelStatus(
            placementState: placementState,
            chipTier: LocalInferenceDeviceGate.chipTier(machineIdentifier: machineIdentifier),
            machineIdentifier: machineIdentifier,
            isSimulator: isSimulatorProvider(),
            resolvedFileName: resolved?.url.lastPathComponent,
            expectedPathPresent: expectedPathPresent,
            manifestVerified: manifestVerified
        )
    }

    #if QWON_M3_MODEL_DOWNLOAD_SPIKE
    private func manifestVerified(
        placementState: QWONLocalModelPlacementState,
        resolvedURL: URL?,
        expectedDefaultModelURL: URL?
    ) -> Bool {
        guard case let .presentUnverified(_, byteCount) = placementState else { return false }
        guard let resolvedURL, let expectedDefaultModelURL else { return false }
        guard resolvedURL.path == expectedDefaultModelURL.path else { return false }
        guard byteCount == QWONM3ModelDownloadManifest.expectedByteSize else { return false }
        return QWONM3ModelVerificationMarker.matchesManifestVerified(
            fileURL: resolvedURL,
            fileManager: fileManager
        )
    }
    #endif

    static func current() -> QWONLocalModelStatus {
        QWONLocalModelStatusInspector().inspect()
    }

    private var expectedDefaultModelURL: URL? {
        documentsDirectory?
            .appendingPathComponent("Models", isDirectory: true)
            .appendingPathComponent(Self.expectedDefaultModelFileName)
    }

    private static var expectedDefaultModelFileName: String {
        LocalGGUFModelPlacement.defaultModelFileName
    }

    private func resolvedFileLocation() -> (url: URL, source: QWONLocalModelFileSource)? {
        if let override = environment["PREXUS_LOCAL_MODEL_PATH"], !override.isEmpty {
            let url = URL(fileURLWithPath: override)
            guard fileManager.fileExists(atPath: url.path) else { return nil }
            return (url, .environmentOverride)
        }

        if let bundled = Bundle.main.url(forResource: "prexus-local-mvp", withExtension: "gguf") {
            return (bundled, .bundledResource)
        }

        guard let documentsDirectory else { return nil }

        let defaultCandidate = documentsDirectory
            .appendingPathComponent("Models", isDirectory: true)
            .appendingPathComponent(LocalGGUFModelPlacement.defaultModelFileName)

        if fileManager.fileExists(atPath: defaultCandidate.path) {
            return (defaultCandidate, .documentsDefault)
        }

        let evaluationCandidate = documentsDirectory
            .appendingPathComponent("Models", isDirectory: true)
            .appendingPathComponent(LocalGGUFModelPlacement.evaluationGemmaModelFileName)

        if fileManager.fileExists(atPath: evaluationCandidate.path) {
            return (evaluationCandidate, .documentsEvaluation)
        }

        return nil
    }

    private func fileByteCount(at url: URL) -> Int64 {
        let attributes = try? fileManager.attributesOfItem(atPath: url.path)
        return (attributes?[.size] as? NSNumber)?.int64Value ?? 0
    }
}

enum QWONLocalModelStatusPresentation {
    static func statusChipLabel(for status: QWONLocalModelStatus) -> String {
        if status.isSimulator {
            return "Simulator"
        }

        #if QWON_M3_MODEL_DOWNLOAD_SPIKE
        if status.manifestVerified {
            return "Verified"
        }
        #endif

        switch status.placementState {
        case .missing:
            return "Missing"
        case .emptyFile:
            return "Empty file"
        case .presentUnverified:
            return "Present (unverified)"
        }
    }

    static func statusChipTint(for status: QWONLocalModelStatus) -> QWONModelStatusChipTint {
        if status.isSimulator {
            return .secondary
        }

        switch status.placementState {
        case .missing:
            return .orange
        case .emptyFile:
            return .orange
        case .presentUnverified:
            #if QWON_M3_MODEL_DOWNLOAD_SPIKE
            return status.manifestVerified ? .blue : .green
            #else
            return .green
            #endif
        }
    }

    static func tierChipLabel(for status: QWONLocalModelStatus) -> String {
        if status.isSimulator {
            return "Simulator"
        }

        switch status.chipTier {
        case .a17ProOrNewer:
            return "Wang-class (A17 Pro+)"
        case .unsupported:
            return "Matisse-class (A12)"
        }
    }

    static func expectedRuntimeLabel(for status: QWONLocalModelStatus) -> String {
        if status.isSimulator {
            return "Simulator Mock Runtime"
        }

        switch status.chipTier {
        case .unsupported:
            return "Embedded Heuristic Runtime"
        case .a17ProOrNewer:
            switch status.placementState {
            #if QWON_M3_MODEL_DOWNLOAD_SPIKE
            case .presentUnverified where status.manifestVerified:
                return "llama.cpp On-Device Runtime (verified)"
            #endif
            case .presentUnverified where status.resolvedFileName == QWONLocalModelStatus.expectedFileName:
                return "llama.cpp On-Device Runtime"
            case .presentUnverified:
                return "llama.cpp On-Device Runtime (alternate file)"
            case .missing, .emptyFile:
                return "Embedded Heuristic fallback"
            }
        }
    }

    static func summaryDetail(for status: QWONLocalModelStatus) -> String {
        QWONUILabelCopy.ModelStatus.summaryDetail(for: status)
    }

    static func diagnosticsMappingDetail(for status: QWONLocalModelStatus) -> String {
        QWONUILabelCopy.ModelStatus.diagnosticsMappingDetail(for: status)
    }
}

enum QWONModelStatusChipTint: Equatable {
    case green
    case orange
    case blue
    case secondary
}
