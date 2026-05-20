import Foundation

actor LocalModelGenerationCoordinator {
    private var activeTask: Task<String, Error>?

    func generate(
        prompt: String,
        operation: @escaping @Sendable (String) async throws -> String
    ) async throws -> String {
        activeTask?.cancel()

        let task = Task {
            try await operation(prompt)
        }

        activeTask = task

        do {
            return try await task.value
        } catch is CancellationError {
            throw LocalModelError.generationCancelled
        }
    }

    func cancelActiveGeneration() {
        activeTask?.cancel()
        activeTask = nil
    }
}
