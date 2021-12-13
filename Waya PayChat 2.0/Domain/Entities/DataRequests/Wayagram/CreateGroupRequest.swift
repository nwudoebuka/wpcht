//
//  CreateGroupRequest.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/24/21.
//

import Foundation
import SwiftUI


struct CreateGroupRequest {
    var image : UIImage?
    var headerImage : UIImage?
    var userId : String = ""
    var name : String = ""
    var description : String = ""
    var isPublic : Bool = true 
    var mute : Bool = false 
    
}

struct GroupRequest : Codable{
    var groupId : String = ""
    var userId : String  = ""
}

struct InviteToGroupRequest : Codable{
    var groupId : String = ""
    var requestFrom  : String = ""
    var requestTo : String = ""
}


struct RespondToInviteRequest : Codable{
    var groupId : String = ""
    var requestFrom  : String = ""
    var requestTo : String = ""
    var groupInviteId  : String = ""
    var accepted : Bool = true 
}

struct ReportMemberRequest : Codable {
    
    var groupId : String = ""
    var reportingUserId : String = ""
    var reportedUserId : String = ""
    var reportType : String = ""
    var report : String = ""
}
