import Foundation

#if canImport(Darwin)
import Darwin
#endif

enum LocalInferenceChipTier: Equatable {
    case unsupported
    case a17ProOrNewer
}

struct LocalInferenceDeviceGate {
    typealias MachineIdentifierProvider = () -> String

    private static let supportedExactIdentifiers: Set<String> = [
        "iPhone16,1", // iPhone 15 Pro
        "iPhone16,2"  // iPhone 15 Pro Max
    ]

    static func machineIdentifier(provider: MachineIdentifierProvider = currentMachineIdentifier) -> String {
        provider()
    }

    static func chipTier(machineIdentifier: String) -> LocalInferenceChipTier {
        if supportedExactIdentifiers.contains(machineIdentifier) {
            return .a17ProOrNewer
        }

        if machineIdentifier.hasPrefix("iPhone17,") || machineIdentifier.hasPrefix("iPhone18,") {
            return .a17ProOrNewer
        }

        return .unsupported
    }

    static func supportsOnDeviceLlamaCpp(machineIdentifier: String) -> Bool {
        chipTier(machineIdentifier: machineIdentifier) == .a17ProOrNewer
    }

    #if targetEnvironment(simulator)
    static var supportsOnDeviceLlamaCppForCurrentPlatform: Bool {
        false
    }
    #else
    static var supportsOnDeviceLlamaCppForCurrentPlatform: Bool {
        supportsOnDeviceLlamaCpp(machineIdentifier: machineIdentifier())
    }
    #endif

    private static func currentMachineIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)

        return withUnsafePointer(to: &systemInfo.machine) { pointer in
            pointer.withMemoryRebound(to: CChar.self, capacity: 1) { charPointer in
                String(cString: charPointer)
            }
        }
    }
}
