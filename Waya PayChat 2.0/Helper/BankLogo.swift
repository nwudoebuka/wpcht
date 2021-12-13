//
//  BankLogos.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 22/06/2021.
//

import Foundation
import SwiftValidator

enum BankLogo: String, CaseIterable {
    case access = "Access Bank"
    case abbey = "Abbey Mortgage Bank"
    case access_diamond = "Access Bank (Diamond)"
    case alat = "ALAT by WEMA"
    case aso_savings = "ASO Savings and Loans"
    case bowen_mfb = "Bowen Microfinance Bank"
    case cemcs_mfb = "CEMCS Microfinance Bank"
    case citibank = "Citibank Nigeria"
    case coronation = "Coronation Merchant Bank"
    case ecobank = "Ecobank Nigeria"
    case ekondo_mfb = "Ekondo Microfinance Bank"
    case eyowo = "Eyowo"
    case fidelity = "Fidelity Bank"
    case firmus_mfb = "Firmus MFB"
    case first_bank = "First Bank of Nigeria"
    case fcmb = "First City Monument Bank"
    case fsdh = "FSDH Merchant Bank Limited"
    case globus = "Globus Bank"
    case gtbank = "Guaranty Trust Bank"
    case hackman_mfb = "Hackman Microfinance Bank"
    case hasal_mfb = "Hasal Microfinance Bank"
    case heritage = "Heritage Bank"
    case ibile_mfb = "Ibile Microfinance Bank"
    case infinity_mfb = "Infinity MFB"
    case jaiz = "Jaiz Bank"
    case keystone = "Keystone Bank"
    case kuda = "Kuda Bank"
    case lbic = "Lagos Building Investment Company Plc"
    case mayfair_mfb = "Mayfair MFB"
    case mint_mfb = "Mint MFB"
    case one_finance = "One Finance"
    case palmpay = "PalmPay"
    case parallex = "Parallex Bank"
    case parkway_readycash = "Parkway - ReadyCash"
    case paycom = "Paycom"
    case petra_mfb = "Petra Mircofinance Bank Plc"
    case polaris = "Polaris Bank"
    case providus = "Providus Bank"
    case rand_merchant = "Rand Merchant Bank"
    case rubies_mfb = "Rubies MFB"
    case sparkle_mfb = "Sparkle Microfinance Bank"
    case stanbic_ibtc = "Stanbic IBTC Bank"
    case standard_chartered = "Standard Chartered Bank"
    case sterling = "Sterling Bank"
    case suntrust = "Suntrust Bank"
    case taj = "TAJ Bank"
    case tcf_mfb = "TCF MFB"
    case titan = "Titan Bank"
    case union = "Union Bank of Nigeria"
    case uba = "United Bank For Africa"
    case unity = "Unity Bank"
    case vfd_mfb = "VFD Microfinance Bank Limited"
    case wema = "Wema Bank"
    case zenith = "Zenith Bank"
    case waya_default
    
    var image: UIImage {
        let logoBase  = "bank_logos/"
        var logo_name: String!
        switch self {
        case .access, .access_diamond:
            logo_name = logoBase + "access-bank"
        case .abbey:
            logo_name = logoBase + "abbey"
        case .alat:
            logo_name = logoBase + "alat-by-wema"
        case .aso_savings:
            logo_name = logoBase + "asosavings"
        case .bowen_mfb:
            logo_name = logoBase + "bowen"
        case .cemcs_mfb:
            logo_name = logoBase + "cemcs"
        case .citibank:
            logo_name = logoBase + "citibank-nigeria"
        case .coronation:
            logo_name = logoBase + "coronation"
        case .ecobank:
            logo_name =  logoBase + "ecobank-nigeria"
        case .ekondo_mfb:
            logo_name = logoBase + "ekondo-microfinance-bank"
        case .eyowo:
            logo_name = logoBase + "eyowo"
        case .fidelity:
            logo_name = logoBase + "fidelity-bank"
        case .firmus_mfb:
            logo_name  = logoBase + "firmus"
        case .first_bank:
            logo_name = logoBase + "first-bank-of-nigeria"
        case .fcmb:
            logo_name = logoBase + "first-city-monument-bank"
        case .fsdh:
            logo_name = logoBase + "fsdh"
        case .globus:
            logo_name = logoBase + "globus-bank"
        case .gtbank:
            logo_name = logoBase + "guaranty-trust-bank"
        case .hackman_mfb:
            logo_name = logoBase + "hackman-mfb"
        case .hasal_mfb:
            logo_name  = logoBase + "hasal-mfb"
        case .heritage:
            logo_name = logoBase + "heritage-bank"
        case .ibile_mfb:
            logo_name = logoBase + "ibile-microfinance-bank"
        case .infinity_mfb:
            logo_name = logoBase + "infinity-mfb"
        case .jaiz:
            logo_name = logoBase + "jaiz-bank"
        case .keystone:
            logo_name = logoBase + "keystone-bank"
        case .kuda:
            logo_name = logoBase + "kuda-bank"
        case .lbic:
            logo_name = logoBase + "lbic"
        case .mayfair_mfb:
            logo_name = logoBase + "mayfair-mfb"
        case .mint_mfb:
            logo_name = logoBase + "mint-mfb"
        case .one_finance:
            logo_name = logoBase + "one-finance"
        case .palmpay:
            logo_name = logoBase + "palmpay"
        case .parallex:
            logo_name = logoBase + "parallex"
        case .parkway_readycash:
            logo_name = logoBase + "parkway"
        case .paycom:
            logo_name = logoBase + "paycom"
        case .petra_mfb:
            logo_name = logoBase + "petra-mfb"
        case .polaris:
            logo_name = logoBase + "polaris-bank"
        case .providus:
            logo_name = logoBase + "providus-bank"
        case .rand_merchant:
            logo_name = logoBase + "rand-merchant-bank"
        case .rubies_mfb:
            logo_name = logoBase + "rubies-mfb"
        case .sparkle_mfb:
            logo_name = logoBase + "sparkle-microfinance-bank"
        case .stanbic_ibtc:
            logo_name = logoBase + "stanbic-ibtc"
        case .standard_chartered:
            logo_name = logoBase + "standard-chartered-bank"
        case .sterling:
            logo_name = logoBase + "sterling-bank"
        case .suntrust:
            logo_name = logoBase + "suntrust-bank-nigeria"
        case .taj:
            logo_name = logoBase + "taj-bank"
        case .tcf_mfb:
            logo_name = logoBase + "tcf-mfb"
        case .titan:
            logo_name = logoBase + "titan-trust-bank"
        case .union:
            logo_name = logoBase + "union-bank-of-nigeria"
        case .uba:
            logo_name  = logoBase + "united-bank-for-africa"
        case .unity:
            logo_name = logoBase + "unity-bank"
        case .vfd_mfb:
            logo_name = "bank"
        case .wema:
            logo_name = logoBase + "wema-bank"
        case .zenith:
            logo_name = logoBase + "zenith-bank"
        case .waya_default:
            logo_name = logoBase + ""
        }
        return UIImage(named: logo_name)!
    }
}
