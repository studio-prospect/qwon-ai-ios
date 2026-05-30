import Foundation

/// P1-4c-a: Fixed structured-output contracts for local backend JSON benchmarking.
enum StrictJSONEvalCategory: String, CaseIterable, Codable {
    case routingClassification
    case summarizationMetadata
    case memoryExtraction
}

struct StrictJSONEvalPrompt: Equatable {
    let id: String
    let category: StrictJSONEvalCategory
    let text: String
}

enum StrictJSONEvalPromptSet {
    static let frozenPrompts: [StrictJSONEvalPrompt] = [
        // routingClassification (4)
        StrictJSONEvalPrompt(
            id: "route_jp_summarize_email",
            category: .routingClassification,
            text: """
            Reply with compact JSON only. Keys: intent, confidence, needs_cloud.
            Allowed intent values: chat, summarize, memory_write, tool_request, cloud_needed.
            User: このメールを要約して
            """
        ),
        StrictJSONEvalPrompt(
            id: "route_en_tool_calendar",
            category: .routingClassification,
            text: """
            Reply with compact JSON only. Keys: intent, confidence, needs_cloud.
            Allowed intent values: chat, summarize, memory_write, tool_request, cloud_needed.
            User: Add tomorrow's meeting to my calendar and send a draft invite.
            """
        ),
        StrictJSONEvalPrompt(
            id: "route_jp_memory_note",
            category: .routingClassification,
            text: """
            Reply with compact JSON only. Keys: intent, confidence, needs_cloud.
            Allowed intent values: chat, summarize, memory_write, tool_request, cloud_needed.
            User: この会話を後で思い出せるようローカルメモに残して
            """
        ),
        StrictJSONEvalPrompt(
            id: "route_en_chat_smalltalk",
            category: .routingClassification,
            text: """
            Reply with compact JSON only. Keys: intent, confidence, needs_cloud.
            Allowed intent values: chat, summarize, memory_write, tool_request, cloud_needed.
            User: Hi, how are you today?
            """
        ),
        // summarizationMetadata (4)
        StrictJSONEvalPrompt(
            id: "sum_jp_meeting_notes",
            category: .summarizationMetadata,
            text: """
            Reply with compact JSON only. Keys: summary, todos, local_sufficient.
            todos must be a JSON array of strings.
            User: 会議メモ: 資料共有とレビュー依頼が未完了。締切は明日。
            """
        ),
        StrictJSONEvalPrompt(
            id: "sum_en_email_thread",
            category: .summarizationMetadata,
            text: """
            Reply with compact JSON only. Keys: summary, todos, local_sufficient.
            todos must be a JSON array of strings.
            User: Thread: client asked for pricing revision; legal review pending; ship Friday.
            """
        ),
        StrictJSONEvalPrompt(
            id: "sum_jp_agenda_three_items",
            category: .summarizationMetadata,
            text: """
            Reply with compact JSON only. Keys: summary, todos, local_sufficient.
            todos must be a JSON array of strings.
            User: 明日の予定: 朝は移動、午後はレビュー、夜はメール返信。
            """
        ),
        StrictJSONEvalPrompt(
            id: "sum_en_multi_turn_compress",
            category: .summarizationMetadata,
            text: """
            Reply with compact JSON only. Keys: summary, todos, local_sufficient.
            todos must be a JSON array of strings.
            User: Summarize for routing. User: extract TODOs only. Assistant: OK. User: deadline tomorrow.
            """
        ),
        // memoryExtraction (4)
        StrictJSONEvalPrompt(
            id: "mem_jp_local_only",
            category: .memoryExtraction,
            text: """
            Reply with compact JSON only. Keys: should_write_memory, memory_summary, sensitivity.
            Allowed sensitivity values: localOnly, localPreferred, escalationAllowed, providerRestricted.
            User: この内容は端末内だけで覚えて。会議は水曜15時、場所は本社。
            """
        ),
        StrictJSONEvalPrompt(
            id: "mem_en_escalation_ok",
            category: .memoryExtraction,
            text: """
            Reply with compact JSON only. Keys: should_write_memory, memory_summary, sensitivity.
            Allowed sensitivity values: localOnly, localPreferred, escalationAllowed, providerRestricted.
            User: Remember that I may ask cloud help later to polish this draft summary.
            """
        ),
        StrictJSONEvalPrompt(
            id: "mem_jp_provider_restricted",
            category: .memoryExtraction,
            text: """
            Reply with compact JSON only. Keys: should_write_memory, memory_summary, sensitivity.
            Allowed sensitivity values: localOnly, localPreferred, escalationAllowed, providerRestricted.
            User: 承認済みプロバイダだけ使う前提で、連絡先メモを残して。
            """
        ),
        StrictJSONEvalPrompt(
            id: "mem_en_skip_memory",
            category: .memoryExtraction,
            text: """
            Reply with compact JSON only. Keys: should_write_memory, memory_summary, sensitivity.
            Allowed sensitivity values: localOnly, localPreferred, escalationAllowed, providerRestricted.
            User: Do not store anything; just answer whether rain is expected tomorrow.
            """
        )
    ]
}

struct StrictJSONEvalScore: Equatable {
    let hadMarkdownFence: Bool
    let strictParsePass: Bool
    let requiredKeysPass: Bool
    let enumValidityPass: Bool
    let parseError: String?

    var strictPass: Bool {
        strictParsePass && requiredKeysPass && enumValidityPass
    }
}

private struct RoutingClassificationPayload: Decodable {
    let intent: String
    let confidence: Double
    let needs_cloud: Bool
}

private struct SummarizationMetadataPayload: Decodable {
    let summary: String
    let todos: [String]
    let local_sufficient: Bool
}

private struct MemoryExtractionPayload: Decodable {
    let should_write_memory: Bool
    let memory_summary: String
    let sensitivity: String
}

enum StrictJSONEvalScorer {
    static func score(response: String, category: StrictJSONEvalCategory) -> StrictJSONEvalScore {
        let trimmed = response.trimmingCharacters(in: .whitespacesAndNewlines)
        let fenceExtraction = extractJSONPayload(from: trimmed)
        guard let data = fenceExtraction.jsonData else {
            return StrictJSONEvalScore(
                hadMarkdownFence: fenceExtraction.hadMarkdownFence,
                strictParsePass: false,
                requiredKeysPass: false,
                enumValidityPass: false,
                parseError: fenceExtraction.parseError ?? "empty_payload"
            )
        }

        switch decodeStrictPayload(data: data, category: category) {
        case .success(let enumValid):
            return StrictJSONEvalScore(
                hadMarkdownFence: fenceExtraction.hadMarkdownFence,
                strictParsePass: true,
                requiredKeysPass: true,
                enumValidityPass: enumValid,
                parseError: nil
            )
        case .failure(let error):
            return StrictJSONEvalScore(
                hadMarkdownFence: fenceExtraction.hadMarkdownFence,
                strictParsePass: false,
                requiredKeysPass: false,
                enumValidityPass: false,
                parseError: error
            )
        }
    }

    private enum DecodeOutcome {
        case success(Bool)
        case failure(String)
    }

    private static func decodeStrictPayload(
        data: Data,
        category: StrictJSONEvalCategory
    ) -> DecodeOutcome {
        let decoder = JSONDecoder()
        do {
            switch category {
            case .routingClassification:
                let payload = try decoder.decode(RoutingClassificationPayload.self, from: data)
                guard payload.confidence >= 0, payload.confidence <= 1 else {
                    return .failure("confidence_out_of_range")
                }
                let allowedIntents: Set<String> = [
                    "chat", "summarize", "memory_write", "tool_request", "cloud_needed"
                ]
                return .success(allowedIntents.contains(payload.intent))
            case .summarizationMetadata:
                let payload = try decoder.decode(SummarizationMetadataPayload.self, from: data)
                guard !payload.summary.isEmpty else {
                    return .failure("empty_summary")
                }
                return .success(true)
            case .memoryExtraction:
                let payload = try decoder.decode(MemoryExtractionPayload.self, from: data)
                guard !payload.memory_summary.isEmpty else {
                    return .failure("empty_memory_summary")
                }
                let allowedSensitivity: Set<String> = [
                    "localOnly", "localPreferred", "escalationAllowed", "providerRestricted"
                ]
                return .success(allowedSensitivity.contains(payload.sensitivity))
            }
        } catch {
            return .failure("json_decode_error")
        }
    }

    private struct PayloadExtraction {
        let jsonData: Data?
        let hadMarkdownFence: Bool
        let parseError: String?
    }

    private static func extractJSONPayload(from text: String) -> PayloadExtraction {
        let hadFence = text.contains("```")
        var candidate = text

        if let fenceStart = text.range(of: "```") {
            let afterFence = text[fenceStart.upperBound...]
            if let languageBreak = afterFence.firstIndex(of: "\n") {
                candidate = String(afterFence[languageBreak...])
            } else {
                candidate = String(afterFence)
            }
            if let fenceEnd = candidate.range(of: "```") {
                candidate = String(candidate[..<fenceEnd.lowerBound])
            }
        }

        guard let start = candidate.firstIndex(of: "{"),
              let end = candidate.lastIndex(of: "}") else {
            return PayloadExtraction(jsonData: nil, hadMarkdownFence: hadFence, parseError: "no_json_object")
        }

        let jsonSlice = String(candidate[start...end])
        if containsSemicolonSeparators(jsonSlice) {
            return PayloadExtraction(
                jsonData: nil,
                hadMarkdownFence: hadFence,
                parseError: "semicolon_separator"
            )
        }

        return PayloadExtraction(
            jsonData: jsonSlice.data(using: .utf8),
            hadMarkdownFence: hadFence,
            parseError: nil
        )
    }

    private static func containsSemicolonSeparators(_ json: String) -> Bool {
        json.range(
            of: #";(\s*")|;\s*}|;\s*]"#,
            options: .regularExpression
        ) != nil
    }

}
