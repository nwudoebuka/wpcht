//
//  BvnRequest.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/2/21.
//

import Foundation


struct LinkBvnRequest: Codable{
    
    var accountNumber : String
    var bvn : String
    var dob : String
    var firstName : String
    var lastName : String
    var userId: String
}
