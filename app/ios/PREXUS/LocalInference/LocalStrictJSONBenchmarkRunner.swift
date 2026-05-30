#if PREXUS_LITERT_LM_PROTOTYPE
import Foundation

/// P1-4c-a: Runs frozen structured-output prompts on Qwen and LiteRT; writes CSV + summary JSON.
enum LocalStrictJSONBenchmarkRunner {
    static let launchEnvironmentKey = "PREXUS_RUN_STRICT_JSON_BENCHMARK"
    private static let detailLogFileName = "prexus-strict-json-benchmark-detail.csv"
    private static let summaryLogFileName = "prexus-strict-json-benchmark-summary.json"

    struct Row: Equatable {
        let backend: String
        let promptID: String
        let category: String
        let status: String
        let totalMs: Double
        let coldLoadMs: String
        let firstTokenMs: String
        let strictPass: Bool
        let strictParsePass: Bool
        let requiredKeysPass: Bool
        let enumValidityPass: Bool
        let hadMarkdownFence: Bool
        let usedFallback: Bool
        let answeredBy: String
        let primaryFailure: String
        let parseError: String
        let responsePrefix: String
    }

    static func runIfRequested() async {
        guard ProcessInfo.processInfo.environment[launchEnvironmentKey] == "1" else { return }
        await run()
    }

    static func run() async {
        var rows: [Row] = []
        let qwenChain = AppLocalModelFactory.makeQwenFallbackChain()
        let qwenBackendName = "qwen_llama_cpp"
        let litertBackendName = "litert_lm_gemma4"
        let litertClientName = "LiteRT-LM Prototype Runtime"
        let qwenExpectedResponder = "llama.cpp On-Device Runtime"

        for prompt in StrictJSONEvalPromptSet.frozenPrompts {
            rows.append(
                await runPrompt(
                    prompt: prompt,
                    backend: qwenBackendName,
                    client: qwenChain,
                    expectedResponder: qwenExpectedResponder
                )
            )
        }

        if LiteRTPrototypeSettings.meetsHardwareAndArtifactGates {
            let litert = LiteRTLocalModelClient()
            for prompt in StrictJSONEvalPromptSet.frozenPrompts {
                rows.append(
                    await runPrompt(
                        prompt: prompt,
                        backend: litertBackendName,
                        client: litert,
                        expectedResponder: litertClientName
                    )
                )
            }
        }

        let detailCSV = makeDetailCSV(rows: rows)
        let summaryJSON = makeSummaryJSON(rows: rows, litertRan: LiteRTPrototypeSettings.meetsHardwareAndArtifactGates)
        writeLogs(detailCSV: detailCSV, summaryJSON: summaryJSON)
    }

    private static func runPrompt(
        prompt: StrictJSONEvalPrompt,
        backend: String,
        client: LocalModelClient,
        expectedResponder: String
    ) async -> Row {
        LocalModelExecutionTrace.reset()
        let start = CFAbsoluteTimeGetCurrent()
        do {
            let response = try await client.generate(prompt: prompt.text)
            let totalMs = (CFAbsoluteTimeGetCurrent() - start) * 1000.0
            let trace = LocalModelExecutionTrace.current
            let metrics = trace?.metricsDetail ?? ""
            let score = StrictJSONEvalScorer.score(response: response, category: prompt.category)
            return Row(
                backend: backend,
                promptID: prompt.id,
                category: prompt.category.rawValue,
                status: "ok",
                totalMs: totalMs,
                coldLoadMs: extractMetric(metrics, key: "cold_load_ms") ?? "",
                firstTokenMs: extractMetric(metrics, key: "first_token_ms") ?? "",
                strictPass: score.strictPass,
                strictParsePass: score.strictParsePass,
                requiredKeysPass: score.requiredKeysPass,
                enumValidityPass: score.enumValidityPass,
                hadMarkdownFence: score.hadMarkdownFence,
                usedFallback: trace?.primaryFailure != nil || trace?.respondingBackend != expectedResponder,
                answeredBy: trace?.respondingBackend ?? client.descriptor.name,
                primaryFailure: trace?.primaryFailure ?? "",
                parseError: score.parseError ?? "",
                responsePrefix: sanitizeField(String(response.prefix(160)))
            )
        } catch {
            let totalMs = (CFAbsoluteTimeGetCurrent() - start) * 1000.0
            let trace = LocalModelExecutionTrace.current
            return Row(
                backend: backend,
                promptID: prompt.id,
                category: prompt.category.rawValue,
                status: "failed",
                totalMs: totalMs,
                coldLoadMs: "",
                firstTokenMs: "",
                strictPass: false,
                strictParsePass: false,
                requiredKeysPass: false,
                enumValidityPass: false,
                hadMarkdownFence: false,
                usedFallback: true,
                answeredBy: trace?.respondingBackend ?? "",
                primaryFailure: trace?.primaryFailure ?? String(describing: error),
                parseError: "generation_failed",
                responsePrefix: sanitizeField(String(String(describing: error).prefix(160)))
            )
        }
    }

    private static func makeDetailCSV(rows: [Row]) -> String {
        var lines = [
            "backend,prompt_id,category,status,total_ms,cold_load_ms,first_token_ms,strict_pass,strict_parse_pass,required_keys_pass,enum_validity_pass,had_markdown_fence,used_fallback,answered_by,primary_failure,parse_error,response_prefix"
        ]
        for row in rows {
            let fields: [String] = [
                row.backend,
                row.promptID,
                row.category,
                row.status,
                String(format: "%.1f", row.totalMs),
                row.coldLoadMs,
                row.firstTokenMs,
                row.strictPass ? "1" : "0",
                row.strictParsePass ? "1" : "0",
                row.requiredKeysPass ? "1" : "0",
                row.enumValidityPass ? "1" : "0",
                row.hadMarkdownFence ? "1" : "0",
                row.usedFallback ? "1" : "0",
                row.answeredBy,
                row.primaryFailure,
                row.parseError,
                row.responsePrefix
            ]
            lines.append(fields.map(csvEscape).joined(separator: ","))
        }
        return lines.joined(separator: "\n")
    }

    private struct BackendSummary: Encodable {
        let backend: String
        let runs: Int
        let failures: Int
        let fallbackCount: Int
        let strictPassRate: Double
        let requiredKeysRate: Double
        let enumValidityRate: Double
        let markdownFenceRate: Double
        let medianTotalMs: Double
    }

    private struct BenchmarkSummary: Encodable {
        let generatedAt: String
        let device: String
        let promptCountPerBackend: Int
        let litertRan: Bool
        let backends: [BackendSummary]
        let byCategory: [String: [BackendSummary]]
    }

    private static func makeSummaryJSON(rows: [Row], litertRan: Bool) -> String {
        let backends = ["qwen_llama_cpp", "litert_lm_gemma4"].compactMap { backend -> BackendSummary? in
            let subset = rows.filter { $0.backend == backend }
            guard !subset.isEmpty else { return nil }
            return summarize(subset, backend: backend)
        }

        var byCategory: [String: [BackendSummary]] = [:]
        for category in StrictJSONEvalCategory.allCases.map(\.rawValue) {
            byCategory[category] = ["qwen_llama_cpp", "litert_lm_gemma4"].compactMap { backend in
                let subset = rows.filter { $0.backend == backend && $0.category == category }
                guard !subset.isEmpty else { return nil }
                return summarize(subset, backend: backend)
            }
        }

        let payload = BenchmarkSummary(
            generatedAt: ISO8601DateFormatter().string(from: Date()),
            device: "Wang",
            promptCountPerBackend: StrictJSONEvalPromptSet.frozenPrompts.count,
            litertRan: litertRan,
            backends: backends,
            byCategory: byCategory
        )

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(payload),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }

    private static func summarize(_ rows: [Row], backend: String) -> BackendSummary {
        let runs = rows.count
        let failures = rows.filter { $0.status == "failed" }.count
        let fallbackCount = rows.filter(\.usedFallback).count
        let strictPasses = rows.filter(\.strictPass).count
        let requiredPasses = rows.filter(\.requiredKeysPass).count
        let enumPasses = rows.filter(\.enumValidityPass).count
        let fenceCount = rows.filter(\.hadMarkdownFence).count
        let totals = rows.map(\.totalMs).sorted()
        let median = totals.isEmpty ? 0 : totals[totals.count / 2]
        return BackendSummary(
            backend: backend,
            runs: runs,
            failures: failures,
            fallbackCount: fallbackCount,
            strictPassRate: runs == 0 ? 0 : Double(strictPasses) / Double(runs),
            requiredKeysRate: runs == 0 ? 0 : Double(requiredPasses) / Double(runs),
            enumValidityRate: runs == 0 ? 0 : Double(enumPasses) / Double(runs),
            markdownFenceRate: runs == 0 ? 0 : Double(fenceCount) / Double(runs),
            medianTotalMs: median
        )
    }

    private static func extractMetric(_ detail: String, key: String) -> String? {
        guard let range = detail.range(of: "\(key)=") else { return nil }
        let tail = detail[range.upperBound...]
        return tail.split(separator: " ").first.map(String.init)
    }

    private static func sanitizeField(_ value: String) -> String {
        value.replacingOccurrences(of: "\n", with: " ")
    }

    private static func csvEscape(_ value: String) -> String {
        let needsQuotes = value.contains(",") || value.contains("\"") || value.contains("\n")
        guard needsQuotes else { return value }
        let escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(escaped)\""
    }

    private static func writeLogs(detailCSV: String, summaryJSON: String) {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return
        }

        let detailURL = documentsDirectory.appendingPathComponent(detailLogFileName)
        let summaryURL = documentsDirectory.appendingPathComponent(summaryLogFileName)
        try? detailCSV.write(to: detailURL, atomically: true, encoding: .utf8)
        try? summaryJSON.write(to: summaryURL, atomically: true, encoding: .utf8)
        print("[PREXUS][strict-json-benchmark]\n\(summaryJSON)")
    }
}
#endif
