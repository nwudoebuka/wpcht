//
//  PasswordRequest.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 7/24/21.
//

import Foundation

struct ChangePasswordRequest : Codable{
    var newPassword, oldPassword, otp, phoneOrEmail: String
}

struct ResetPasswordRequest: Codable {
    var newPassword: String
    var otp: String
    var phoneOrEmail: String
}
