//
//  AuthenticationService.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 21/07/2021.
//

import Foundation
import Alamofire

enum Auth: Microservice {
    static let baseURL = "http://68.183.60.114:8059/api/v1/"
    
    case createAccount(AccountType)
    case createAccountPin
    case login
    case verifyOtp
    case resendAuthOTP(String)
    case resendTokenSignup(emailOrPhone: String)
    case verifyPhoneOrEmail(ForgotOTPChannel)
    case changeUserPin
    case requestPinChange(ForgotOTPChannel)
    case requestCreatePin(ForgotOTPChannel)
    case requestPinReset(ForgotOTPChannel)
    case validatePin(pin: String)
    case resetUserPin
    case resetPassword
    case changePassword
    case requestPasswordReset(ForgotOTPChannel)
    case requestPasswordChange(ForgotOTPChannel)
    
    case saveUserLoginHistory
    case getMyLoginHistory
    case getMyLastLoginHistory
    
    case findAllBusinessTypes
    
    case getUserInfoByEmail(email: String)
    case getUserInfoByPhone(phone: String)
    case getUserPersonalProfile(userId: String)
    case updateUserProfile(userId: String, type: AccountType)
    
    case tokenValidate
    
    case deleteUserAccount(id: String)
    
    var stringValue: String {
        switch self {
        case .createAccount(let type):
            let dir: String = (type == .corporate) ? "auth/create-corporate" : "auth/create"
            return Auth.baseURL +  dir
        case .createAccountPin:
            return Auth.baseURL + "pin/create-pin"
        case .login:
            return Auth.baseURL + "auth/login"
        case .verifyOtp:
            return Auth.baseURL + "auth/verify-otp"
        case .resendAuthOTP(let phoneOrEmail):
            if phoneOrEmail.isNumeric() || phoneOrEmail.starts(with: "+") {
                let trimPhone = (phoneOrEmail.starts(with: "+") == true) ? phoneOrEmail.substring(1) : phoneOrEmail
                return Auth.baseURL + "auth/resend-otp/\(trimPhone)"
            } else {
                guard let mail = phoneOrEmail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    return ""
                }
                return Auth.baseURL + "auth/resend-otp-mail/\(mail)"
            }
        case .resendTokenSignup(let phoneOrEmail):
            if phoneOrEmail.isNumeric() || phoneOrEmail.starts(with: "+") {
                let trimPhone = (phoneOrEmail.starts(with: "+") == true) ? phoneOrEmail.substring(1) : phoneOrEmail
                return Auth.baseURL + "auth/resend-otp/signup/\(trimPhone)"
            } else {
                guard let mail = phoneOrEmail.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                    return ""
                }
                return Auth.baseURL + "auth/resend-otp/signup/\(mail)"
            }
        case .verifyPhoneOrEmail(let channel):
            let end = (channel == .phone) ? "verify-phone" : "verify-email"
            return Auth.baseURL + "auth/\(end)"
        case .changeUserPin:
            return Auth.baseURL + "pin/change-pin"
        case .requestPinChange(let channel):
            let end = (channel == .phone) ? "byPhone" : "byEmail"
            return Auth.baseURL + "pin/change-pin/\(end)"
        case .requestCreatePin(let channel):
            let end = (channel == .phone) ? "byPhone" : "byEmail"
            return Auth.baseURL + "pin/create-pin/\(end)"
        case .requestPinReset(let channel):
            let end = (channel == .phone) ? "byPhone" : "byEmail"
            return  Auth.baseURL + "pin/forgot-pin/\(end)"
        case .validatePin(let pin):
            return Auth.baseURL + "pin/validate-pin/\(pin)"
            
        case .resetUserPin:
            return Auth.baseURL + "pin/forgot-pin"
        case .resetPassword:
            return Auth.baseURL + "password/forgot-password"
        case .changePassword:
            return Auth.baseURL + "password/change-password"
        case .requestPasswordReset(let channel):
            let end = (channel == .phone) ? "byPhone" : "byEmail"
            return Auth.baseURL + "password/forgot-password/\(end)"
        case .requestPasswordChange(let channel):
            let end = (channel == .phone) ? "byPhone" : "byEmail"
            return Auth.baseURL + "password/change-password/\(end)"
        case .findAllBusinessTypes:
            return Auth.baseURL + "business/type/find/all"
        case .saveUserLoginHistory:
            return Auth.baseURL + "history/save"
        case .getMyLoginHistory:
            return Auth.baseURL  + "history/my-history"
        case .getMyLastLoginHistory :
            return Auth.baseURL + "history/my-last-login"
        case .getUserInfoByEmail(let email):
            return Auth.baseURL + "user/email/\(email)"
        case .getUserInfoByPhone(let phone):
            let trimPhone = (phone.starts(with: "+") == true) ? phone.substring(1) : phone
            return Auth.baseURL + "user/phone/\(trimPhone)"
        case .getUserPersonalProfile(let userId):
            return Auth.baseURL + "user/\(userId)"
        case .tokenValidate:
            return Auth.baseURL + "auth/validate-user"
        case .updateUserProfile(let userId, let type):
            let path = (type == .personal) ? "update-personal-profile" : "update-corporate-profile"
            return Auth.baseURL + "profile/\(path)/\(userId)"
        case .deleteUserAccount(let id):
            return Auth.baseURL + "user/delete/\(id)"
        }
    }
    
    var url : URL? {
        guard let _url = URL(string: self.stringValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return nil
        }
        return _url
    }
}
