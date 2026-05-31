import Foundation

#if DEBUG && !targetEnvironment(simulator)
/// One-shot alpha smoke: runs a local-routed turn and writes evidence JSON to Documents.
enum LocalAlphaSmokeRunner {
    static let launchEnvironmentKey = "PREXUS_RUN_ALPHA_SMOKE"
    static let scenarioEnvironmentKey = "PREXUS_ALPHA_SMOKE_SCENARIO"
    private static func resultFileName(for scenario: String) -> String {
        "prexus-alpha-smoke-\(scenario).json"
    }

    private struct SmokeResult: Encodable {
        let scenario: String
        let generatedAt: String
        let routeTarget: String
        let executionMode: String
        let executionModel: String?
        let executionDetail: String?
        let responsePrefix: String
        let error: String?
    }

    @MainActor
    static func runIfRequested(environment: AppEnvironment) async {
        guard ProcessInfo.processInfo.environment[launchEnvironmentKey] == "1" else { return }

        let scenario = ProcessInfo.processInfo.environment[scenarioEnvironmentKey] ?? "with_model"
        let userText = "PREXUS alpha smoke: reply in one short sentence."
        let transcript = [
            ChatMessage(role: .system, content: "PREXUS runtime initialized."),
            ChatMessage(role: .user, content: userText)
        ]

        do {
            let output = try await environment.runtime.runTurn(
                userText: userText,
                transcript: transcript
            )
            environment.runtimeDiagnostics.record(
                route: output.route,
                execution: output.execution,
                userText: userText
            )

            let payload = SmokeResult(
                scenario: scenario,
                generatedAt: ISO8601DateFormatter().string(from: Date()),
                routeTarget: output.route.targetLabel,
                executionMode: output.execution.mode.rawValue,
                executionModel: output.execution.model,
                executionDetail: output.execution.detail,
                responsePrefix: String(output.response.prefix(240)),
                error: nil
            )
            write(payload)
        } catch {
            let payload = SmokeResult(
                scenario: scenario,
                generatedAt: ISO8601DateFormatter().string(from: Date()),
                routeTarget: "",
                executionMode: "error",
                executionModel: nil,
                executionDetail: nil,
                responsePrefix: "",
                error: String(describing: error)
            )
            write(payload)
        }
    }

    private static func write(_ payload: SmokeResult) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(payload),
              let json = String(data: data, encoding: .utf8),
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return
        }

        let url = documents.appendingPathComponent(resultFileName(for: payload.scenario))
        try? data.write(to: url, options: .atomic)
        print("[PREXUS][alpha-smoke]\n\(json)")
    }
}
#else
enum LocalAlphaSmokeRunner {
    @MainActor
    static func runIfRequested(environment: AppEnvironment) async {}
}
#endif
