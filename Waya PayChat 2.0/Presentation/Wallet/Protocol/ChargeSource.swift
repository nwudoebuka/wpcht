//
//  ChargeSource.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 02/08/2021.
//

import Foundation


enum BankType: String {
    case existing
    case new
}

enum ChargeSource: Equatable {
    
    case bank(BankType)
    case card
    case wallet
    
//    static func < (lhs: ChargeSource, rhs: ChargeSource) -> Bool {
//        return false
//    }
//    
    static func == (lhs: ChargeSource, rhs: ChargeSource) -> Bool {
        switch (lhs, rhs) {
        case (.card, .bank(.new)), (.card, .bank(.existing)), (.card, .wallet):
            return false
        case (.card, .card):
            return true
        case (.wallet, .wallet):
            return true
        case (.bank(let lhType), .bank(let rhType)):
            return lhType == rhType
        default:
            return false
        }
    }
}
