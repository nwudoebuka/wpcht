//
//  WalletHistoryResponse.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 28/08/2021.
//

import Foundation
import Foundation


struct TransactionWalletData:Codable {
    var currentBalance:Int
    var transactionHistory:[TransactionWalletHistory]?
}

struct TransactionWalletHistory:Codable {
    var id:Int?
    var del_flg:Bool?
    var posted_flg:Bool?
    var tranId:String?
    var acctNum:String?
    var tranAmount:Double?
    var tranType:String?
    var partTranType:String?
    var tranNarrate:String?
    var tranDate:String?
    var tranCrncyCode:String?
    var paymentReference:String?
    var tranGL:String?
    var createdAt:String?
    var updatedAt:String?
    var createdBy:String?
    var createdEmail:String?

}
