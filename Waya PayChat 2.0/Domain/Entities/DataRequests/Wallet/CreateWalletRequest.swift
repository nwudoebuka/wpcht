//
//  CreateWalletRequest.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/12/21.
//

struct CreateWalletRequest : Codable {
    var userId : Int = 0
    var productId: Int = 0
}

struct CreateWalletUserRequest : Codable{
    var corporate : Bool = false
    var id : Int = 0
    var userId : Int = 0
    
    
//    "officeId": 45,
//    "clientId": 0,
//    "savingsId": 1,
//    "resourceId": 51
}

struct SendMoneyToIDRequest : Codable{
    var amount : Double
    var fromId: Int
    var toId: Int
}

struct SendMoneyToPhoneRequest : Codable{
    let amount : Int
    let phoneNumber: String
}


struct FilterContactRequest: Codable {
    let contacts: [Contact]
}
