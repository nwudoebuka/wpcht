//
//  BvnRequest.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/2/21.
//

import Foundation


struct LinkBvnRequest: Codable{
    
    var bvn : String
    var dob : String
    var firstName : String
    var lastName : String
    var userId: String
}

struct ValidateBVNRequest: Codable {
    var otp: String
    var user: String
}

struct IsBvnLinkRequest: Codable{
    var accountNumber : String
    var bvn : String
}
