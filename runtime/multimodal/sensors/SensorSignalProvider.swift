import Foundation

struct SensorSignal {
    let label: String
    let value: String
}

protocol SensorSignalProvider {
    func currentSignals() -> [SensorSignal]
}
