//
//  CardResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/16/21.
//

import Foundation


enum AddCardDetour: String, Codable {
    case send_otp
    case send_phone
    case send_birthday
}

struct CardResponse : Codable {
    
    var authCode : String? 
    var cardNumber: String
    var last4digit: String
    var expiryMonth: String
    var expiryYear: String
    var type : String?
    var accountName:  String
    var userId : String
    var reference: String?
    var email: String?
    var walletFunded: Bool
    var walletAccountNumber: String?
    var orderNo: String?
    var providerType: String
   
}

struct AddCardResponse: Codable {
    var reference: String
    var display_text: String?
    var status: AddCardDetour
    
    enum CodingKeys: String, CodingKey {
        case reference, display_text, status
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        reference = try values.decode(String.self, forKey: .reference)
        display_text = try values.decodeIfPresent(String.self, forKey: .display_text)
        status = try values.decode(AddCardDetour.self, forKey: .status)
    }
}


struct VerifyCardRequest: Codable {
    var reference: String
    var otp: String
    var userId: String
}
