//
//  Codable+Extension.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 18/05/2021.
//

import Foundation


extension Encodable {
    var dictionary: [String: Any]? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).map { $0 as? [String: Any] }!
    }
    
    var jsonData: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.keyEncodingStrategy = .useDefaultKeys
        guard let data = try? encoder.encode(self) else { return nil }
        return data
    }
}


extension Dictionary {
    func customCodableObject<T: Codable>(type: T.Type) throws -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.fragmentsAllowed, .prettyPrinted]) else {
            return nil
        }
        let decoder = JSONDecoder()
        guard let obj = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        return obj
    }
}


extension KeyedDecodingContainer {
    func decode(_ type: Decimal.Type, forKey key: K) throws -> Decimal {
        
        do {
            let stringValue = try decode(String.self, forKey: key)
            guard let decimalValue = Decimal(string: stringValue) else {
                let context = DecodingError.Context(codingPath: [key], debugDescription: "The key \(key) couldn't be converted to a Decimal value from string")
                throw DecodingError.typeMismatch(type, context)
            }
            return decimalValue
        } catch {
            do {
                let intValue = try decode(Double.self, forKey: key)
                let stringValue = String(intValue)
                guard let decimalValue = Decimal(string: stringValue) else {
                    let context = DecodingError.Context(codingPath: [key], debugDescription: "The key \(key) couldn't be converted to a Decimal value from double")
                    throw DecodingError.typeMismatch(type, context)
                }
                return decimalValue
            } catch {
                let context = DecodingError.Context(codingPath: [key], debugDescription: "The key \(key) couldn't be converted to a Decimal value at all")
                throw DecodingError.typeMismatch(type, context)
            }
        }
    }
}
