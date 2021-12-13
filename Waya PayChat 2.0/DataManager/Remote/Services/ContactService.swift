//
//  ContactService.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 12/08/2021.
//

import Foundation

enum ContactService : Microservice {
    
    case findAllContact
    case sendMoneyToContact
    case sendMoneyToEmail(email: String)
    case sendMoneyToUserId
    case filterContact
    
    var stringValue: String {
        switch self {
        case .findAllContact:
            return WayaClient.contactBase + "contact/account/service/find/all/contact/account"
        case .sendMoneyToContact:
            return WayaClient.contactBase + "contact/account/service/send/money/to/contact"
        case .sendMoneyToEmail(let email):
            return WayaClient.contactBase + "contact/account/service/send/money/to/email/\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))"
        case .sendMoneyToUserId:
            return WayaClient.contactBase + "contact/account/service/send/money/to/userId"
        case .filterContact:
            return WayaClient.contactBase + "filter/contact"
        }
    }
    
    var url : URL? {
         guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
             return nil
         }
         return _url
    }
}
