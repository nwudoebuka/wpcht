//
//  SendMoney.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 01/06/2021.
//

import Foundation

struct SendMoneyToEmailRequest : Codable{
    var amount: Decimal
    var description: String
    var senderAccountNumber: String
    var senderId: Int
}
