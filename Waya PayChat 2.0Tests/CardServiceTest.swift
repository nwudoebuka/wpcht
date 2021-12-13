//
//  CardServiceTest.swift
//  Waya PayChat 2.0Tests
//
//  Created by Nwudo Anthony Chukwuebuka on 2/23/21.
//
@testable import Waya_PayChat_2_0
import XCTest

class CardServiceTest : XCTestCase {
    
    var cardViewModel : WalletViewModelImpl!
    var request: Request!
    
    override func setUp() {
        
        continueAfterFailure = false
        cardViewModel = WalletViewModelImpl()
        request = Request.shared
        request.service = MockNetworkHandler()
    }
    
    override func tearDown() {
        cardViewModel = nil
        request = nil
        super.tearDown()
    }
    
    func test_add_valid_card() {
//        let month = Calendar.current.component(.month, from: date)
        
        
        let expectation = XCTestExpectation(description: "Valid card test")
        let cardRequest: [String:String] = [
            "name" : "John Smith",
            "cardNumber" : "5060666666666666",
            "expiryMonth" : "09",
            "expiryYear" : "22",
            "cvv" : "123",
            "email" : "test@example.com",
            "walletAccountId" : "xcdsse2",
            "userId" : "23",
            "pin" : "1234",
            "last4digit" : "6666",
        ]
        guard let data = try? cardRequest.customCodableObject(type: AddCardRequest.self) else {
            return
        }
        
        let network = NetworkRequest(endpoint: .addCard, method: .post, encoding: .json, body: data.dictionary!)
        request.fetch(network) { (status, _ response: MockResponse<AddCardResponse, AddCardResponse>?) in
            switch status {
            case .success:
                XCTAssertNotNil(response?.correct, "Correct response should not be nil")
                XCTAssertNotNil(response?.incorrect, "Incorrect response should not be nil")
                guard let correct = response?.correct, let incorrect = response?.incorrect else {
                    expectation.fulfill()
                    return
                }
//                XCTAssertTrue(correct.status, "Card response should be true")
////                XCTAssertEqual(response?.co, <#T##expression2: Equatable##Equatable#>)
//                response?.correct
                expectation.fulfill()
            case .failed(let error):
                expectation.fulfill()
            default:
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 3.0)
        
//        request.fetch(data, )
    }
    
    func test_addBankAccountReq_initSuccessfully() throws{
        XCTAssert(cardViewModel.addBankAccountReq.accountName == "")
    }
    
    func test_addBankRequest_isEmptyOnInit() throws{
        XCTAssertEqual(cardViewModel.addBankRequests.count, 0)
    }
    
}
