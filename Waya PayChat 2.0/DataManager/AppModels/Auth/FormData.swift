//
//  FormData.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 18/05/2021.
//

import Foundation

struct CorporateSignup: Codable {
    
    var admin: Bool = false
    var wayaAdmin: Bool = false
    var businessType:  String
    var email: String
    var firstName: String
    var gender: String = "MALE"
    var officeAddress: String
    var orgEmail: String
    var orgName: String
    var orgPhone: String
    var orgType:    String
    var password: String
    var phoneNumber: String
    var referenceCode: String = ""
    var city: String
    var state: String
    var surname: String
    
    enum CodingKeys: String, CodingKey {
        case admin, businessType, city, email, firstName, gender, officeAddress,
            orgEmail, orgName, orgPhone, orgType, password, phoneNumber, referenceCode, state, surname, wayaAdmin
    }
}

struct PersonalSignup: Codable {
    
    var admin: Bool = false
    var wayaAdmin: Bool = false
    var email: String
    var firstName: String
    var gender: String = "MALE"
    var password: String
    var phoneNumber: String
    var referenceCode: String
    var surname: String
    
    enum CodingKeys: String, CodingKey {
        case admin, wayaAdmin, email, firstName, gender, password, phoneNumber, referenceCode, surname
    }
}
