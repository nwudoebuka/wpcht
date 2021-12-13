//
//  PostResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/10/21.
//

import Foundation

struct CreatePostResponse: Codable {
    var id: String //"aa4f4fc9-5d49-491c-80e6-2af74d56d46b",
    var isDeleted: Bool //false,
    var likeCount: Int // 0,
    var unLikeCount: Int // 0,
    var commentCount: Int //0,
    var repostCount: Int // 0,
    var isRepost: Bool // false,
    var description: String // "another test",
    var type: String //"user",
    var isPoll: Bool //false,
//    millisecCreatedAt": null,
//    "millisecUpdatedAt": null,
    var profileId: String //"18884fe5-be2f-45a8-a74a-936fe0c43c18",
    var updatedAt: String //"2021-07-28T05:16:19.254Z",
    var createdAt: String // "2021-07-28T05:16:19.254Z",
//    kind": null,
//    "GroupId": null,
//    "PageId": null,
//    "OriginalPostId": null,
//    "ReposterProfileId": null,
//    "repostCommentDesc": null
    
    enum CodingKeys: String, CodingKey {
        case id, isDeleted, likeCount, unLikeCount, commentCount, repostCount, isRepost, description, type, isPoll
        case profileId = "ProfileId"
        case updatedAt, createdAt
    }
}

struct PostResponse : Codable, Identifiable {

    var id: String = ""
    var description: String = ""
    var type: String = ""
    var hashtags, mentions: [JSONAny]?
    var parentID, groupID, pageID: String?
    var isDeleted : Bool  = false
    var isPoll: Bool  = false
    var createdAt = ""
    var updatedAt: String = ""
    var tags : [String]? = []
    var profile: PostProfilerResponse
    var images: [PostImageResponse]? = []
    var poll : PostPollResponse? 
    var postion : Int? = 0
    var likesCount : Int = 0
    var commentCount: Int = 0
    var repostCount : Int = 0
    var isLiked : Bool = false
    
    var uiImage : UIImage? = UIImage()
    var postImages : [UIImage]? = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case description = "description"
        case hashtags, mentions, type
        case parentID = "ParentId"
        case groupID = "GroupId"
        case pageID = "PageId"
        case isDeleted, isPoll, createdAt, updatedAt, profile, images, likesCount, repostCount, isLiked 
    }
}

struct PostImageResponse: Codable {
    let id, type, postID: String
    let imageURL: String
    let isDeleted: Bool
    let createdAt, updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, type
        case postID = "PostId"
        case imageURL, isDeleted, createdAt, updatedAt
    }
}

struct PostProfilerResponse: Codable {
    
    var avatar, coverImage: String?
    var username: String = ""
    var notPublic: Bool = false
    var id: String = ""
    var user : UserProfile
    
    enum CodingKeys: String, CodingKey {
        case avatar, coverImage, username
        case notPublic = "notPublic"
        case id
        case user
    }
}

struct PostVoteResponse: Codable {
    var facebook: Int?
    var instagram: Int?
}

struct PostPollResponse: Codable {
    var id : String = ""
    var postID: String = ""
    var isPaid: Bool = false
    var amount: Int = 0
    var expiresIn: JSONNull?
    var voteLimit: Int?
    var forceTerms: Bool = false
    var terms: String = ""
    var options: [String] = []
    var isDeleted: Bool = false
    var createdAt, updatedAt: String? 
    var votes: PostVoteResponse  = PostVoteResponse()
    
    enum CodingKeys: String, CodingKey {
        case id
        case postID = "PostId"
        case isPaid, amount, expiresIn, voteLimit, forceTerms, terms, options, isDeleted, createdAt, updatedAt, votes
    }
}
