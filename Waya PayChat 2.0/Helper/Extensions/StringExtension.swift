//
//  StringExtension.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/2/21.
//

import Foundation


extension String{
    
    var length: Int {
        return self.count
    }

    func substring(_ from: Int, _ length: Int? = nil) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return (length != nil && self.length > 0) ? String(self[fromIndex ..< self.index(fromIndex, offsetBy: length!)]) : String(self[fromIndex...])
    }
    
    func formatPhoneNumber() -> String{
        
        let string: String!
        if(self.starts(with: "234")) {
            return self
        }
        if self.starts(with: "0") && self.length > 1 {
            string = "234" + self.substring(1)
            return string
        }
        if self.starts(with: "+") {
            let trimmed = self.substring(1)
            return trimmed.formatPhoneNumber()
        } else {
            string = "234" + self
            return string
        }
    }
    
    func getLastFew(range ofCount: Int) -> String{
        return String(self.suffix(ofCount))
    }
    func getFirstFew(range ofCount: Int) -> String{
        return String(self.prefix(ofCount))
    }
    
    func isNumeric() -> Bool {
        let characterSet = CharacterSet.decimalDigits
        
        for uni in self.unicodeScalars {
            guard let uniVal = UnicodeScalar(uni.value), characterSet.contains(uniVal) else {
                return false
            }
        }
        return true
    }
    
    var currencySymbol: String? {
        let locale = Locale.init(identifier: "en_NG")
        
        if let value = Decimal(string: self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = locale
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return locale.currencySymbol! + "0"
    }
}
