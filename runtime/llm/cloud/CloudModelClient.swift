import Foundation

enum CloudProvider: String {
    case openAI
    case anthropic
    case gemini
}

enum CloudModelError: LocalizedError, Equatable {
    case invalidResponse
    case providerFailure(statusCode: Int, message: String)
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The cloud provider returned an invalid response."
        case let .providerFailure(statusCode, message):
            return "Cloud provider request failed with status \(statusCode): \(message)"
        case .emptyResponse:
            return "The cloud provider returned no text output."
        }
    }
}

protocol CloudModelClient {
    func generate(prompt: String, provider: CloudProvider, apiKey: String) async throws -> String
}

struct MockCloudModelClient: CloudModelClient {
    func generate(prompt: String, provider: CloudProvider, apiKey: String) async throws -> String {
        "\(provider.rawValue) handled the escalated request."
    }
}

struct DefaultCloudModelClient: CloudModelClient {
    let openAIClient: OpenAIResponsesClient
    let fallbackClient: MockCloudModelClient

    init(
        openAIClient: OpenAIResponsesClient,
        fallbackClient: MockCloudModelClient = MockCloudModelClient()
    ) {
        self.openAIClient = openAIClient
        self.fallbackClient = fallbackClient
    }

    func generate(prompt: String, provider: CloudProvider, apiKey: String) async throws -> String {
        switch provider {
        case .openAI:
            return try await openAIClient.generate(prompt: prompt, apiKey: apiKey)
        case .anthropic, .gemini:
            return try await fallbackClient.generate(prompt: prompt, provider: provider, apiKey: apiKey)
        }
    }
}

struct OpenAIResponsesClient {
    let transport: HTTPTransport
    let model: String
    let endpoint: URL
    let storeResponses: Bool
    let instructions: String

    init(
        transport: HTTPTransport,
        model: String,
        endpoint: URL = URL(string: "https://api.openai.com/v1/responses")!,
        storeResponses: Bool = false,
        instructions: String = "You are the cloud escalation layer for PREXUS. Respond concisely and use only the provided compressed context."
    ) {
        self.transport = transport
        self.model = model
        self.endpoint = endpoint
        self.storeResponses = storeResponses
        self.instructions = instructions
    }

    func generate(prompt: String, apiKey: String) async throws -> String {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(
            OpenAIResponsesRequest(
                model: model,
                input: prompt,
                instructions: instructions,
                store: storeResponses
            )
        )

        let (data, response) = try await transport.data(for: request)
        guard (200...299).contains(response.statusCode) else {
            let failure = try? JSONDecoder().decode(OpenAIResponsesFailure.self, from: data)
            let message = failure?.error.message ?? String(decoding: data, as: UTF8.self)
            throw CloudModelError.providerFailure(statusCode: response.statusCode, message: message)
        }

        let payload = try JSONDecoder().decode(OpenAIResponsesResponse.self, from: data)
        let text = payload.output
            .flatMap(\.content)
            .filter { $0.type == "output_text" }
            .compactMap(\.text)
            .joined()
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard !text.isEmpty else {
            throw CloudModelError.emptyResponse
        }

        return text
    }
}

private struct OpenAIResponsesRequest: Encodable {
    let model: String
    let input: String
    let instructions: String
    let store: Bool
}

private struct OpenAIResponsesResponse: Decodable {
    let output: [OpenAIOutputItem]
}

private struct OpenAIOutputItem: Decodable {
    let content: [OpenAIOutputContent]
}

private struct OpenAIOutputContent: Decodable {
    let type: String
    let text: String?
}

private struct OpenAIResponsesFailure: Decodable {
    let error: OpenAIProviderError
}

private struct OpenAIProviderError: Decodable {
    let message: String
}
