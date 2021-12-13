//
//  ContactsResponse.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 02/06/2021.
//

import Foundation

struct FindAllContactsResponse: Codable {
    var id: Int
    var phoneNumber: String
    var dateCreated: String
    var collected: Bool
    var contactAmount: [ContactAmount]
}

struct ContactAmountResponse: Codable {
    let collected: Bool
    let contactAmount: [ContactAmount]
    let dateCreated: String
    let id: Int
    let phoneNumber: String
}

struct ContactAmount: Codable {
    let amount, contactAccountID: Int
    let dateCreated: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case amount
        case contactAccountID = "contactAccountId"
        case dateCreated, id
    }
}
