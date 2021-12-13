//
//  ErrorStates.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 27/05/2021.
//

import Foundation

enum TransactionError: Equatable {
    case insufficient_funds
    case wrong_otp
    case bank_verify_failed
    case incorrect_pin
    case error(message: String)
    
    var rawValue: String {
        switch self {
        case .bank_verify_failed:
            return "Couldn't verify your bank details"
        case .wrong_otp:
            return "Wrong OTP"
        case .insufficient_funds:
            return "Insufficient Funds"
        case .incorrect_pin:
            return "Incorrect PIN"
        case .error(_):
            return "Error"
        }
    }
    
    var message: String {
        switch self {
        case .insufficient_funds:
            return "You do not have sufficient funds in your account. Please fund your bank account to continue"
        case .wrong_otp:
            return "The OTP code you entered is invalid"
        case .bank_verify_failed:
            return "Bank details provided could not be verified"
        case .incorrect_pin:
            return "Incorrect PIN entered"
        case .error(let errorMessage):
            return errorMessage
        }
    }
}

enum TransactionSuccess {
    case generic
    case withdrawal
}

enum AlertMode: Equatable {
    case success(TransactionSuccess?)
    case failure(TransactionError?)
    case security
    
    var errorName: String {
        switch self {
        case .success(let success):
            return "Successful"
        case .failure(let error):
            return error?.rawValue ?? "Unsuccessful"
        case .security:
            return ""
        }
    }
}

extension AlertMode {
   
    static func == (lhs: AlertMode, rhs: AlertMode) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhType), .success(let rhType)):
            return lhType == rhType
        case (.failure(let lhType), .failure(let rhType)):
            return lhType == rhType
        case (.security, .success(_)), (.security, .failure(_)),
             (.success(_), .security), (.failure(_), .security),
             (.failure(_), .success(_)), (.success(_), .failure(_)):
            return false
        case (.security, .security):
            return true
        }
    }
    
}
