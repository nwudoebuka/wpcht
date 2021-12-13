//
//  AccountType.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 17/05/2021.
//

import Foundation

enum AccountType: Codable {
    case corporate
    case personal
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        switch rawValue {
        case "corporate":
            self = .corporate
        case "personal":
            self = .personal
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .corporate:
            try container.encode("corporate", forKey: .rawValue)
        case .personal:
            try container.encode("personal", forKey: .rawValue)
        }
    }
}

struct BusinessType: Codable {
    var businessType: String
    var id: Int
    
    enum CodingKeys: String, CodingKey {
        case id, businessType
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        businessType = try values.decode(String.self, forKey: .businessType)
    }
}
