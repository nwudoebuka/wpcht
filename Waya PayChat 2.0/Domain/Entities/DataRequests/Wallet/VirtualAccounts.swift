//
//  VirtualAccounts.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 25/05/2021.
//

import Foundation

struct VirtualAccountsResponse: Codable {
    var id: Int
    var bankName: String?
    var bankCode: String?
    var accountNumber: String?
    var accountName: String?
    var userId: String?
    var deleted: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, bankName, bankCode, accountNumber, accountName, userId, deleted
    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try values.decode(Int.self, forKey: .id)
//        bankName = try values.decodeIfPresent(String.self, forKey: .bankName)
//        bankCode = try values.decodeIfPresent(String.self, forKey: .bankCode)
//        accountName = try values.decodeIfPresent(String.self, forKey: .accountName)
//        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
//        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
//        deleted = try values.decodeIfPresent(Bool.self, forKey: .deleted)
//    }
    
}

