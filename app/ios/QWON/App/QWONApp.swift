import SwiftUI

@main
struct QWONApp: App {
    private let environment = AppEnvironment.bootstrap()

    var body: some Scene {
        WindowGroup {
            RootView(environment: environment)
                .background(Color(uiColor: .systemGroupedBackground))
                .task {
                    #if DEBUG && !targetEnvironment(simulator)
                    await LocalAlphaSmokeRunner.runIfRequested(environment: environment)
                    #endif
                    #if PREXUS_LITERT_LM_PROTOTYPE
                    await LocalStrictJSONBenchmarkRunner.runIfRequested()
                    await LocalBackendComparisonRunner.runIfRequested()
                    #endif
                }
        }
    }
}
