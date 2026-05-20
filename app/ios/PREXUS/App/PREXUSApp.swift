import SwiftUI

@main
struct PREXUSApp: App {
    private let environment = AppEnvironment.bootstrap()

    var body: some Scene {
        WindowGroup {
            RootView(environment: environment)
                .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}
