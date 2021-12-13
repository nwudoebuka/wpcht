//
//  AppSettings.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 28/06/2021.
//

import Foundation

enum DefaultView: String, Codable {
    case wayapay
    case wayachat
    case wayagram
    
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
        case "wayapay":
            self = .wayapay
        case "wayachat":
            self = .wayachat
        case "wayagram":
            self = .wayagram
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .wayapay:
            try container.encode("wayapay", forKey: .rawValue)
        case .wayachat:
            try container.encode("wayachat", forKey: .rawValue)
        case .wayagram:
            try container.encode("wayagram", forKey: .rawValue)
        }
    }
}

struct Prefs: Codable {
    var defaultView: DefaultView?
    var font_size: FontSize
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Key.self)
//        switch self {
//        case .emailVerify:
//            try container.encode("emailVerify", forKey: .rawValue)
//        case .phoneVerify:
//            try container.encode("phoneVerify", forKey: .rawValue)
//        case .bvnLinked:
//            try container.encode("bvnLinked", forKey: .rawValue)
//        case .cardLinked:
//            try container.encode("cardLinked", forKey: .rawValue)
//        case .accountLinked:
//            try container.encode("accountLinked", forKey: .rawValue)
//        }
//    }
}

enum FontSize: Int, Codable, CaseIterable {
    case small = 10
    case medium = 14
    case large = 18
    
    var stringValue: String {
        switch self {
        case .large:
            return "Large"
        case .medium:
            return "Medium"
        case .small:
            return "Small"
        }
    }
}
