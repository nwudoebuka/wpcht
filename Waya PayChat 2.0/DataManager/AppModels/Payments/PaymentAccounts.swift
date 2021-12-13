//
//  Accounts.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 12/08/2021.
//

import Foundation

struct PaymentAccounts: Codable {
    var wallets: [UserWalletResponse]?
    var banks: [BankResponse]?
    var cards: [CardResponse]?
    var virtualAccount: VirtualAccountsResponse?
}