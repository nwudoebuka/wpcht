//
//  BillPaymentFormUITests.swift
//  Waya PayChat 2.0UITests
//
//  Created by Nwudo Anthony Chukwuebuka on 1/14/21.
//

import XCTest

class BillPaymentFormUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_toShowSubcriptionTableView() throws {
        let app =  XCUIApplication()
        app.launch()
        
        let selectPaymentProviderButton = app.buttons["selectPaymentProviderButton"]
        selectPaymentProviderButton.tap()
        
        let subcriptionTableView = app.otherElements["BillPaymentSubcriptionTableView"]
        
        XCTAssertTrue(subcriptionTableView.exists)
    }

}
