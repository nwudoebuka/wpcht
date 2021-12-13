//
//  LoginResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/20/21.
//

import Foundation

struct LoginResponse: Codable {
    var corporate: Bool
    var roles : [String]
    var privilege: [String]
    var pinCreated: Bool
    var user : LoginUser
    var token : String
    
    enum CodingKeys: String, CodingKey {
        case corporate, roles, pinCreated, privilege, user, token
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        corporate = try values.decode(Bool.self, forKey: .corporate)
        roles = try values.decode([String].self, forKey: .roles)
        pinCreated = try values.decode(Bool.self, forKey: .pinCreated)
        privilege = try values.decode([String].self, forKey: .privilege)
        user = try values.decode(LoginUser.self, forKey: .user)
        token = try values.decode(String.self, forKey: .token)
    }
}

struct LoginUser: Codable {
    var id: Int
    var email: String
    var phoneNumber: String
    var isActive: Bool
}

struct LoginHistoryResponse : Codable{
        let id: Int
        let ip, device, city, province: String
        let country: String
        let user: UserHistory
        let loginDate: String
}

struct UserHistory: Codable {
    let id: Int
    let email, phoneNumber, referenceCode, firstName: String
    let surname: String
    let pinCreated: Bool
    var roles : [String]?
    let dateCreated: String
    let corporate: Bool
}


struct UserValidResponse: Codable {
    var id: String
    var email: String //"mark.boleigha@wayapaychat.com",
    var phoneNumber: String // "2348059664630",
    var referenceCode: String //"",
    var firstName: String //"Boleigha",
    var surname: String // "Mark",
    var phoneVerified: Bool // false,
    var emailVerified: Bool //false,
    var pinCreated: Bool //true,
    var roles: [String] //["ROLE_USER","ROLE_CORP"],
    var corporate: Bool //true
}
