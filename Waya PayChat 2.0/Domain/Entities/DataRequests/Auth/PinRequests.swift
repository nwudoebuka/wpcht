//
//  PinRequests.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 08/07/2021.
//

import Foundation

struct CreateAccountPinRequest: Codable{
    let phoneOrEmail : String
    let pin: String // This has to be a string. trailing 0's are clipped in Int type
    let otp: String
    
    enum CodingKeys: String, CodingKey {
        case phoneOrEmail, pin, otp
    }
}

struct ChangePinRequest: Codable {
    var newPin: String // "string",
    var oldPin: String //"string",
    var otp: String //"string",
    var phoneOrEmail: String //"string"
    
    enum CodingKeys: String, CodingKey {
        case newPin, oldPin, otp, phoneOrEmail
    }
}

struct ResetPinRequest: Codable{
    let phoneOrEmail : String
    let pin: String // This has to be a string. trailing 0's are clipped in Int type
    let otp: String
    
    enum CodingKeys: String, CodingKey {
        case phoneOrEmail, pin, otp
    }
}
