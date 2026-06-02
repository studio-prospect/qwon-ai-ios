import Foundation

#if DEBUG && !targetEnvironment(simulator)
/// One-shot alpha smoke: runs local-routed turns and writes evidence JSON to Documents.
enum LocalAlphaSmokeRunner {
    static let launchEnvironmentKey = "PREXUS_RUN_ALPHA_SMOKE"
    static let scenarioEnvironmentKey = "PREXUS_ALPHA_SMOKE_SCENARIO"

    private static func resultFileName(for scenario: String) -> String {
        "prexus-alpha-smoke-\(scenario).json"
    }

    struct SmokeResult: Encodable {
        let scenario: String
        let generatedAt: String
        let sensitivity: String?
        let routeTarget: String
        let routeReasonCodes: [String]
        let executionMode: String
        let executionModel: String?
        let executionDetail: String?
        let responsePrefix: String
        let error: String?
    }

    private struct SensitivityMatrixPayload: Encodable {
        let scenario: String
        let generatedAt: String
        let results: [SmokeResult]
    }

    @MainActor
    static func runIfRequested(environment: AppEnvironment) async {
        guard ProcessInfo.processInfo.environment[launchEnvironmentKey] == "1" else { return }

        let scenario = ProcessInfo.processInfo.environment[scenarioEnvironmentKey] ?? "with_model"
        switch scenario {
        case "sensitivity_matrix":
            await runSensitivityMatrix(environment: environment)
        default:
            await runSingleTurn(environment: environment, scenario: scenario)
        }
    }

    @MainActor
    private static func runSingleTurn(environment: AppEnvironment, scenario: String) async {
        let userText = "PREXUS alpha smoke: reply in one short sentence."
        let transcript = baseTranscript(userText: userText)

        do {
            let output = try await environment.runtime.runTurn(
                userText: userText,
                transcript: transcript
            )
            recordDiagnostics(environment: environment, output: output, userText: userText)
            write(
                SmokeResult(
                    scenario: scenario,
                    generatedAt: isoTimestamp(),
                    sensitivity: nil,
                    routeTarget: output.route.targetLabel,
                    routeReasonCodes: output.route.reasonCodes,
                    executionMode: output.execution.mode.rawValue,
                    executionModel: output.execution.model,
                    executionDetail: output.execution.detail,
                    responsePrefix: String(output.response.prefix(240)),
                    error: nil
                )
            )
        } catch {
            write(
                SmokeResult(
                    scenario: scenario,
                    generatedAt: isoTimestamp(),
                    sensitivity: nil,
                    routeTarget: "",
                    routeReasonCodes: [],
                    executionMode: "error",
                    executionModel: nil,
                    executionDetail: nil,
                    responsePrefix: "",
                    error: String(describing: error)
                )
            )
        }
    }

    @MainActor
    private static func runSensitivityMatrix(environment: AppEnvironment) async {
        let cases: [(SensitivityLevel, String)] = [
            (.localOnly, "Analyze this private note in one sentence."),
            (.localPreferred, "PREXUS alpha smoke: reply in one short sentence."),
            (.escalationAllowed, "Review this Swift code for a bug."),
            (.providerRestricted, "Extract text from this receipt with OCR.")
        ]

        var results: [SmokeResult] = []
        for (sensitivity, userText) in cases {
            let transcript = baseTranscript(userText: userText)
            do {
                let output = try await environment.runtime.runTurn(
                    input: .text(userText, sensitivity: sensitivity),
                    transcript: transcript
                )
                recordDiagnostics(environment: environment, output: output, userText: userText)
                results.append(
                    SmokeResult(
                        scenario: "sensitivity_matrix",
                        generatedAt: isoTimestamp(),
                        sensitivity: sensitivity.rawValue,
                        routeTarget: output.route.targetLabel,
                        routeReasonCodes: output.route.reasonCodes,
                        executionMode: output.execution.mode.rawValue,
                        executionModel: output.execution.model,
                        executionDetail: output.execution.detail,
                        responsePrefix: String(output.response.prefix(240)),
                        error: nil
                    )
                )
            } catch {
                results.append(
                    SmokeResult(
                        scenario: "sensitivity_matrix",
                        generatedAt: isoTimestamp(),
                        sensitivity: sensitivity.rawValue,
                        routeTarget: "",
                        routeReasonCodes: [],
                        executionMode: "error",
                        executionModel: nil,
                        executionDetail: nil,
                        responsePrefix: "",
                        error: String(describing: error)
                    )
                )
            }
        }

        writeMatrix(
            SensitivityMatrixPayload(
                scenario: "sensitivity_matrix",
                generatedAt: isoTimestamp(),
                results: results
            )
        )
    }

    @MainActor
    private static func recordDiagnostics(
        environment: AppEnvironment,
        output: RuntimeTurnOutput,
        userText: String
    ) {
        environment.runtimeDiagnostics.record(
            route: output.route,
            execution: output.execution,
            userText: userText
        )
    }

    private static func baseTranscript(userText: String) -> [ChatMessage] {
        [
            ChatMessage(role: .system, content: "QWON runtime initialized."),
            ChatMessage(role: .user, content: userText)
        ]
    }

    private static func isoTimestamp() -> String {
        ISO8601DateFormatter().string(from: Date())
    }

    private static func write(_ payload: SmokeResult) {
        guard let data = encode(payload),
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return
        }

        let url = documents.appendingPathComponent(resultFileName(for: payload.scenario))
        try? data.write(to: url, options: .atomic)
        if let json = String(data: data, encoding: .utf8) {
            print("[PREXUS][alpha-smoke]\n\(json)")
        }
    }

    private static func writeMatrix(_ payload: SensitivityMatrixPayload) {
        guard let data = encode(payload),
              let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            return
        }

        let url = documents.appendingPathComponent(resultFileName(for: payload.scenario))
        try? data.write(to: url, options: .atomic)
        if let json = String(data: data, encoding: .utf8) {
            print("[PREXUS][alpha-smoke]\n\(json)")
        }
    }

    private static func encode<T: Encodable>(_ payload: T) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return try? encoder.encode(payload)
    }
}
#else
enum LocalAlphaSmokeRunner {
    @MainActor
    static func runIfRequested(environment: AppEnvironment) async {}
}
#endif
