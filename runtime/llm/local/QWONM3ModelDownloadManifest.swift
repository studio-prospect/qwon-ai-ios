import Foundation

/// Signed-off M3 development artifact contract (Gate 2 / spike plan).
enum QWONM3ModelDownloadManifest {
    static let hostedObjectIdentity =
        "s3://qwon-094469122222-ap-northeast-1-an/models/qwen2.5-0.5b-instruct/q4_k_m/prexus-local-mvp.gguf"

    static let developmentDownloadURL = URL(
        string: "https://models.qwon.dev/models/qwen2.5-0.5b-instruct/q4_k_m/prexus-local-mvp.gguf"
    )!

    static let expectedByteSize: Int64 = 397_808_192
    static let expectedSHA256Hex = "6eb923e7d26e9cea28811e1a8e852009b21242fb157b26149d3b188f3a8c8653"
    static let minimumFreeBytes: Int64 = 1_064_051_840

    static let finalFileName = LocalGGUFModelPlacement.defaultModelFileName
    static let tempFileName = "prexus-local-mvp.gguf.download"

    static func modelsDirectoryURL(in documentsDirectory: URL) -> URL {
        documentsDirectory.appendingPathComponent("Models", isDirectory: true)
    }

    static func tempFileURL(in documentsDirectory: URL) -> URL {
        documentsDirectory.appendingPathComponent(tempFileName)
    }

    static func finalFileURL(in documentsDirectory: URL) -> URL {
        modelsDirectoryURL(in: documentsDirectory).appendingPathComponent(finalFileName)
    }
}
