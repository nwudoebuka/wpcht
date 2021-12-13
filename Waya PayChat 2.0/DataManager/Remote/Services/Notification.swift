//
//  Notification.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 12/08/2021.
//

import Foundation

enum NotificationService: Microservice {
    case getNotifications(userId: String)
    
    var stringValue: String {
        switch self {
        case .getNotifications(let user):
            return WayaClient.notificationBase + "notification-service/in-app-notifications/\(user)?page=0"
        }
    }
    
    var url : URL? {
         guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
             return nil
         }
         return _url
    }
}
