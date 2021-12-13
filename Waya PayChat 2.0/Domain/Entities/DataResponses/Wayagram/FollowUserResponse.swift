//
//  FollowUserResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 01/09/2021.
//

import Foundation

struct FollowUserResponse: Codable {
    var status: Bool
    var followingNotification: Bool
    var followedNotification: Bool
    var message: String
    var timestamp: String
}
