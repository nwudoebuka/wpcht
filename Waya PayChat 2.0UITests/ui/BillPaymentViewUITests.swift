//
//  PaymentFormUITests.swift
//  Waya PayChat 2.0UITests
//
//  Created by Nwudo Anthony Chukwuebuka on 1/14/21.
//

import XCTest
import SwiftUI

class BillPaymentViewUITests: XCTestCase{
      
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
       
    }
    
    func test_toSubscriptionTableView_whenSelectPaymentProviderButton(){
        let app =  XCUIApplication()
        app.launch()
        
        let selectPaymentProviderButton = app.buttons["selectPaymentProviderButton"]
        
        XCTAssert(selectPaymentProviderButton.exists)
        selectPaymentProviderButton.tap()
        
       // let subcriptionTableView = app.views["BillPaymentSubcriptionTableView"]
        
      //  XCTAssertTrue(subcriptionTableView.exists)
        
    }
}
