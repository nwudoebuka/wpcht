//
//  AuthServiceTest.swift
//  Waya PayChat 2.0Tests
//
//  Created by Nwudo Anthony Chukwuebuka on 1/31/21.
//
@testable import Waya_PayChat_2_0
import XCTest


class AuthServiceTest: XCTestCase {

    var authViewModel : AuthViewModelImpl!
    var request: NetworkService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        authViewModel = AuthViewModelImpl()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
      authViewModel = nil
    }

    func test_is_valid_Login() {
        let loginReq = LoginRequest(admin: false, email: "mark.boleigha@wayapaychat.com", password: "Xolikore19!")
        let dataExpectation = expectation(description: "Login endpoint returns valid data")

    }
    
    func test_user_logged_in() throws {
        
    }

}
