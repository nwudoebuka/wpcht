//
//  NotificationsResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 30/07/2021.
//

import Foundation

struct NotificationsResponse: Codable {
    var notifications: [Notification]
    var total: Int
    
    enum CodingKeys: String, CodingKey {
        case notifications
        case total = "totalNumberOfInAppNotifications"
    }
}

struct Notification: Codable {
    var notificationId: String //"4685591d-c234-41a5-9ca4-f37513c7e974",
    var initiator: String //"angakoko_",
    var initiatorImage: String? //null,
    var read: Bool //false,
    var recipient: String //"1",
    var dateSent: String //"2021-06-12T08:06:58.534131",
    var content: String // You have acccepted the invitation to join DSC group",
    var status: String //"SUCCESSFUL"
}
