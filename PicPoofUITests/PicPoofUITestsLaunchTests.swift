//
//  PicPoofUITestsLaunchTests.swift
//  PicPoofUITests
//  991 694 498
//  991 683 351
//  Anya Popova
//  Aleks Bursac
//  PROG31975
//  Created by Aleks Bursac on 2024-11-21.
//

import XCTest

final class PicPoofUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
