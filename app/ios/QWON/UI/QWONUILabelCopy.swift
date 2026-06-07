import Foundation

/// User-facing copy for QWON text-alpha onboarding (PR UI-1).
/// Runtime routing and backend strings stay in `runtime/` — labels and helper text only.
enum QWONUILabelCopy {
    enum Chat {
        static let headerSubtitle = "Local-first runtime · text alpha"
        static let sensitivityFootnote = "Sensitivity controls cloud escalation — not which on-device backend runs. See Settings for device path notes."
        /// UI-only onboarding copy — not injected into chat transcript or runtime prompts.
        static let onboardingHint = "QWON answers locally first when a model path is available. Wang expects llama.cpp On-Device Runtime; Matisse may use Embedded Heuristic Runtime — see Settings."
        static let fallbackStatusHelper = "Fallback may mean the local model file is unavailable, or Embedded Heuristic is the expected path on older hardware."
        static let composerPlaceholder = "Ask QWON"
    }

    enum Settings {
        static let introMessage = "Tune routing, cloud policy, and on-device inspection. Wang (A17 Pro+) expects llama.cpp On-Device Runtime when the local model is present; Matisse (A12) uses Embedded Heuristic Runtime as the expected local path."
        static let workspaceDetail = "Inspect how recent turns were routed and answered on device."
        static let workspaceFooter = "Diagnostics shows answered_by, primary_failure, and fallback_reason for each turn. Embedded Heuristic on Matisse is expected for this alpha tier — not a lab failure."
        static let diagnosticsNavSubtitle = "How each turn was answered — route, backend, and fallback fields."
        static let routingPolicyFooter = "Cloud escalation must be enabled before QWON can leave the local runtime. Provider Restricted keeps turns local unless an approved provider is configured. Providers without valid keys still run locally."
        static let localRuntimeFooter = "Automatic uses a simulator stub on Simulator. When prexus-local-mvp.gguf is present on capable hardware, expect llama.cpp On-Device Runtime. On older devices, Embedded Heuristic Runtime is the expected local path when no packaged model is available."
        static let providerRestrictedFooter = "These providers are the only cloud targets allowed when a turn uses Provider Restricted sensitivity. If none are approved, QWON keeps the turn local."
    }

    enum Diagnostics {
        static let introMessage = "See how each turn was routed and executed. answered_by names the backend; primary_failure explains a local model miss; fallback_reason notes why the heuristic path ran."
        static let summaryDetail = "Entries list route target, execution mode, and detail. On Wang with a local model, answered_by should read llama.cpp On-Device Runtime. On Matisse, Embedded Heuristic Runtime with Local runtime is the expected alpha path."
        static let emptyMessage = "After your first chat turn, this screen shows how QWON answered — including local model, heuristic fallback, or cloud escalation."
    }

    enum ModelStatus {
        static let cardTitle = "Local Model File"
        static let expectedPlacementLine = "Place prexus-local-mvp.gguf in Documents/Models/prexus-local-mvp.gguf."
        static let settingsFooter = "Model status is read-only in this alpha. Use Place GGUF via Mac for USB push steps. Check Runtime Diagnostics for answered_by, primary_failure, and fallback_reason after each turn."
        static let diagnosticsFooter = "Model file state here is read-only. Turn entries below show answered_by, primary_failure, and fallback_reason when a local fallback occurs."

        static func summaryDetail(for status: QWONLocalModelStatus) -> String {
            if status.isSimulator {
                return "Simulator uses a stub runtime — no GGUF proof required. \(expectedPlacementLine)"
            }

            switch status.chipTier {
            case .unsupported:
                return "Matisse-class devices use Embedded Heuristic Runtime as the expected local path for this alpha. A missing GGUF is not a failure. \(expectedPlacementLine)"
            case .a17ProOrNewer:
                switch status.placementState {
                case .missing:
                    return "Wang-class devices can use llama.cpp On-Device Runtime after the expected file is placed. Until then, Embedded Heuristic fallback runs without crashing. \(expectedPlacementLine)"
                case .emptyFile:
                    return "The resolved model file is empty and is treated as unusable. QWON falls back to Embedded Heuristic Runtime without crashing. Replace the file at the expected placement path."
                case .presentUnverified:
                    if status.resolvedFileName == QWONLocalModelStatus.expectedFileName {
                        return "Wang-class devices with the expected GGUF should use llama.cpp On-Device Runtime. Hash verification is not shown in this alpha — treat the file as present but unverified."
                    }
                    return "A GGUF file is present at an alternate resolved path. Wang-class devices attempt llama.cpp On-Device Runtime when load succeeds; otherwise Embedded Heuristic fallback runs without crashing."
                }
            }
        }

        static func diagnosticsMappingDetail(for status: QWONLocalModelStatus) -> String {
            if status.isSimulator {
                return "Simulator: answered_by may show Simulator Mock Runtime. No model_asset_unavailable proof is required here."
            }

            switch status.chipTier {
            case .unsupported:
                return "Matisse expected mapping: answered_by=Embedded Heuristic Runtime is normal on A12-class hardware for this alpha."
            case .a17ProOrNewer:
                switch status.placementState {
                #if QWON_M3_MODEL_DOWNLOAD_SPIKE
                case .presentUnverified where status.manifestVerified:
                    return "Wang mapping: verified local model — answered_by=llama.cpp On-Device Runtime when load succeeds."
                #endif
                case .presentUnverified where status.resolvedFileName == QWONLocalModelStatus.expectedFileName:
                    return "Wang mapping: answered_by=llama.cpp On-Device Runtime when load succeeds."
                case .missing, .emptyFile:
                    return "Wang missing/corrupt mapping: primary_failure=model_asset_unavailable and fallback_reason=embedded_heuristic are expected until a usable GGUF is placed."
                case .presentUnverified:
                    return "Wang alternate-file mapping: llama.cpp On-Device Runtime when load succeeds; otherwise primary_failure=model_asset_unavailable with embedded_heuristic fallback."
                }
            }
        }
    }

    enum GuidedPlacement {
        static let settingsNavSubtitle = "USB push steps from a Mac — QWON does not download the GGUF in-app."
        static let introMessage = "QWON cannot download or install the local model inside the app in this alpha. Internal testers copy Mac-side ops commands, push prexus-local-mvp.gguf over USB, then verify status here."
        static let stepsTitle = "Mac + USB placement steps"
        static let stepPrepareMacTitle = "Open the QWON repo on a Mac"
        static let stepPrepareMacDetail = "Release engineering or a developer with repo access runs the scripts below from the repository root. TestFlight builds still require external ops for the GGUF file."
        static let stepFetchModelTitle = "Fetch the GGUF on the Mac"
        static let stepFetchModelDetail = "Downloads models/prexus-local-mvp.gguf locally. This happens outside QWON on the Mac — not inside the iPhone app."
        static let stepConnectDeviceTitle = "Connect the iPhone via USB"
        static let stepConnectDeviceDetail = "Unlock the device, tap Trust This Computer, and keep Developer Mode enabled. Replace DEVICE_NAME in the push command with your device name (for example Wang)."
        static let stepPushModelTitle = "Push into Documents/Models"
        static let stepPushModelDetail = "Copies the file to Documents/Models/prexus-local-mvp.gguf in the QWON sandbox. QWON does not perform this transfer itself."
        static let stepVerifyTitle = "Verify in Settings and Diagnostics"
        static let stepVerifyDetail = "Return to Settings → Local Runtime. Wang-class devices should show Present (unverified) and expect llama.cpp On-Device Runtime. Matisse-class devices may stay on Embedded Heuristic Runtime — that is expected, not a failure."
        static let deviceExpectationsTitle = "Device expectations"
        static let wangExpectation = "Wang (A17 Pro+): after placement, expect llama.cpp On-Device Runtime when Chat runs locally. Missing or corrupt files fall back without crashing."
        static let matisseExpectation = "Matisse (A12): Embedded Heuristic Runtime is the expected alpha path. GGUF placement is optional and not required for pass."
        static let supportTitle = "Support note"
        static let supportDetail = "Do not tell testers to tap download in QWON — in-app download is not available. If placement fails, re-run the push command, confirm the filename prexus-local-mvp.gguf, and check Runtime Diagnostics."
        static let copyButtonTitle = "Copy"
        static let copiedButtonTitle = "Copied"
    }

    #if QWON_M3_MODEL_DOWNLOAD_SPIKE
    enum M3ModelDownload {
        static let sectionDetail = "Internal spike only — compile-gated download from QWON-hosted development endpoint."
        static let sectionFooter =
            "One-time optional model download (~400 MB). Network is used once for acquisition; chat stays local-first after install. Place GGUF via Mac remains available."
        static let downloadButtonTitle = "Download Local Model"
        static let cancelButtonTitle = "Cancel Download"
        static let replaceToggleTitle = "Replace existing USB-placed model file"
        static let replaceToggleDetail =
            "Required before download when prexus-local-mvp.gguf already exists. QWON will not silently overwrite an existing file."
        static let matisseDetail =
            "Matisse-class devices keep Embedded Heuristic Runtime as the expected path. Download entry is de-emphasized on this tier."
        static let verifiedDetail =
            "Local model matches the approved QWON-hosted byte size and SHA-256. llama.cpp On-Device Runtime is expected on Wang-class hardware."
        static let failedDetailPrefix = "Download or verification failed. Place GGUF via Mac remains available."

        static func progressDetail(for phase: QWONM3ModelDownloadPhase) -> String {
            switch phase {
            case .idle:
                return "Ready for a user-initiated foreground download."
            case let .downloading(receivedBytes):
                if receivedBytes > 0 {
                    let formatted = ByteCountFormatter.string(fromByteCount: receivedBytes, countStyle: .file)
                    return "Downloading… \(formatted) received."
                }
                return "Downloading model from QWON development endpoint…"
            case .verifying:
                return "Verifying byte size and SHA-256 before install."
            case .promoting:
                return "Installing verified model to Documents/Models."
            case .completed:
                return verifiedDetail
            case let .failed(message):
                return "\(failedDetailPrefix) \(message)"
            }
        }
    }
    #endif
}
