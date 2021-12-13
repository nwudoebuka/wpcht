//
//  CreateCommentRequest.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/9/21.
//

import Foundation

struct CreateCommentRequest : Codable {
    let post_id : String
    let profile_id : String
    let parent_id : String?
    let comment : String
    let type : String
}


struct UpdateCommentRequest : Codable{
    let comment_id: String
    let comment : String
}
