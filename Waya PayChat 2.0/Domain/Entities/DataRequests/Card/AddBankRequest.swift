//
//  AddBankRequest.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/5/21.
//

import Foundation

struct AddBankRequest: Codable {
    
    var accountName : String
    var accountNumber : String
    var bankName:  String
    var userId : String
    var bankCode : String
    var rubiesBankCode : String
}


