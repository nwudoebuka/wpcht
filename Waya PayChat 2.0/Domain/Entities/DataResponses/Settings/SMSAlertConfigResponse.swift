//
//  SMSAlertConfigResponse.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 23/08/2021.
//

import Foundation

struct SMSAlertConfigResponse: Codable {
    var active: Bool
    var id: String
    var phoneNumber: String
}
