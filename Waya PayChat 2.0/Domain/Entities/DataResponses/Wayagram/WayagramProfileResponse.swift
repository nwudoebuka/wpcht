//
//  WayagramProfileResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/27/21.
//

import Foundation


struct WayagramProfileResponse : Codable{
    var avatar : String?
    var coverImage : String?
    var username : String = ""
    var notPublic  : Bool = false
    var id : String = ""
    var user : UserProfile 
    var postCount : Int?
    var following : Int?
    var followers : Int?
    var connection: WayaConnection?

}

struct WayaConnection: Codable {
    let connected, following, followsYou: Bool
}
