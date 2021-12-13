//
//  OtpRequest.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/27/21.
//

import Foundation

struct VerifyOtpRequest : Codable{
    var otp : String
    var phoneOrEmail: String
}

struct VerifyEmailRequest: Codable{
    var phoneOrEmail: String
    var otp: String
}
