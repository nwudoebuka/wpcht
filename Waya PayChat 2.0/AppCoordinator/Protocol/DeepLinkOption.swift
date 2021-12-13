//
//  DeepLinkOption.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/2/21.
//

import Foundation


struct DeepLinkURLConstants {
    static let Onboarding = "onboarding"
    static let DashBoard = "dashboard"
    static let Login = "login"
    static let SignUp = "signUp"
    static let Profile = "profile"
    static let Item = "item"

}


enum DeepLinkOption{
    
    case onboarding
    case dashboard
    case login
    case signUp
    case profile
    case item(String?)

    
    static func build(with userActivity: NSUserActivity) -> DeepLinkOption? {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL,
           let _ = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            //TODO: extract string and match with DeepLinkURLConstants
        }
        return nil
    }
    
    static func build(with dict: [String : AnyObject]?) -> DeepLinkOption? {
        guard let id = dict?["launch_id"] as? String else { return nil }
        
        let itemID = dict?["item_id"] as? String
        
        switch id {
            case DeepLinkURLConstants.Onboarding: return .onboarding
            case DeepLinkURLConstants.Login: return .login
            case DeepLinkURLConstants.SignUp: return .signUp
            case DeepLinkURLConstants.DashBoard: return .dashboard
            case DeepLinkURLConstants.Profile: return .profile
            case DeepLinkURLConstants.Item: return .item(itemID)

            default: return nil
        }
    }
}
