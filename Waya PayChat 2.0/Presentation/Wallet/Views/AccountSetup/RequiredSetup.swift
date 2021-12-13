//
//  RequiredSetup.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 17/06/2021.
//

import Foundation

enum RequiredSetup: Codable, CaseIterable {
    case emailVerify
    case bvnLinked
    case phoneVerify
    case accountLinked
    case cardLinked
    
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    var verified: Bool {
        return auth.data.completedKyc!.contains(self)
    }
    
    var title: String {
        switch self {
        case .emailVerify:
            return "Verify email"
        case .bvnLinked:
            return "Link BVN"
        case .phoneVerify:
            return "Verify Phone"
        case .cardLinked:
            return "Link card"
        case .accountLinked:
            return "Link bank"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .emailVerify:
            return UIImage(named: "envelope")!
        case .bvnLinked:
            return UIImage(named: "barcode")!
        case .phoneVerify:
            return UIImage(named: "phone")!
        case .cardLinked:
            return UIImage(named: "card")!
        case .accountLinked:
            return UIImage(named: "bank")!
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(String.self, forKey: .rawValue)
        switch rawValue {
        case "emailVerify":
            self = .emailVerify
        case "phoneVerify":
            self = .phoneVerify
        case "bvnLinked":
            self = .bvnLinked
        case "accountLinked":
            self = .accountLinked
        case "cardLinked":
            self = .cardLinked
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .emailVerify:
            try container.encode("emailVerify", forKey: .rawValue)
        case .phoneVerify:
            try container.encode("phoneVerify", forKey: .rawValue)
        case .bvnLinked:
            try container.encode("bvnLinked", forKey: .rawValue)
        case .cardLinked:
            try container.encode("cardLinked", forKey: .rawValue)
        case .accountLinked:
            try container.encode("accountLinked", forKey: .rawValue)
        }
    }
}
