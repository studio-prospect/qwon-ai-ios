import Foundation

enum LocalModelError: Error, Equatable {
    case deviceNotSupported
    case modelAssetUnavailable
    case backendUnavailable(String)
    case generationCancelled
    case generationFailed(String)

    /// Stable code for runtime diagnostics (`primary_failure`, `fallback_reason`).
    var diagnosticCode: String {
        switch self {
        case .deviceNotSupported:
            return "device_not_supported"
        case .modelAssetUnavailable:
            return "model_asset_unavailable"
        case .backendUnavailable:
            return "backend_unavailable"
        case .generationCancelled:
            return "generation_cancelled"
        case .generationFailed:
            return "generation_failed"
        }
    }

    /// Human-readable detail appended to diagnostics when llama.cpp falls back.
    var diagnosticDescription: String {
        switch self {
        case .deviceNotSupported:
            return "device_not_supported: on-device llama.cpp requires A17 Pro-class hardware"
        case .modelAssetUnavailable:
            return "model_asset_unavailable: copy prexus-local-mvp.gguf to Documents/Models/ or set PREXUS_LOCAL_MODEL_PATH (see models/README.md)"
        case .backendUnavailable(let reason):
            return "backend_unavailable: \(reason)"
        case .generationCancelled:
            return "generation_cancelled"
        case .generationFailed(let reason):
            return "generation_failed: \(reason)"
        }
    }
}
