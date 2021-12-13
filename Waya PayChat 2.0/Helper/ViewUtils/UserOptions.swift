//
//  UserOptions.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 15/07/2021.
//

import Foundation

//struct UserOptions {
enum MainSettings: CaseIterable {
    case profile, notification, payments, chat, account, tos, about, blocked, restricted, preferences, feedback, synchronize, invite, info
    
    var text: (title: String, subtitle: String?) {
        switch self {
        case .profile:
            return ("Profile settings", "Profile image, name and password")
        case .notification:
            return ("Notification settings", "Address, email")
        case .payments:
            return ("Payment settings", "Card, Bank, Credentials")
        case .chat:
            return ("Chat settings", "Accounts, chat, invite")
        case .account:
            return ("Account settings", "Privacy, security")
        case .tos:
            return ("Terms and conditions", nil)
        case .about:
            return ("About", nil)
        case .blocked:
        return ("Blocked accounts", nil)
        case .restricted:
            return ("Restricted accounts", nil)
        case .preferences:
            return ("Preferences", nil)
        case .feedback:
            return ("Send feedback", nil)
        case .synchronize:
            return ("Synchronize accounts", nil)
        case .invite:
            return ("Invite a friend", nil)
        case .info:
            return ("Login information", nil)
        }
    }

    var controller: SettingsView? {
        get {
            switch self {
            case .profile:
                return ProfileSettingsViewController()
            case .notification, .chat, .tos, .about, .blocked, .restricted, .feedback, .synchronize, .invite, .info:
                return nil
            case .account:
                return AccountSettingsViewController()
            case .preferences:
                return PreferenceSettings()
            case .payments:
                return PaymentSettingsViewController()
            }
        }
    }
}

enum PaymentSettings: CaseIterable {
    case editProfile, disputeResolution, manageCard, manageBank, credentials, resetPin, others
    
    var text: (title: String, subtitle: String?) {
        switch  self {
        case .editProfile:
            return ("Edit Profile", "Profile image, name and password")
        case .disputeResolution:
            return ("Dispute Resolution", "Report complaints, customer service")
        case .manageCard:
            return ("Manage Card", "Add your debit card")
        case .manageBank:
            return ("Manage Bank", "Add your bank details")
        case .credentials:
            return ("Credentials", "International passport, BVN, ID Card, NIN")
        case .resetPin:
            return ("Reset PIN", "Reset your payment PIN")
        case .others:
            return ("Other Details", "Address, Utility Bill")
        }
    }
    
    var controller: SettingsView? {
        switch self {
        case .editProfile, .disputeResolution, .manageCard, .manageBank, .credentials:
            return  nil
        case .resetPin:
            return nil
        case .others:
            return nil
        }
    }
}
    
enum ProfileSettings: CaseIterable {
    case editProfile, account, password, general, invite
    
    var text: (title: String, subtitle: String?) {
        switch self {
        case .editProfile:
            return ("Edit profile", "Profile image, handle name")
        case .account:
            return ("Account", "Privacy, security")
        case .password:
            return ("Password", "Reset password")
        case .general:
            return ("General Settings", nil)
        case .invite:
            return ("Invite Friends", nil)
        }
    }
    
    var controller: SettingsView? {
        switch self {
        case .password:
            return ChangePasswordViewController()
        case .editProfile:
            return UpdateProfileViewController()
        case .account, .general, .invite:
            return nil
        }
    }
}

//}



