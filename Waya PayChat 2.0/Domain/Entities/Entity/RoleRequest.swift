//
//  Roles.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/25/21.
//

import Foundation

struct RoleRequest : Codable{
    
    let description : String
    let  id : Int
    let name : String
    let permissions: [PermissionRequest]
}

struct PermissionRequest : Codable{
    let description: String
    let id : Int
    let name : String
}
