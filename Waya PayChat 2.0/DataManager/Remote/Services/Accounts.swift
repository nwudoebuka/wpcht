//
//  Accounts.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 12/08/2021.
//

import Foundation


enum AccountService: Microservice {
    case getVirtualAccounts(user: String)
    
    var stringValue: String {
        switch self {
        case .getVirtualAccounts(let user):
            return WayaClient.accountsBase + "account/getAccounts/\(user)"
        }
    }
    
    var url : URL? {
         guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
             return nil
         }
         return _url
    }
}
