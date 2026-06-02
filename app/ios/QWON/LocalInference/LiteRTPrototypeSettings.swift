import Foundation

/// Debug-only LiteRT-LM prototype gate (off by default; not a production setting).
enum LiteRTPrototypeSettings {
    static let enabledDefaultsKey = "prexus.debug.litertPrototypeEnabled"

    static var isUserEnabled: Bool {
        #if DEBUG
        UserDefaults.standard.bool(forKey: enabledDefaultsKey)
        #else
        false
        #endif
    }

    static func setUserEnabled(_ enabled: Bool) {
        #if DEBUG
        UserDefaults.standard.set(enabled, forKey: enabledDefaultsKey)
        #endif
    }

    #if PREXUS_LITERT_LM_PROTOTYPE && !targetEnvironment(simulator)
    /// Device + artifact gates for LiteRT (ignores debug toggle — used by backend comparison).
    static var meetsHardwareAndArtifactGates: Bool {
        LocalInferenceDeviceGate.supportsOnDeviceLlamaCppForCurrentPlatform
            && LiteRTModelPlacement.isModelAvailable
    }

    static var isRuntimeAvailable: Bool {
        isUserEnabled && meetsHardwareAndArtifactGates
    }
    #else
    static var meetsHardwareAndArtifactGates: Bool { false }
    static var isRuntimeAvailable: Bool { false }
    #endif
}
