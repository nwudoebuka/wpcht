//
//  LoginRequest.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/22/21.
//

import Foundation


struct LoginRequest : Codable{
    var admin : Bool = false
    var emailOrPhoneNumber: String
    var password: String
    
    enum CodingKeys: String, CodingKey{
        case admin
        case emailOrPhoneNumber
        case password
    }
            
}

struct LoginRequestHistory : Codable{
    let city : String
    let country : String
    let device : String
    let id : Int
    let ip : String
    let province : String
    let userId : String
}

