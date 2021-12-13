//
//  KYCService.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 13/08/2021.
//

import Foundation

enum KYCService: Microservice {
    
    case linkBvnToAccount
    case verifyBvn(otp: String, user: String)
    case isBvnLinked(user: String)
    case resendOTP(user: String)
    
    var stringValue: String {
        switch self {
        case .linkBvnToAccount:
            return WayaClient.kycBase + "bvn/linkBvn"
        case .verifyBvn(let otp, let user):
            return WayaClient.kycBase + "bvn/validateBvn/\(user)/\(otp)"
        case .isBvnLinked(let user):
            return WayaClient.kycBase + "bvn/isBvnLinked/\(user)"
        case .resendOTP(let user):
            return WayaClient.kycBase + "bvn/resendOTP/\(user)"
        }
    }
    
    var url : URL? {
        guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return nil
        }
        return _url
    }
}
