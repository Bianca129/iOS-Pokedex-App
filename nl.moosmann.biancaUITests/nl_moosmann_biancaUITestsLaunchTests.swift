//
//  nl_moosmann_biancaUITestsLaunchTests.swift
//  nl.moosmann.biancaUITests
//
//  Created by admin on 10/20/23.
//

import XCTest

final class nl_moosmann_biancaUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
