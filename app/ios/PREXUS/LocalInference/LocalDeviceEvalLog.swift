import Foundation

#if DEBUG && !targetEnvironment(simulator)
enum LocalDeviceEvalLog {
    private static let fileName = "prexus-device-eval.log"

    static func append(_ message: String) {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return
        }

        let logURL = documentsDirectory.appendingPathComponent(fileName)
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let line = "[\(timestamp)] \(message)\n"

        if FileManager.default.fileExists(atPath: logURL.path),
           let handle = try? FileHandle(forWritingTo: logURL) {
            defer { try? handle.close() }
            try? handle.seekToEnd()
            if let data = line.data(using: .utf8) {
                try? handle.write(contentsOf: data)
            }
        } else {
            try? line.write(to: logURL, atomically: true, encoding: .utf8)
        }

        print("[PREXUS][device-eval-log] \(message)")
    }
}
#endif
