import Foundation

enum LocalModelBackend: String, Codable, CaseIterable {
    case automatic
    case simulatorMock
    case embeddedHeuristic
    case deviceRuntime

    var displayName: String {
        switch self {
        case .automatic:
            return "Automatic"
        case .simulatorMock:
            return "Simulator Mock"
        case .embeddedHeuristic:
            return "Embedded Heuristic"
        case .deviceRuntime:
            return "Device Runtime"
        }
    }
}

struct LocalModelDescriptor: Equatable {
    let backend: LocalModelBackend
    let name: String
    let summary: String
}

protocol LocalModelClient {
    var descriptor: LocalModelDescriptor { get }
    func generate(prompt: String) async throws -> String
}

struct SimulatorMockLocalModelClient: LocalModelClient {
    let descriptor = LocalModelDescriptor(
        backend: .simulatorMock,
        name: "Simulator Mock Runtime",
        summary: "Deterministic local stub used on Simulator."
    )

    func generate(prompt: String) async throws -> String {
        "Local simulator runtime handled the request with compressed context."
    }
}

struct EmbeddedHeuristicLocalModelClient: LocalModelClient {
    let descriptor = LocalModelDescriptor(
        backend: .embeddedHeuristic,
        name: "Embedded Heuristic Runtime",
        summary: "Local lightweight fallback path without a packaged LLM."
    )

    func generate(prompt: String) async throws -> String {
        let userLine = prompt
            .split(separator: "\n")
            .last(where: { $0.hasPrefix("User:") || !$0.isEmpty })?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? "your request"

        return "Embedded local runtime handled \(userLine.lowercased()) with compact on-device heuristics."
    }
}

struct MockLocalModelClient: LocalModelClient {
    let descriptor = LocalModelDescriptor(
        backend: .simulatorMock,
        name: "Mock Local Runtime",
        summary: "Test-only local runtime stub."
    )

    func generate(prompt: String) async throws -> String {
        "Local runtime handled the request with compressed context."
    }
}

enum LocalModelFactory {
    static func makeClient(preferred backend: LocalModelBackend) -> LocalModelClient {
        switch resolvedBackend(for: backend) {
        case .automatic:
            #if targetEnvironment(simulator)
            return SimulatorMockLocalModelClient()
            #else
            return EmbeddedHeuristicLocalModelClient()
            #endif
        case .simulatorMock:
            return SimulatorMockLocalModelClient()
        case .embeddedHeuristic:
            return EmbeddedHeuristicLocalModelClient()
        case .deviceRuntime:
            return EmbeddedHeuristicLocalModelClient()
        }
    }

    static func resolvedBackend(for backend: LocalModelBackend) -> LocalModelBackend {
        switch backend {
        case .automatic:
            #if targetEnvironment(simulator)
            return .simulatorMock
            #else
            return .deviceRuntime
            #endif
        case .simulatorMock, .embeddedHeuristic, .deviceRuntime:
            return backend
        }
    }
}
