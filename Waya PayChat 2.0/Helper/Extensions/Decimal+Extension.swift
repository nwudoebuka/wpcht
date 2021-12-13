//
//  Decimal+Extension.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 03/08/2021.
//

import Foundation

extension Decimal {
    var formattedAmount: String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSDecimalNumber)
    }
}
