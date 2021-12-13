//
//  ChargeAbleBankResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 23/06/2021.
//

import Foundation

struct ChargeAbleBankResponse: Codable {
    var name: String //"ALAT by WEMA",
    var slug: String //"alat-by-wema",
    var code: String //"035A",
    var longcode: String //"035150103",
    var gateway: String //"emandate",
    var pay_with_bank: Bool //true,
    var active: Bool// true,
    var is_deleted: Bool? //null,
    var country: String //"Nigeria",
    var currency: String //"NGN",
    var type: String //"nuban",
    var id: Int // 27,
    var createdAt: String //"2017-11-15T12:21:31.000Z",
    var updatedAt: String // "2021-02-18T14:55:34.000Z
}
