import Foundation

/// Mac-side ops command strings for guided external GGUF placement (PR M2).
/// QWON does not run these commands — they are copy-to-clipboard helpers for internal testers.
enum QWONLocalModelGuidedPlacementCommands {
    static let fetchLocalModel = "./tools/scripts/fetch_local_model.sh"
    static let pushLocalModelTemplate = "./tools/scripts/push_local_model_to_device.sh \"DEVICE_NAME\""
    static let installOnDeviceTemplate = "./tools/scripts/install_on_device.sh \"DEVICE_NAME\""

    static func pushLocalModel(deviceName: String) -> String {
        "./tools/scripts/push_local_model_to_device.sh \"\(deviceName)\""
    }

    static func installOnDevice(deviceName: String) -> String {
        "./tools/scripts/install_on_device.sh \"\(deviceName)\""
    }
}
