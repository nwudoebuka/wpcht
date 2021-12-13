//
//  CardUtils.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 05/08/2021.
//

import Foundation
import SwiftValidator

struct CardUtils {
    static func cardTypeImage(prefix: String) -> UIImage {
        let cardType = CardState(fromPrefix: prefix)
        
        switch cardType {
            
        case .identified(let type):
            switch type {
            case .verve:
                return UIImage(named: "icons/verve_icon")!
            case .visa:
                return UIImage(named: "icons/visa_icon")!
            case .mastercard:
                return UIImage(named: "icons/mastercard_icon")!
            default:
                return UIImage(named: "icons/verve_icon")!
            }
        default:
            return UIImage(named: "icons/verve_icon")!
        }
    }
}
