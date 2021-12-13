//
//  AuthViewModelProtocol.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/22/21.
//

import Foundation

protocol AuthViewModel {
    
    var loginRequest: LoginRequest { get set }
    
    func createAccount(completion: ((String) -> ())?)
    func createAccountPin(createAccountPinRequest: CreateAccountPinRequest, completion: (() -> ())?)
    func login() -> Void
    
    func resetPassword(completion: @escaping Handler)
    func changePassword(completion: @escaping Handler)
    func requestResetPassword(phoneOrEmail: String, channel: ForgotOTPChannel,  completion: @escaping Handler)
    func requestChangePassword(phoneOrEmail: String, channel: ForgotOTPChannel, completion: @escaping Handler)
    
    
    func resendAuthOTP(phoneOrEmail: String?, channel: ForgotOTPChannel, completion: @escaping Handler)
//    func verifyEmail(verifyEmailRequest : VerifyEmailRequest, completion: @escaping Handler)
    func verifyEmailOrPhone(otp: String, channel: ForgotOTPChannel, completion: @escaping Handler)
    func verifyOtp(verifyOtpRequest : VerifyOtpRequest, completion : @escaping Handler)   
    func resendTokenSignup(phoneOrEmail: String, completion: @escaping Handler)
    
    func getMyLoginHistory(token: String, completion : @escaping Handler)
    
    func getMyLastLoginHistory(token: String, completion : @escaping Handler)
    
    func saveLogInHistory(loginHistoryRequest : LoginRequestHistory , completion: @escaping Handler)
    
    func validateUserPin(pin: String)
    
    func requestPinChange(channel: ForgotOTPChannel, completion: @escaping Handler)
    func requestCreatePin(channel: ForgotOTPChannel, completion: @escaping Handler)
    func requestResetPin(channel: ForgotOTPChannel, completion: @escaping Handler)
    func resetUserPin(request: ResetPinRequest)
}
