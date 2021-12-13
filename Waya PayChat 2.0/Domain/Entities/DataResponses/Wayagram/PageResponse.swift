//
//  PageResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/24/21.
//

import Foundation

struct PageResponse : Codable {
    var id : String = ""
    var userId : String = ""
    var categoryId : String = ""
    var username : String = ""
    var title : String = ""
    var description : String = ""
    var websiteUrl: String = ""
    var imageUrl : String = ""
    var headerImageUrl : String = ""
    var isPublic : Bool = true 
    var isDeleted : Bool = false 
    var createdAt : String = ""
    var updatedAt : String = ""
}


