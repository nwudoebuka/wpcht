//
//  EventResponse .swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/24/21.
//

import Foundation

struct EventResponse : Codable{
    
    var id : String = ""
    var organizerId : String = ""
    var eventName : String = ""
    var location : String = ""
    var details : String = ""
    var eventPoster : String?
    var eventStart : String = ""
    var eventEnd : String  = ""
    var createdAt : String = ""
    var updatedAt : String = ""

    
}
