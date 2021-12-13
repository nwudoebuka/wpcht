//
//  CardService.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 12/08/2021.
//

import Foundation

enum CardService : Microservice {
     
    case addBankAccount(userid: String)
    case deleteBankAccount(user: String, accountNumber: String)
    case getAllBanks
    case getUserBankAccounts(userId: String)
    case resolveAccountNumber
    case addCard
    case submitCardPhone
    case verifyCardOtp
    case deleteBankCard(userId: String, cardNumber: String)
    case getUserBankCard(userId: String)
    case chargeCard
    case chargeBankAccount(user: String)
    case getChargeAbleBanks
    case getWalletHistory(accountNumber:String)
    case getTransactionHistory(accountNumber:String)
    
    var stringValue: String  {
        switch self {
        case .getUserBankCard(let userId):
            return WayaClient.cardBase + "card/list/" + userId
        case .deleteBankCard(let user, let card):
            return WayaClient.cardBase + "card/delete/\(user)/\(card)"
        case .addBankAccount(let user):
            return WayaClient.cardBase + "bankAccount/add/\(user)"
        case .deleteBankAccount(let user, let account):
            return WayaClient.cardBase + "bankAccount/delete/\(user)/\(account)"
        case .getAllBanks:
            return WayaClient.cardBase + "bankAccount/getBanks"
        case .getUserBankAccounts(let user):
            return WayaClient.cardBase + "bankAccount/list/\(user)"
        case .resolveAccountNumber:
            return WayaClient.cardBase + "bankAccount/resolveAccountNumber"
        case .addCard :
            return WayaClient.cardBase + "card/add"
        case .submitCardPhone:
            return WayaClient.cardBase + "card/submitPhone"
        case .verifyCardOtp:
            return WayaClient.cardBase + "card/submitOtp"
        case .chargeCard:
            return WayaClient.cardBase + "card/charge"
        case .chargeBankAccount(let user):
            return WayaClient.cardBase + "bankAccount/payWithCheckOut/\(user)"
        case .getChargeAbleBanks:
            return "https://api.paystack.co/bank?gateway=emandate&pay_with_bank=true"
        case .getWalletHistory(accountNumber: let accountNumber):
            return WayaClient.walletBase + "wallet/statement/\(accountNumber)"
        case .getTransactionHistory(accountNumber: let accountNumber):
            return WayaClient.walletBase + "wallet/admin/account/statement/\(accountNumber)"


        }
    }
     
    var url : URL? {
         guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
             return nil
         }
         return _url
    }
}
