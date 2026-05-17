import SwiftUI

struct RootView: View {
    let environment: AppEnvironment

    var body: some View {
        NavigationStack {
            ChatView(viewModel: ChatViewModel(runtime: environment.runtime))
        }
    }
}
