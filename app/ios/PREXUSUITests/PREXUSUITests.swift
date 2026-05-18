import XCTest

final class PREXUSUITests: XCTestCase {
    private enum UIID {
        static let chatScreen = "chat.screen"
        static let openSettings = "chat.open-settings"
        static let settingsScreen = "settings.screen"
        static let openDiagnostics = "settings.open-diagnostics"
        static let diagnosticsScreen = "diagnostics.screen"
        static let openMemory = "settings.open-memory"
        static let memoryScreen = "memory.screen"
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testRuntimeSurfacesCanBeCapturedViaNavigation() {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(element(UIID.chatScreen, in: app).waitForExistence(timeout: 5))
        attachScreenshot(named: "prexus-chat-iphone16")

        let openSettingsButton = app.buttons["Open Settings"]
        XCTAssertTrue(openSettingsButton.waitForExistence(timeout: 2))
        openSettingsButton.tap()

        XCTAssertTrue(element(UIID.settingsScreen, in: app).waitForExistence(timeout: 5))
        attachScreenshot(named: "prexus-settings-iphone16")

        app.swipeUp()

        let diagnosticsLink = labeledElement("Recent Runtime Decisions", in: app)
        XCTAssertTrue(diagnosticsLink.waitForExistence(timeout: 2))
        diagnosticsLink.tap()

        XCTAssertTrue(element(UIID.diagnosticsScreen, in: app).waitForExistence(timeout: 5))
        attachScreenshot(named: "prexus-diagnostics-iphone16")

        let backFromDiagnostics = app.navigationBars.buttons.element(boundBy: 0)
        XCTAssertTrue(backFromDiagnostics.waitForExistence(timeout: 2))
        backFromDiagnostics.tap()

        let memoryLink = labeledElement("Stored Episodes", in: app)
        XCTAssertTrue(memoryLink.waitForExistence(timeout: 2))
        memoryLink.tap()

        XCTAssertTrue(element(UIID.memoryScreen, in: app).waitForExistence(timeout: 5))
        attachScreenshot(named: "prexus-memory-iphone16")
    }

    private func element(_ identifier: String, in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)[identifier]
    }

    private func labeledElement(_ label: String, in app: XCUIApplication) -> XCUIElement {
        app.descendants(matching: .any)
            .matching(NSPredicate(format: "label == %@", label))
            .firstMatch
    }

    private func attachScreenshot(named name: String) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
