import SwiftUI

struct RootView: View {
    @ObservedObject var environment: AppEnvironment
    @State private var isPresentingSettings = false

    var body: some View {
        NavigationStack {
            ChatView(viewModel: ChatViewModel(environment: environment))
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            isPresentingSettings = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
        }
        .sheet(isPresented: $isPresentingSettings) {
            SettingsView(
                settings: environment.settings,
                memoryLibrary: environment.memoryLibrary
            )
        }
    }
}
