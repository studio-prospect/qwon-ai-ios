import Foundation

#if QWON_M3_MODEL_DOWNLOAD_SPIKE

enum QWONM3ModelVerificationMarker {
    private static let verifiedRecordKey = "qwon.m3.verifiedModelRecord"

    struct VerifiedFileRecord: Codable, Equatable {
        let sha256Hex: String
        let byteCount: Int64
        let contentModificationTime: TimeInterval
    }

    static func markVerified(
        fileURL: URL,
        fileManager: FileManager = .default,
        defaults: UserDefaults = .standard
    ) throws {
        let record = try makeRecord(for: fileURL, fileManager: fileManager)
        guard record.sha256Hex == QWONM3ModelDownloadManifest.expectedSHA256Hex else {
            clear(defaults: defaults)
            throw QWONM3ModelDownloadError.hashMismatch
        }
        try store(record, defaults: defaults)
    }

    static func matchesManifestVerified(
        fileURL: URL,
        fileManager: FileManager = .default,
        defaults: UserDefaults = .standard
    ) -> Bool {
        let byteCount = fileByteCount(at: fileURL, fileManager: fileManager)
        guard byteCount == QWONM3ModelDownloadManifest.expectedByteSize else {
            clear(defaults: defaults)
            return false
        }

        guard let modificationTime = contentModificationTime(at: fileURL, fileManager: fileManager) else {
            clear(defaults: defaults)
            return false
        }

        if let stored = load(defaults: defaults),
           stored.byteCount == byteCount,
           stored.contentModificationTime == modificationTime,
           stored.sha256Hex == QWONM3ModelDownloadManifest.expectedSHA256Hex {
            return true
        }

        guard let sha256Hex = try? QWONM3ModelDownloader.sha256Hex(of: fileURL, fileManager: fileManager),
              sha256Hex == QWONM3ModelDownloadManifest.expectedSHA256Hex else {
            clear(defaults: defaults)
            return false
        }

        let record = VerifiedFileRecord(
            sha256Hex: sha256Hex,
            byteCount: byteCount,
            contentModificationTime: modificationTime
        )
        try? store(record, defaults: defaults)
        return true
    }

    static func clear(defaults: UserDefaults = .standard) {
        defaults.removeObject(forKey: verifiedRecordKey)
    }

    private static func makeRecord(for fileURL: URL, fileManager: FileManager) throws -> VerifiedFileRecord {
        guard let modificationTime = contentModificationTime(at: fileURL, fileManager: fileManager) else {
            throw QWONM3ModelDownloadError.promoteFailed("Missing file metadata for verification record.")
        }

        return VerifiedFileRecord(
            sha256Hex: try QWONM3ModelDownloader.sha256Hex(of: fileURL, fileManager: fileManager),
            byteCount: fileByteCount(at: fileURL, fileManager: fileManager),
            contentModificationTime: modificationTime
        )
    }

    private static func store(_ record: VerifiedFileRecord, defaults: UserDefaults) throws {
        let data = try JSONEncoder().encode(record)
        defaults.set(data, forKey: verifiedRecordKey)
    }

    private static func load(defaults: UserDefaults) -> VerifiedFileRecord? {
        guard let data = defaults.data(forKey: verifiedRecordKey) else { return nil }
        return try? JSONDecoder().decode(VerifiedFileRecord.self, from: data)
    }

    private static func fileByteCount(at url: URL, fileManager: FileManager) -> Int64 {
        let attributes = try? fileManager.attributesOfItem(atPath: url.path)
        return (attributes?[.size] as? NSNumber)?.int64Value ?? 0
    }

    private static func contentModificationTime(at url: URL, fileManager: FileManager) -> TimeInterval? {
        guard let values = try? url.resourceValues(forKeys: [.contentModificationDateKey]),
              let date = values.contentModificationDate else {
            return nil
        }
        return date.timeIntervalSince1970
    }
}

#endif
