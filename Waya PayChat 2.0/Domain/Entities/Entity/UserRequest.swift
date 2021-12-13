//
//  AuthModel.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/25/21.
//

import Foundation

struct UserRequest : Codable{
    let id : Int
    let email : String
    let phoneNumber : Int 
    let surname : String
    let role : RoleRequest?
    let dateCreated: String
    let referenceCode : String

}

struct GenResp<T> : Codable where T : Codable{
    
    let name : String
    let b : [T]
}


/* 
 Selected Post can take a post (Saved  post in coredata ) used in HomeViewController 
 or a postResponse a post from the api used in TimeLineViewController 
 */
struct SelectedPost {
    var position = -1 
    var profileId = "" 
    var postId = ""
    var indexPath : IndexPath?
    var post: Post?
    var postResponse : PostResponse?
}
