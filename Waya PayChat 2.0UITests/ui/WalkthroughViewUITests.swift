//
//  WalkthroughViewUITests.swift
//  Waya PayChat 2.0UITests
//
//  Created by Toju on 05/11/2020.
//

import SwiftUI
import XCTest
@testable import Waya_PayChat_2_0

class when_user_click_the_next_swipe: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        app.launch()
    }
    

    func test_to_increment_the_index() {
        
        let walkthroughbtnButton = XCUIApplication().buttons["walkThroughBtn"]
        walkthroughbtnButton.tap()
        walkthroughbtnButton.tap()
        walkthroughbtnButton.tap()

        XCTAssert(app.buttons["getStarted"].exists)
    }

//    func test_whenSkipIsTapped_then_showLandingPage() throws {
//        let view  = try XCTUnwrap(makeController())
//    
//     //   XCTAssertEqual(sut?.activeView, .walkthrough)
//    }


//    func test_whenSkipIsTapped_LandingPageIsShown() throws{
//        makeWalkthroughView()
//    }
////    
//    private func makeWalkthroughView() -> WalkthroughView {
//        let activeView : Binding<ActiveView> = .constant(.walkthrough)
//        let controller = WalkthroughView(activeView: activeView)
//        return controller
//    }
    
    
}
