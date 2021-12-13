//
//  UpdatePersonalProfileRequest.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/2/21.
//

import Foundation

struct UpdatePersonalProfileRequest: Codable {
    var address : String
    var dateOfBirth : String
    var district: String
    var email: String
    var firstName: String
    var gender : String
    var middleName : String
    var phoneNumber: String
    var surname: String
    
    enum CodingKeys: String, CodingKey {
        case address, dateOfBirth, district, email, firstName, gender, middleName, phoneNumber, surname
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        address = try values.decode(String.self, forKey: .address)
        dateOfBirth = try values.decode(String.self, forKey: .dateOfBirth)
        district = try values.decode(String.self, forKey: .district)
        email = try values.decode(String.self, forKey: .email)
        firstName = try values.decode(String.self, forKey: .firstName)
        gender = try values.decode(String.self, forKey: .gender)
        middleName = try values.decode(String.self, forKey: .middleName)
        phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
        surname = try values.decode(String.self, forKey: .surname)
    }
}

struct UpdateCorporateProfileRequest: Codable {
    var address: String
    var businessType: String
    var city: String
    var dateOfBirth: String
    var district: String
    var email: String
    var firstName: String
    var gender: String
    var middleName: String
    var officeAddress: String
    var organisationEmail: String
    var organisationName: String
    var organisationType: String
    var phoneNumber: String
    var state: String
    var surname: String
    
    enum CodingKeys: String, CodingKey {
        case address, businessType, city, dateOfBirth, district, email, firstName, gender, middleName, officeAddress, organisationEmail, organisationName, organisationType, phoneNumber, state, surname
    }
}

