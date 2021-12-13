//
//  CorporateProfileRequest.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/2/21.
//

import Foundation

struct CorporateProfileRequest: Codable {
    var businessType : String
    var firstName: String
    var organisationEmail: String
    var organisationName: String
    var organisationType : String
    var phoneNumber : String
    var referralCode : String
    var surname : String
    var userId : String    
}
