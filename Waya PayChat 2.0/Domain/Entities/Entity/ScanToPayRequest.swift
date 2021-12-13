//
//  ScanToPayRequest.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 08/06/2021.
//

import Foundation

struct ScanToPayRequest: Codable {
    var email: String
    var firstName: String
    var lastName: String
    var id: Int
    var amount: Int
    var description: String?
    
    enum CodingKeys: String, CodingKey {
        case email, firstName, lastName, id, amount, description
    }
    
    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        email = try values.decode(String.self, forKey: .email)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        id = try values.decode(Int.self, forKey: .id)
        amount = try values.decode(Int.self, forKey: .amount)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
}
