//
//  WalletService.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 12/08/2021.
//

import Foundation

enum WalletService: Microservice {

    case getUserWallet(userId: String)
    case createWallet
    case setDefaultWalletAccount
    case getWalletHistory(accNumber: String)
    var stringValue: String {
        switch self {
        case .getUserWallet(let userId):
            return WayaClient.walletBase + "wallet/accounts/\(userId)"
        case .createWallet:
            return WayaClient.walletBase + "wallet/create-wallet"
        case .setDefaultWalletAccount:
            return WayaClient.walletBase + "wallet/user/account/modify"
        case .getWalletHistory(let accNumber):
                return WayaClient.walletBase + "/api/v1/wallet/statement/\(accNumber)"
        }
    }
    
    var url : URL? {
         guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
             return nil
         }
         return _url
    }
}
