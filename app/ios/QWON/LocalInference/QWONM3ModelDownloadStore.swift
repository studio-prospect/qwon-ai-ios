import Foundation

#if QWON_M3_MODEL_DOWNLOAD_SPIKE

@MainActor
final class QWONM3ModelDownloadStore: ObservableObject {
    @Published private(set) var phase: QWONM3ModelDownloadPhase = .idle
    @Published var replaceExistingConfirmed = false

    private let downloader: QWONM3ModelDownloader
    private var activeTask: Task<Void, Never>?

    init(downloader: QWONM3ModelDownloader = QWONM3ModelDownloader()) {
        self.downloader = downloader
    }

    var requiresReplaceConfirmation: Bool {
        guard let existingBytes = downloader.existingFinalFileByteCount() else { return false }
        return existingBytes > 0 && !replaceExistingConfirmed
    }

    var canStartDownload: Bool {
        switch phase {
        case .downloading, .verifying, .promoting:
            return false
        default:
            return !requiresReplaceConfirmation
        }
    }

    func startDownload() {
        guard activeTask == nil else { return }

        activeTask = Task {
            do {
                try await performDownload()
            } catch is CancellationError {
                phase = .failed(message: QWONM3ModelDownloadError.cancelled.errorDescription ?? "Cancelled")
            } catch let error as QWONM3ModelDownloadError {
                phase = .failed(message: error.errorDescription ?? "Download failed")
            } catch {
                phase = .failed(message: error.localizedDescription)
            }
            activeTask = nil
        }
    }

    func cancelDownload() {
        activeTask?.cancel()
        activeTask = nil
        try? downloader.removeStaleTempFile()
        phase = .idle
    }

    func resetFailure() {
        guard case .failed = phase else { return }
        phase = .idle
    }

    private func performDownload() async throws {
        let replaceExisting = replaceExistingConfirmed
        phase = .downloading(receivedBytes: 0)

        try await downloader.download(replaceExisting: replaceExisting) { [weak self] nextPhase in
            Task { @MainActor in
                self?.phase = nextPhase
            }
        }

        replaceExistingConfirmed = false
    }
}

#endif
