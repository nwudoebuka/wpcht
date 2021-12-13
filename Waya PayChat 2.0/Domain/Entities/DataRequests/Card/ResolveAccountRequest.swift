//
//  ResolveAccountRequest.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/5/21.
//

import Foundation

struct ResolveAccountRequest : Codable {
    var accountNumber : String
    var bankCode: String
}
