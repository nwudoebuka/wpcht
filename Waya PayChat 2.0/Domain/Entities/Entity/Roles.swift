//
//  Roles.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/25/21.
//

import Foundation

struct Role{
    
    let description : String
    let  id : Int
    let name : String
    let permissions: [Permission]
}

struct Permission{
    let description: String
    let id : Int
    let name : String
}
