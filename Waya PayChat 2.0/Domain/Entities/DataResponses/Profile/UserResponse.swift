//
//  UserResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/1/21.
//

import Foundation
//
//struct WayaUser: Codable{
//    var id: Int
//    var email: String
//    var isEmailVerified: Bool
//    var phoneNumber: String
//    var firstName: String
//    var lastName: String
//    var isAdmin: Bool?
//    var isPhoneVerified: Bool?
//    var isCredentialsExpired: Bool?
//    var isActive: Bool?
//    var isAccountDeleted: Bool?
//    var referenceCode: String?
//    var isCorporate: Bool?
//    var middleName: String?
//    var accountType: AccountType?
//    var roles: [String]?
//    var permits: [String]?
//    var defaultWallet: String?
//    var completedSetup: [RequiredSetup] = [RequiredSetup]()
//    var profileImage: String?
//    var profileImageLocal: String?
//    var profile: WayagramProfile?
//    
//    
//    var isAccountLocked: Bool? //false,
//    var isAccountExpired: Bool? //false,
//    var referalCode: String?
//    var virtualAccount: VirtualAccountsResponse?
//    var wallets: [UserWalletResponse]?
//    var bankAccounts: [BankResponse]?
//    var pinCreated: Bool?
//    var dateOfBirth: String
//    var gender: String
//    var links: [String]?
//    
//    enum CodingKeys: String, CodingKey {
//        case id, email, phoneNumber, firstName, middleName, lastName, accountType, roles, defaultWallet, isEmailVerified, completedSetup, profileImage, profileImageLocal, profile, prefs, isAdmin, isPhoneVerified, isAccountExpired, isActive, isCredentialsExpired, isAccountDeleted, referalCode,
//            virtualAccount, wallets, bankAccounts, pinCreated, dateOfBirth, gender, permits, links, referenceCode, isCorporate
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try! decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decode(Int.self, forKey: .id)
//        email = try values.decode(String.self, forKey: .email)
//        phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
//        firstName = try values.decode(String.self, forKey: .firstName)
//        middleName = try values.decodeIfPresent(String.self, forKey: .middleName)
//        lastName = try values.decode(String.self, forKey: .lastName)
//        accountType = try values.decodeIfPresent(AccountType.self, forKey: .accountType)
//        roles = try values.decodeIfPresent([String].self, forKey: .roles)
//        defaultWallet = try values.decodeIfPresent(String.self, forKey: .defaultWallet)
//        isEmailVerified = try values.decode(Bool.self, forKey: .isEmailVerified)
//        profileImage = try values.decodeIfPresent(String.self, forKey: .profileImage)
//        profileImageLocal = try values.decodeIfPresent(String.self, forKey: .profileImageLocal)
//        profile = try values.decodeIfPresent(WayagramProfile.self, forKey: .profile)
//        prefs = try values.decodeIfPresent(Prefs.self, forKey: .prefs)
//        isAdmin = try values.decodeIfPresent(Bool.self, forKey: .isAdmin)
//        isPhoneVerified = try values.decodeIfPresent(Bool.self, forKey: .isPhoneVerified)
//        isAccountExpired = try values.decodeIfPresent(Bool.self, forKey: .isAccountExpired)
//        isCredentialsExpired = try values.decodeIfPresent(Bool.self, forKey: .isCredentialsExpired)
//        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
//        isAccountDeleted = try values.decodeIfPresent(Bool.self, forKey: .isAccountDeleted)
//        referalCode = try values.decodeIfPresent(String.self, forKey: .referalCode)
//        virtualAccount = try values.decodeIfPresent(VirtualAccountsResponse.self, forKey: .virtualAccount)
//        wallets = try values.decodeIfPresent([UserWalletResponse].self, forKey: .wallets)
//        bankAccounts = try values.decodeIfPresent([BankResponse].self, forKey: .bankAccounts)
//        pinCreated = try values.decodeIfPresent(Bool.self, forKey: .pinCreated)
//        dateOfBirth = try values.decode(String.self, forKey: .dateOfBirth)
//        gender = try values.decode(String.self, forKey: .gender)
//        permits = try values.decodeIfPresent([String].self, forKey: .permits)
//        links = try values.decodeIfPresent([String].self, forKey: .links)
//        referenceCode = try values.decodeIfPresent(String.self, forKey: .referenceCode)
//        isCorporate = try values.decodeIfPresent(Bool.self, forKey: .isCorporate)
//        
//        if completedSetup.count == 0 {
//            (isPhoneVerified! == true) ? completedSetup.append(RequiredSetup.phoneVerify) : ()
//            (isEmailVerified == true) ? completedSetup.append(RequiredSetup.emailVerify) : ()
//        }
//    }
//}


struct WayagramProfile: Codable {
    var UserId: String //"131",
    var avatar: String? //null,
    var deleted: Bool //false,
    var coverImage: String? //null,
    var username: String //"mark.boleigha",
    var displayName: String? // null,
    var notPublic: Bool //false,
    var id: String //"18884fe5-be2f-45a8-a74a-936fe0c43c18",
    var bio: String? //null,
    var isMuted: Bool // false,
    var postCount: Int //0,
    var following: Int //0,
    var followers: Int //0
    
    enum CodingKeys: String, CodingKey {
        case UserId, avatar, deleted, coverImage, username, displayName, notPublic, id, bio, isMuted, postCount, following, followers
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        
        UserId = try values.decode(String.self, forKey: .UserId)
        avatar = try values.decodeIfPresent(String.self, forKey: .avatar)
        deleted = try values.decode(Bool.self, forKey: .deleted)
        coverImage = try values.decodeIfPresent(String.self, forKey: .coverImage)
        username = try values.decode(String.self, forKey: .username)
        displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
        notPublic = try values.decode(Bool.self, forKey: .notPublic)
        id = try values.decode(String.self, forKey: .id)
        bio = try values.decodeIfPresent(String.self, forKey: .bio)
        isMuted = try values.decode(Bool.self, forKey: .isMuted)
        postCount = try values.decode(Int.self, forKey: .postCount)
        followers = try values.decode(Int.self, forKey: .followers)
        following = try values.decode(Int.self, forKey: .following)
    }
}
