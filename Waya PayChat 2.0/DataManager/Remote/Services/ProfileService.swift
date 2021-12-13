//
//  ProfileService.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 12/08/2021.
//

import Foundation
import Alamofire

enum ProfileService: Microservice {
    
    case getProfile(id: String)
    case updatePersonalProfileImage(profileId : String)
    case smsAlertConfig
    
    var stringValue: String {
        switch self {
        case .getProfile(let id):
            return Auth.baseURL + "profile/\(id)"
        case .updatePersonalProfileImage(let id):
            return Auth.baseURL + "profile/update-profile-image/\(id)"
        case .smsAlertConfig:
            return Auth.baseURL + "profile/sms-alert"
        }
    }
    
    var url: URL? {
        guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return nil
        }
        return _url
    }
    
}
