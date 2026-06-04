import SwiftUI

enum QWONAccessibilityID {
    enum Chat {
        static let screen = "chat.screen"
        static let openSettings = "chat.open-settings"
        static let routePreview = "chat.route-preview"
        static let composer = "chat.composer"
        static let onboardingHint = "chat.onboarding-hint"
    }

    enum Settings {
        static let screen = "settings.screen"
        static let done = "settings.done"
        static let openDiagnostics = "settings.open-diagnostics"
        static let openMemory = "settings.open-memory"
        static let summarySurface = "settings.summary-surface"
        static let modelStatus = "settings.model-status"
        static let openGuidedPlacement = "settings.open-guided-placement"
        static let guidedPlacementScreen = "settings.guided-placement"
        static let guidedPlacementStep = "settings.guided-placement.step"
        static let guidedPlacementCopy = "settings.guided-placement.copy"
    }

    enum Diagnostics {
        static let screen = "diagnostics.screen"
        static let clear = "diagnostics.clear"
        static let summary = "diagnostics.summary"
        static let empty = "diagnostics.empty"
        static let modelStatus = "diagnostics.model-status"
    }

    enum Memory {
        static let screen = "memory.screen"
        static let clearAll = "memory.clear-all"
        static let summary = "memory.summary"
        static let empty = "memory.empty"
    }
}

struct RootView: View {
    @ObservedObject var environment: AppEnvironment
    @State private var isPresentingSettings = false

    var body: some View {
        NavigationStack {
            ChatView(
                viewModel: makeChatViewModel(),
                onOpenSettings: {
                    isPresentingSettings = true
                }
            )
            .toolbar(.hidden, for: .navigationBar)
            .onAppear {
                LocalLlamaModelPrewarm.startIfNeeded()
            }
        }
        .sheet(isPresented: $isPresentingSettings) {
            SettingsView(
                settings: environment.settings,
                memoryLibrary: environment.memoryLibrary,
                runtimeDiagnostics: environment.runtimeDiagnostics
            )
        }
    }

    private func makeChatViewModel() -> ChatViewModel {
        if environment.launchScenario == .seededRuntimeSurfaces {
            return ChatViewModel.seededRuntimeSurfaces(environment: environment)
        }

        return ChatViewModel(environment: environment)
    }
}
