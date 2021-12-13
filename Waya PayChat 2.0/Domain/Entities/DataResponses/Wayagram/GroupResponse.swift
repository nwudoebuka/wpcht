//
//  GroupResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/24/21.
//

import Foundation

struct GroupResponse : Codable, Identifiable {
    var id : String = ""
    var userId : String = ""
    var name : String  = ""
    var description : String = ""
    var imageUrl : String?
    var headerImageUrl : String?
    var isPublic : Bool = true 
    var mute : Bool  = false 
    var createdAt = ""
    var updatedAt = ""
    
    
}
