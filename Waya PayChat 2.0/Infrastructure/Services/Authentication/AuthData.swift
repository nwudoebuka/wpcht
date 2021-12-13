//
//  AuthData.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 15/06/2021.
//

import Foundation

struct AuthData: Codable {
    var appLockStatus: AuthStatus! = .locked // default state is locked, need to take this out of here.
    var onboardingShown: Bool
    var wayagramSetup: Bool
    var userId: Int?
    var profile: UserProfile?
    var wayagramProfile: WayagramProfile?
    var token: String?
    var last_active: String?
    var loggedIn: Bool
    var completedKyc: [RequiredSetup]?
    var accounts: PaymentAccounts?
    var walletHistory:TransactionWalletData?
    var txnHistory:[TransactionResponse]?
    
    enum CodingKeys: String, CodingKey {
        case onboardingShown, wayagramSetup, userId, profile, wayagramProfile, token, last_active, loggedIn, accounts, completedKyc
    }

    init(onboarding: Bool) {
        self.onboardingShown = onboarding
        self.wayagramSetup = onboarding
        self.loggedIn = false
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        onboardingShown = try values.decode(Bool.self, forKey: .onboardingShown)
        wayagramSetup = try values.decode(Bool.self, forKey: .wayagramSetup)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        profile = try values.decodeIfPresent(UserProfile.self, forKey: .profile)
        wayagramProfile = try values.decodeIfPresent(WayagramProfile.self, forKey: .wayagramProfile)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        print("token is \(token)")
        last_active = try values.decodeIfPresent(String.self, forKey: .last_active)
        loggedIn = try values.decode(Bool.self, forKey: .loggedIn)
        accounts = try values.decodeIfPresent(PaymentAccounts.self, forKey: .accounts)
        completedKyc = try values.decodeIfPresent([RequiredSetup].self, forKey: .completedKyc)
        
        if self.completedKyc == nil {
            completedKyc = [RequiredSetup]()
        }
        // Minor patch to migrate KYC Information if app is killed or the user's profile refreshed
        // This is neccessary to only show the uncompleted KYC steps on the wallets page
        guard let user = profile else {
            return
        }
        
        if user.emailVerified == true && completedKyc?.firstIndex(of: .emailVerify) == nil {
            completedKyc?.append(.emailVerify)
        }
        
        if user.phoneVerified == true && completedKyc?.firstIndex(of: .phoneVerify) == nil {
            completedKyc?.append(.phoneVerify)
        }
    }
}
