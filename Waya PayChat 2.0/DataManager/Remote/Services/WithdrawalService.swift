//
//  WithdrawalService.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 24/08/2021.
//

import Foundation

enum WithdrawalService: Microservice {
    case getBeneficiaries(id: String)
    case withdrawToBank
    case saveBeneficiary
    
    var stringValue: String {
        switch self {
        case .getBeneficiaries(let user):
            return WayaClient.withdrawalBase + "getWithdrawalBen?userId=\(user)"
        case .withdrawToBank:
            return WayaClient.withdrawalBase + "withdrawal/fund"
        case .saveBeneficiary:
            return WayaClient.withdrawalBase + "addWithdrawalBen"
        }
    }
    
    var url : URL? {
        guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return nil
        }
        return _url
    }
}
