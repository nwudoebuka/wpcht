//
//  UserProfile.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/2/21.
//

import Foundation

struct UserProfile: Codable {
    var email: String // ->
    var phoneNumber: String // ->
    var firstName: String // ->
    var lastName: String? // ->
    var surname: String?
    var referenceCode: String? // ->
    var pinCreated: Bool // ->
    var gender: String? // ->
    var middleName: String? // ->
    var dateOfBirth: String? // ->
    var profileImage: String?
    var district: String? // ->
    var address: String? // ->
    var city: String?
    var state: String?
    var roles: [String]
    var permits: [String]
    var active: Bool // -> isActive on login
    var admin: Bool // -> isAdmin on login
    var corporate: Bool
    var phoneVerified: Bool // ->
    var emailVerified: Bool // ->
    var accountDeleted: Bool // ->
    var accountExpired: Bool
    var credentialsExpired: Bool // ->
    var accountLocked: Bool // ->
    var links: [UserLink]
    var userId: Int
    var username: String?
    var referalCode: String? = ""
    var smsAlertConfig: Bool?
    var otherDetails: OtherDetailsResponse?
    var profileId: String?
    var profileImageLocal: String?
    var accountType: AccountType {
        return (self.corporate == true) ? .corporate : .personal
    }
    
    var isCompleted: Bool {
        return (profileImage != nil && gender != nil && district != nil && state != nil && city != nil && address != nil)
    }
}

struct ProfileResponse: Codable {
    var id: String //"c16d1b09-7ec9-49f1-9161-090ba753f826",
    var referenceCode: String //"00wjao6XMpOhVEHW",
    var dateOfBirth: String?
    var gender: String?
    var city: String?
    var smsAlertConfig: Bool //false,
    var otherDetails: OtherDetailsResponse?
    var profileImage: String?
    var surname: String?
    
    enum CodingKeys: String, CodingKey {
        case id, referenceCode, dateOfBirth, gender, smsAlertConfig, otherDetails, city, profileImage, surname
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        dateOfBirth = try values.decodeIfPresent(String.self, forKey: .dateOfBirth)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        referenceCode = try values.decode(String.self, forKey: .referenceCode)
        smsAlertConfig = try values.decode(Bool.self, forKey: .smsAlertConfig)
        otherDetails = try values.decodeIfPresent(OtherDetailsResponse.self, forKey: .otherDetails)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        profileImage = try values.decodeIfPresent(String.self, forKey: .profileImage)
        surname = try values.decodeIfPresent(String.self, forKey: .surname)
    }
}

struct UserLink: Codable {
    var rel: String
    var href: String
}

struct OtherDetailsResponse: Codable {
    var businessType: String
    var organisationName: String
    var organisationType: String
}

struct ReferralCodeResponse : Codable{
    let referralCode: String
}

struct FollowResponse : Codable{
    let count: Int
    let following: [WayagramProfileResponse]
}
