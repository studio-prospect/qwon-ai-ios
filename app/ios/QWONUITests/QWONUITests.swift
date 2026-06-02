import XCTest

final class QWONUITests: XCTestCase {
    private enum UIID {
        static let chatScreen = "chat.screen"
        static let openSettings = "chat.open-settings"
        static let settingsScreen = "settings.screen"
        static let diagnosticsScreen = "diagnostics.screen"
        static let diagnosticsSummary = "diagnostics.summary"
        static let memoryScreen = "memory.screen"
        static let memorySummary = "memory.summary"
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testRuntimeSurfacesCanBeCapturedViaNavigation() {
        let deviceSlug = currentDeviceSlug()
        let app = makeApp()
        app.launch()

        XCTAssertTrue(element(UIID.chatScreen, in: app).waitForExistence(timeout: 5))
        attachScreenshot(named: "prexus-chat-\(deviceSlug)")

        let openSettingsButton = app.buttons["Open Settings"]
        XCTAssertTrue(openSettingsButton.waitForExistence(timeout: 2))
        openSettingsButton.tap()

        XCTAssertTrue(element(UIID.settingsScreen, in: app).waitForExistence(timeout: 5))
        attachScreenshot(named: "prexus-settings-\(deviceSlug)")

        app.swipeUp()

        let diagnosticsLink = labeledElement("Recent Runtime Decisions", in: app)
        XCTAssertTrue(diagnosticsLink.waitForExistence(timeout: 2))
        diagnosticsLink.tap()

        XCTAssertTrue(element(UIID.diagnosticsScreen, in: app).waitForExistence(timeout: 5))
        attachScreenshot(named: "prexus-diagnostics-\(deviceSlug)")

        let backFromDiagnostics = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backFromDiagnostics.waitForExistence(timeout: 2))
        backFromDiagnostics.tap()

        let memoryLink = labeledElement("Stored Episodes", in: app)
        XCTAssertTrue(memoryLink.waitForExistence(timeout: 2))
        memoryLink.tap()

        XCTAssertTrue(element(UIID.memoryScreen, in: app).waitForExistence(timeout: 5))
        attachScreenshot(named: "prexus-memory-\(deviceSlug)")
    }

    func testSeededRuntimeSurfacesShowNonEmptyDiagnosticsAndMemory() {
        let deviceSlug = currentDeviceSlug()
        let app = makeApp(seedPopulatedRuntimeSurfaces: true)
        app.launch()

        XCTAssertTrue(element(UIID.chatScreen, in: app).waitForExistence(timeout: 5))
        attachScreenshot(named: "prexus-chat-seeded-\(deviceSlug)")

        let openSettingsButton = app.buttons["Open Settings"]
        XCTAssertTrue(openSettingsButton.waitForExistence(timeout: 2))
        openSettingsButton.tap()

        XCTAssertTrue(element(UIID.settingsScreen, in: app).waitForExistence(timeout: 5))
        attachScreenshot(named: "prexus-settings-seeded-\(deviceSlug)")
        app.swipeUp()

        let diagnosticsLink = labeledElement("Recent Runtime Decisions", in: app)
        XCTAssertTrue(diagnosticsLink.waitForExistence(timeout: 2))
        diagnosticsLink.tap()

        XCTAssertTrue(element(UIID.diagnosticsScreen, in: app).waitForExistence(timeout: 5))
        XCTAssertTrue(element(UIID.diagnosticsSummary, in: app).waitForExistence(timeout: 2))
        attachScreenshot(named: "prexus-diagnostics-seeded-\(deviceSlug)")

        let backFromDiagnostics = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backFromDiagnostics.waitForExistence(timeout: 2))
        backFromDiagnostics.tap()

        let memoryLink = labeledElement("Stored Episodes", in: app)
        XCTAssertTrue(memoryLink.waitForExistence(timeout: 2))
        memoryLink.tap()

        XCTAssertTrue(element(UIID.memoryScreen, in: app).waitForExistence(timeout: 5))
        XCTAssertTrue(element(UIID.memorySummary, in: app).waitForExistence(timeout: 2))
        attachScreenshot(named: "prexus-memory-seeded-\(deviceSlug)")
    }

    private func makeApp(seedPopulatedRuntimeSurfaces: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        if seedPopulatedRuntimeSurfaces {
            app.launchArguments.append("PREXUS_UI_TEST_SEEDED_SURFACES")
        }
        return app
    }

    private func element(_ identifier: String, in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)[identifier]
    }

    private func labeledElement(_ label: String, in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)
            .matching(NSPredicate(format: "label == %@", label))
            .firstMatch
    }

    private func currentDeviceSlug(processInfo: ProcessInfo = .processInfo) -> String {
        let deviceName = processInfo.environment["SIMULATOR_DEVICE_NAME"] ?? "simulator"
        switch deviceName {
        case "iPhone 16":
            return "iphone16"
        case "iPhone SE (3rd generation)":
            return "iphonese3"
        default:
            return deviceName
                .lowercased()
                .replacingOccurrences(of: "[^a-z0-9]+", with: "-", options: .regularExpression)
                .trimmingCharacters(in: CharacterSet(charactersIn: "-"))
        }
    }

    private func attachScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
