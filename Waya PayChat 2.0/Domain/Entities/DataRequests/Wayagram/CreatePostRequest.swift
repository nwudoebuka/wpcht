//
//  CreatePostRequest.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/9/21.
//

import Foundation
import SwiftUI

struct CreatePostRequest : Codable{

    var profile_id :String
    var parent_id : String?
    var group_id : String?
    var page_id : String?
    var description: String?
    var type : String = "user" // type can be user, group , page
    var isPoll : Bool = false 
    var isPaid : Bool = false
    var amount : Int = 0
    var expiresIn : String?
    var voteLimit : Int = 0
    var forceTerms : Bool = false 
    var terms : String = "terms"
    var options : [String] = []

}

struct CreatePostRequestWithImage {
    
    var profile_id :String = ""
    var parent_id : String?
    var group_id : String?
    var page_id : String?
    var description: String = ""
    var type : String = "user" // type can be user, group , page 
    var isPoll : Bool = false 
    var isPaid : Bool = false
    var amount : Int = 0
    var expiresIn : String?
    var voteLimit : Int = 0
    var forceTerms : Bool = false 
    var terms : String = "terms"
    var options : [String] = []
    var images : [UIImage] = []
    
}

struct DeletePostRequest : Codable {
    var post_id : String
}

struct LikePostRequest: Codable{
    var post_id : String
    var profile_id: String
    var type : String
}


struct UpdatePostRequest{
    var images : [UIImage] = []
    var profile_id :String
    var description: String = ""
    var post_id : String
    var group_id : String?
    var page_id : String?
    var type : String = "user" // type can be user, group , page 
    var deletedHashtags : [ String] = []
    var addedHashtags : [ String] = []
    var deletedMentions : [ String] = []
    var addedMentions : [ String] = []
    var deletedFiles : [ String] = []
    var isPoll : Bool = false 
    var isPaid : Bool = false
    var amount : Int = 0
    var expiresIn : String?
    var voteLimit : Int = 0
    var forceTerms : Bool = false 
    var terms : String = "terms"
    var options : [String] = []
}

struct UpdateWayagramProfile{
    var avatar : UIImage?
    var coverImage : UIImage?
    var user_id : String
    var username: String?
    var notPublic : Bool?
    var displayName: String? = ""
}
