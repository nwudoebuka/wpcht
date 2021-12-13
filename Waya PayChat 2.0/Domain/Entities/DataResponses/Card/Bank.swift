//
//  Bank.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/9/21.
//

import Foundation

struct Bank : Codable {  
    var name: String
    var code: String
    var accountNumber: String?
    var accountName: String? = ""
}

struct BankResolveResponse: Codable {
    let accountNumber: String
    let bankID: Int
    let accountName: String
    
    enum CodingKeys: String, CodingKey {
        case accountNumber = "account_number"
        case bankID = "bank_id"
        case accountName = "account_name"
    }
}

struct BankResponse: Codable {
    var accountName: String?
    var accountNumber: String?
    var bankName: String?
    var bankCode: String?
    var rubiesBankCode: String?
    
//    enum CodingKeys: String, CodingKey {
//        case accountName, accountNumber, bankName, bankCode, rubiesBankCode
//        //case userID = "userId"
//    }
}

struct ChargeBankRequest: Codable {
    let app_ref: String = UUID().uuidString
    var amount: String
    var email: String
    var walletAcctNo: String
}

struct ChargeBankResponse: Codable {
    var authorization_url: String// "https://checkout.paystack.com/3k7iz5ymyvumnr2",
    var access_code: String //"3k7iz5ymyvumnr2",
    var reference: String //"1622012121487"
}


struct BankBeneficiary: Codable {
    var id: Int //10,
    var name: String //"MUMMY JASMINE CAFETERIA &amp; CONFECTIONERY",
    var bankCode: String //"057",
    var bankName: String //"Zenith Bank",
    var branchCode: String? //null,
    var accountNumber: String//"0000000000",
    var userId: String //"312",
    var alias: String? //"MUMMY JASMINE CAFETERIA &amp; CONFECTIONERY"
    
    func bankInfo() -> Bank {
        return Bank(name: self.bankName, code: self.bankCode, accountNumber: self.accountNumber, accountName: self.name)
    }
}
