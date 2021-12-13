//
//  WayagramService.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 26/08/2021.
//

import Foundation

enum WayagramService: Microservice {
    
    case getNewInterests(String)
    case getProfileByUserId(userId: String)
    case saveUserInterest
    case updateProfile
    case getFriendSuggestions(userId: String)
    case followUser
    case unfollowUser
    case wayaAutoFollow
    
    var stringValue: String {
        switch self {
        case .getNewInterests(let id):
            return WayaClient.wayagramBase + "graph/user-interest/notAdded?profileId=\(id)"
        case .getProfileByUserId(let id):
            return WayaClient.wayagramBase + "main/profile/get-by-user-id?user_id=\(id)"
        case .saveUserInterest:
            return WayaClient.wayagramBase + "graph/user-interest/selectUserInterest"
        case .updateProfile:
            return WayaClient.wayagramBase + "main/profile/update"
        case .getFriendSuggestions(let id):
            return WayaClient.wayagramBase + "graph/friend/suggestions?user_id=\(id)"
        case .followUser:
            return WayaClient.wayagramBase + "graph/friend/follow"
        case .unfollowUser:
            return WayaClient.wayagramBase + "graph/friend/unfollow"
        case .wayaAutoFollow:
            return WayaClient.wayagramBase + "graph/friend/waya-auto-follow"
        }
    }
    
    var url : URL? {
           guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
               return nil
           }
           return _url
       }
}
