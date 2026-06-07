import CryptoKit
import Foundation

#if QWON_M3_MODEL_DOWNLOAD_SPIKE

enum QWONM3ModelDownloadPhase: Equatable {
    case idle
    case downloading(receivedBytes: Int64)
    case verifying
    case promoting
    case completed
    case failed(message: String)
}

enum QWONM3ModelDownloadError: LocalizedError, Equatable {
    case existingModelRequiresConfirmation
    case insufficientSpace(required: Int64, available: Int64)
    case byteSizeMismatch(expected: Int64, actual: Int64)
    case hashMismatch
    case downloadFailed(String)
    case promoteFailed(String)
    case cancelled

    var errorDescription: String? {
        switch self {
        case .existingModelRequiresConfirmation:
            return "An existing local model file is present. Confirm replacement before downloading."
        case let .insufficientSpace(required, available):
            return "Not enough free space. Required \(required) bytes; available \(available) bytes."
        case let .byteSizeMismatch(expected, actual):
            return "Downloaded file size mismatch. Expected \(expected) bytes; got \(actual) bytes."
        case .hashMismatch:
            return "Downloaded file failed SHA-256 verification."
        case let .downloadFailed(message):
            return "Download failed: \(message)"
        case let .promoteFailed(message):
            return "Could not install verified model: \(message)"
        case .cancelled:
            return "Download cancelled."
        }
    }
}

struct QWONM3ModelDownloader {
    typealias ProgressHandler = @Sendable (QWONM3ModelDownloadPhase) -> Void

    let fileManager: FileManager
    let documentsDirectory: URL
    let downloadURL: URL
    let urlSession: URLSession

    init(
        fileManager: FileManager = .default,
        documentsDirectory: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
        downloadURL: URL = QWONM3ModelDownloadManifest.developmentDownloadURL,
        urlSession: URLSession = .shared
    ) {
        self.fileManager = fileManager
        self.documentsDirectory = documentsDirectory ?? URL(fileURLWithPath: NSTemporaryDirectory())
        self.downloadURL = downloadURL
        self.urlSession = urlSession
    }

    var tempFileURL: URL {
        QWONM3ModelDownloadManifest.tempFileURL(in: documentsDirectory)
    }

    var finalFileURL: URL {
        QWONM3ModelDownloadManifest.finalFileURL(in: documentsDirectory)
    }

    func existingFinalFileByteCount() -> Int64? {
        guard fileManager.fileExists(atPath: finalFileURL.path) else { return nil }
        return fileByteCount(at: finalFileURL)
    }

    func preflight(replaceExisting: Bool) throws {
        if let existingBytes = existingFinalFileByteCount(), existingBytes > 0, !replaceExisting {
            throw QWONM3ModelDownloadError.existingModelRequiresConfirmation
        }

        let available = try availableCapacityBytes()
        guard available >= QWONM3ModelDownloadManifest.minimumFreeBytes else {
            throw QWONM3ModelDownloadError.insufficientSpace(
                required: QWONM3ModelDownloadManifest.minimumFreeBytes,
                available: available
            )
        }
    }

    func removeStaleTempFile() throws {
        guard fileManager.fileExists(atPath: tempFileURL.path) else { return }
        try fileManager.removeItem(at: tempFileURL)
    }

    func verifyTempFile(at url: URL) throws {
        let actualSize = fileByteCount(at: url)
        guard actualSize == QWONM3ModelDownloadManifest.expectedByteSize else {
            throw QWONM3ModelDownloadError.byteSizeMismatch(
                expected: QWONM3ModelDownloadManifest.expectedByteSize,
                actual: actualSize
            )
        }

        let actualHash = try Self.sha256Hex(of: url, fileManager: fileManager)
        guard actualHash == QWONM3ModelDownloadManifest.expectedSHA256Hex else {
            throw QWONM3ModelDownloadError.hashMismatch
        }
    }

    func promoteVerifiedTempFile(replaceExisting: Bool) throws {
        try preflight(replaceExisting: replaceExisting)

        try fileManager.createDirectory(
            at: QWONM3ModelDownloadManifest.modelsDirectoryURL(in: documentsDirectory),
            withIntermediateDirectories: true
        )

        if fileManager.fileExists(atPath: finalFileURL.path) {
            try fileManager.removeItem(at: finalFileURL)
        }
        try fileManager.moveItem(at: tempFileURL, to: finalFileURL)

        QWONM3ModelVerificationMarker.markVerified(
            expectedSHA256: QWONM3ModelDownloadManifest.expectedSHA256Hex
        )
    }

    func download(
        replaceExisting: Bool,
        progress: ProgressHandler? = nil
    ) async throws {
        try preflight(replaceExisting: replaceExisting)
        try fileManager.createDirectory(
            at: QWONM3ModelDownloadManifest.modelsDirectoryURL(in: documentsDirectory),
            withIntermediateDirectories: true
        )

        progress?(.downloading(receivedBytes: 0))

        let (temporaryLocation, response): (URL, URLResponse)
        do {
            (temporaryLocation, response) = try await urlSession.download(from: downloadURL)
        } catch {
            if (error as? URLError)?.code == .cancelled {
                throw QWONM3ModelDownloadError.cancelled
            }
            throw QWONM3ModelDownloadError.downloadFailed(error.localizedDescription)
        }

        if let http = response as? HTTPURLResponse, !(200 ... 299).contains(http.statusCode) {
            throw QWONM3ModelDownloadError.downloadFailed("HTTP \(http.statusCode)")
        }

        defer { try? fileManager.removeItem(at: temporaryLocation) }

        if fileManager.fileExists(atPath: tempFileURL.path) {
            try fileManager.removeItem(at: tempFileURL)
        }
        try fileManager.copyItem(at: temporaryLocation, to: tempFileURL)

        progress?(.downloading(receivedBytes: fileByteCount(at: tempFileURL)))
        progress?(.verifying)

        do {
            try verifyTempFile(at: tempFileURL)
        } catch {
            try? fileManager.removeItem(at: tempFileURL)
            throw error
        }

        progress?(.promoting)
        do {
            try promoteVerifiedTempFile(replaceExisting: replaceExisting)
        } catch {
            try? fileManager.removeItem(at: tempFileURL)
            throw QWONM3ModelDownloadError.promoteFailed(error.localizedDescription)
        }

        progress?(.completed)
    }

    static func sha256Hex(of url: URL, fileManager: FileManager = .default) throws -> String {
        let handle = try FileHandle(forReadingFrom: url)
        defer { try? handle.close() }

        var hasher = SHA256()
        while true {
            let chunk = try autoreleasepool(invoking: { () throws -> Data in
                try handle.read(upToCount: 1_048_576) ?? Data()
            })
            if chunk.isEmpty { break }
            hasher.update(data: chunk)
        }

        return hasher.finalize().map { String(format: "%02x", $0) }.joined()
    }

    private func availableCapacityBytes() throws -> Int64 {
        let values = try documentsDirectory.resourceValues(
            forKeys: [.volumeAvailableCapacityForImportantUsageKey]
        )
        return Int64(values.volumeAvailableCapacityForImportantUsage ?? 0)
    }

    private func fileByteCount(at url: URL) -> Int64 {
        let attributes = try? fileManager.attributesOfItem(atPath: url.path)
        return (attributes?[.size] as? NSNumber)?.int64Value ?? 0
    }
}

#endif
