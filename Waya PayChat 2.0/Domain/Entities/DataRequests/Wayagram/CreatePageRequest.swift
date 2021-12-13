//
//  CreatePageRequest.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/25/21.
//

import SwiftUI

struct CreatePageRequest {
    var userId : String = ""
    var categoryId : String = ""
    var username : String = ""
    var title : String = ""
    var description : String = ""
    var websiteUrl: String = ""
    var imageUrl : UIImage = UIImage()
    var headerImageUrl :  UIImage = UIImage()
    var isPublic : Bool = true 
}

struct InviteToPageRequest : Codable{
    var pageId : String = ""
    var requestFrom  : String = ""
    var requestTo : String = ""
}

struct RespondToAdminInvite : Codable{
    var pageId : String = ""
    var requestFrom  : String = ""
    var requestTo : String = ""
    var adminInviteId  : String = ""
    var accepted : Bool = true 
}

struct AdminDeletePageReuest : Codable{
    var pageId : String = ""
    var userId : String = ""
    var isDeleted : Bool = true
}

struct FollowPageRequest: Codable{
    var userId : String = ""
    var paggeId : String = ""
}

struct PageReportRequest : Codable{
    
    var pageId : String = ""
    var reportingUserId : String = ""
    var reportedUserId : String = ""
    var reportType : String = ""
    var report : String = ""
}

struct RespondToFriendPageInvite : Codable{
    var pageId : String = ""
    var requestFrom  : String = ""
    var requestTo : String = ""
    var friendInviteId  : String = ""
    var accepted : Bool = true 
}
