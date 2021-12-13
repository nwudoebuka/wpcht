//
//  AddCardRequest.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/5/21.
//

import Foundation

struct AddCardRequest : Codable{
    
    var cardNumber : String
    var cvv :  String
    var email : String
    var expiryMonth : String
    var expiryYear : String
    var last4digit: String
    var name : String
    var userId : String
    var pin : String
    var accountNo: String
    
    enum CodingKeys: String, CodingKey {
        case cardNumber, cvv, email, expiryMonth, expiryYear, last4digit, name, userId, pin, accountNo
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        cardNumber = try values.decode(String.self, forKey: .cardNumber)
        cvv = try values.decode(String.self, forKey: .cvv)
        email = try values.decode(String.self, forKey: .email)
        expiryMonth = try values.decode(String.self, forKey: .expiryMonth)
        expiryYear = try values.decode(String.self, forKey: .expiryYear)
        last4digit = try values.decode(String.self, forKey: .last4digit)
        name = try values.decode(String.self, forKey: .name)
        userId = try values.decode(String.self, forKey: .userId)
        pin = try values.decode(String.self, forKey: .pin)
        accountNo = try values.decode(String.self, forKey: .accountNo)
    }
}

struct ChargeCardRequest : Codable{
    let ref: String = UUID().uuidString
    let userId: String
    let cardNumber : String
    let amount : String
    let walletAccountNo: String
}

struct SubmitPhoneRequest: Codable {
    var phone: String
    var reference: String
    var userId: String
}
