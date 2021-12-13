//
//  MomentResponse.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/16/21.
//

import Foundation

struct MomentResponse: Codable{
    let id : String
    let UserId : String
    let type : String
    let content : String
    let isActive : Bool
    var updatedAt: String
    var createdAt: String
    let userAvatar : String
    let userName : String
    var userAvatarImage  : UIImage? = UIImage()
    var userMomentIamge : UIImage? = UIImage()
    
    enum CodingKeys: String, CodingKey {
        case id, UserId, type, content, isActive, updatedAt, createdAt, userAvatar, userName
        
    }
    
}
