import Foundation

#if QWON_M3_MODEL_DOWNLOAD_SPIKE

enum QWONM3ModelVerificationMarker {
    private static let verifiedSHA256Key = "qwon.m3.verifiedModelSHA256"

    static func markVerified(expectedSHA256: String, defaults: UserDefaults = .standard) {
        defaults.set(expectedSHA256, forKey: verifiedSHA256Key)
    }

    static func isMarkedVerified(
        expectedSHA256: String = QWONM3ModelDownloadManifest.expectedSHA256Hex,
        defaults: UserDefaults = .standard
    ) -> Bool {
        defaults.string(forKey: verifiedSHA256Key) == expectedSHA256
    }

    static func clear(defaults: UserDefaults = .standard) {
        defaults.removeObject(forKey: verifiedSHA256Key)
    }
}

#endif
