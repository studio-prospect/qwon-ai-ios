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

        do {
            let object = try JSONSerialization.jsonObject(with: data)
            guard let dictionary = object as? [String: Any] else {
                return StrictJSONEvalScore(
                    hadMarkdownFence: fenceExtraction.hadMarkdownFence,
                    strictParsePass: false,
                    requiredKeysPass: false,
                    enumValidityPass: false,
                    parseError: "root_not_object"
                )
            }

            let requiredKeysPass = hasRequiredKeys(dictionary, category: category)
            let enumValidityPass = requiredKeysPass && validatesEnums(dictionary, category: category)
            return StrictJSONEvalScore(
                hadMarkdownFence: fenceExtraction.hadMarkdownFence,
                strictParsePass: true,
                requiredKeysPass: requiredKeysPass,
                enumValidityPass: enumValidityPass,
                parseError: nil
            )
        } catch {
            return StrictJSONEvalScore(
                hadMarkdownFence: fenceExtraction.hadMarkdownFence,
                strictParsePass: false,
                requiredKeysPass: false,
                enumValidityPass: false,
                parseError: "json_parse_error"
            )
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

    private static func hasRequiredKeys(_ object: [String: Any], category: StrictJSONEvalCategory) -> Bool {
        switch category {
        case .routingClassification:
            return object.keys.contains("intent")
                && object.keys.contains("confidence")
                && object.keys.contains("needs_cloud")
        case .summarizationMetadata:
            return object.keys.contains("summary")
                && object.keys.contains("todos")
                && object.keys.contains("local_sufficient")
        case .memoryExtraction:
            return object.keys.contains("should_write_memory")
                && object.keys.contains("memory_summary")
                && object.keys.contains("sensitivity")
        }
    }

    private static func validatesEnums(_ object: [String: Any], category: StrictJSONEvalCategory) -> Bool {
        switch category {
        case .routingClassification:
            guard let intent = object["intent"] as? String,
                  let confidence = parseConfidence(object["confidence"]),
                  let needsCloud = parseBool(object["needs_cloud"]) else {
                return false
            }
            let allowedIntents: Set<String> = [
                "chat", "summarize", "memory_write", "tool_request", "cloud_needed"
            ]
            return allowedIntents.contains(intent)
                && confidence >= 0 && confidence <= 1
                && needsCloud != nil
        case .summarizationMetadata:
            guard let summary = object["summary"] as? String,
                  !summary.isEmpty,
                  let todos = object["todos"] as? [Any],
                  parseBool(object["local_sufficient"]) != nil else {
                return false
            }
            return todos.allSatisfy { $0 is String }
        case .memoryExtraction:
            guard parseBool(object["should_write_memory"]) != nil,
                  let summary = object["memory_summary"] as? String,
                  !summary.isEmpty,
                  let sensitivity = object["sensitivity"] as? String else {
                return false
            }
            let allowedSensitivity: Set<String> = [
                "localOnly", "localPreferred", "escalationAllowed", "providerRestricted"
            ]
            return allowedSensitivity.contains(sensitivity)
        }
    }

    private static func parseConfidence(_ value: Any?) -> Double? {
        if let number = value as? NSNumber {
            return number.doubleValue
        }
        if let string = value as? String, let parsed = Double(string) {
            return parsed
        }
        return nil
    }

    private static func parseBool(_ value: Any?) -> Bool? {
        if let bool = value as? Bool {
            return bool
        }
        if let number = value as? NSNumber {
            return number.boolValue
        }
        if let string = value as? String {
            switch string.lowercased() {
            case "true", "1", "yes":
                return true
            case "false", "0", "no":
                return false
            default:
                return nil
            }
        }
        return nil
    }
}
