//
//  TransactionResponse.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 31/08/2021.
//

import Foundation

struct TransactionResponse:Codable {
    var transactionDate:String?
    var tranType:String?
    var transactionTime:String?
    var receiverEmail:String?
    var phoneNo:String?
    var accountNo:String?
    var tranAmount:Double?
    var tranNarration:String?
    var debitCredit:String?
    var tranId:String?
}

