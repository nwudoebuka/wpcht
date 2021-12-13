//
//  CreateAccountRequest.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/22/21.
//

import Foundation

struct CreateAccountRequest {
    var type: AccountType
    var data: [String: Any]
    var phoneNumber: String!
    
    init(type: AccountType, data: [String: Any]) {
        self.type = type
        self.data = data
        self.phoneNumber = data["phoneNumber"]! as! String
    }
}


