//
//  Enums.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/8/21.
//

import Foundation


enum ActiveView {
    case splash
    case walkthrough
    case landing
    case register
    case login
    case otp
    case newpin
    case pinset
    case home
    case profile
    case forgotPassword
    case myProfile
}


enum ReceivePaymentPaymentActiveView {
    
    case scan
    case requestPayment
    case paymentResponse(response : Int) // 0 for failure , 1 for success
}

enum MenuItemType {
    case header1
    case header2
}

enum ResponseMessage {
    
    case noInternerConnection
    case serverError(operation: String)
    case wrongFieldentry(field : String)
    
    var message : String{
        switch self{
            case .noInternerConnection : 
                return "Internet connection current not unavailable"
            case .serverError(let operation):
                return "Having Difficulties in \(operation)"
            case .wrongFieldentry(let field):
                return "Incorrect \(field)"
        }
    }
}

enum NetworkView{
    case loading
    case message(message : String)
    case normal
}

enum WalletPopUpViewActive{
    case createAccount
    case pin
    case dropDown
}

enum WalletListViewType{
    case wallet
    case bank
    case card
}

enum FollowerViewType {
    case search
    case follower
    case following
}

enum WalletActionType{
    case transfer
    case fund
    case receivePayment
    case requestPayment
}
