//
//  CommentResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/24/21.
//

import Foundation

struct CommentResponse : Codable{
    var id : String
    var type : String
    var comment: String
    var PostId : String
    var ProfileId: String
    var ParentId : String?
    var isDeleted : Bool
    var createdAt : String
    var updatedAt : String
}
