//
//  WithdrawalRequest.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 09/08/2021.
//

import Foundation

struct WithdrawalRequest: Codable {
    let transRef: String = UUID().uuidString
    var amount: String //"string",
    var bankCode: String //"string",
    var bankName: String //"string",
    var crAccount: String //"string",
    var crAccountName: String //"string",
    var narration: String? //"string",
    var saveBen: Bool //true,
    var transactionPin: String //"string",
    var userId: String //"string",
    var walletAccountNo: String //"string"
}
