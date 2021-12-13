//
//  SuggestFriendResponse.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 30/08/2021.
//

import Foundation

struct SuggestFriendResponse<T: Codable>: Codable {
    var status: Bool //true,
    var message: String // "Friend suggestions",
    var Profiles: T
    var timestamp: String //"2021-08-30T03:12:40.337Z"
}

struct  SuggestFriendProfiles: Codable {
    var UserId: String // "29",
    var avatar: String? //null,
    var simulatedUser: Bool // false,
    var deleted: Bool // false,
    var notificationCount: Int?// null,
    var coverImage: String? //null,
    var username: String //"Tijani",
    var displayName: String?// "Oluwafemi Tijani",
    var notPublic: Bool// false,
    var id: String //"62b79ee8-711a-4ff3-9ea9-4df5f2a39a24",
    var bio: String? //null,
    var isMuted: Bool// false,
    var postCount: Int // 0,
    var following: Int //1,
    var followers: Int //10
}
