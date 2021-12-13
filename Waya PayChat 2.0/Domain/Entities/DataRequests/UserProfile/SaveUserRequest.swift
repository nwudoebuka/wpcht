//
//  UserDetailRequest.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/25/21.
//

import Foundation

struct SaveUserRequest : Codable{
    var id : Int
    var email : String
    var phoneNumber : Int 
    var firstName : String
    var roles : [RoleRequest]
    var surname : String
}
