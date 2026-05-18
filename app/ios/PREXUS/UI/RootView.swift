import SwiftUI

struct RootView: View {
    @ObservedObject var environment: AppEnvironment
    @State private var isPresentingSettings = false

    var body: some View {
        NavigationStack {
            ChatView(
                viewModel: ChatViewModel(environment: environment),
                onOpenSettings: {
                    isPresentingSettings = true
                }
            )
            .toolbar(.hidden, for: .navigationBar)
        }
        .sheet(isPresented: $isPresentingSettings) {
            SettingsView(
                settings: environment.settings,
                memoryLibrary: environment.memoryLibrary,
                runtimeDiagnostics: environment.runtimeDiagnostics
            )
        }
    }
}
