//
//  AuthRepositoryProtocol.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/20/21.
//

import Foundation

protocol AuthRepository {
    
    // MARK: Login
    func login(loginRequest: LoginRequest, completion: @escaping Handler)
    func getMyLoginHistory(token: String, completion : @escaping Handler)
    func getMyLastLoginHistory(token: String, completion : @escaping Handler)
    func saveLogInHistory(loginHistoryRequest : LoginRequestHistory , completion: @escaping Handler)
    func getUserProfile(completion: @escaping Handler)
    
    // MARK: Registration
    func createAccount(createAccountRequest: CreateAccountRequest, completion : @escaping Handler)
    
//    func verifyEmail(verifyEmailRequest : VerifyEmailRequest, completion: @escaping Handler)
    func verifyEmailOrPhone(otp: String, channel: ForgotOTPChannel, completion: @escaping Handler)
    func getBusinessTypes(completion: @escaping ([BusinessType]?, String?) -> Void)
    
    // MARK: PIN Functions
    func createAccountPin(createAccountPin: CreateAccountPinRequest, completion: @escaping Handler)
    func validateUserPin(pin: String, completion: @escaping Handler)
    func changeUserPin(changeRequest: ChangePinRequest, completion: @escaping Handler)
    func requestPinChange(channel: ForgotOTPChannel, completion: @escaping Handler)
    func requestCreatePin(channel: ForgotOTPChannel, completion: @escaping Handler)
    func requestResetPin(channel: ForgotOTPChannel, completion: @escaping Handler)
    func resetUserPin(request: ResetPinRequest, completion: @escaping Handler)
    
//    func getUserLoginHistory(userId : String, completion: @escaping Handler)
//    func getUserLastLoginHistory(userId : String, completion: @escaping Handler)
    
    // MARK: Password functions
    func resetPassword(resetPasswordRequest: ResetPasswordRequest, completion: @escaping Handler)
    func changePassword(changePasswordRequest: ChangePasswordRequest, completion: @escaping Handler)
    func requestResetPassword(phoneOrEmail: String, channel: ForgotOTPChannel, completion: @escaping Handler)
    func requestChangePassword(phoneOrEmail: String, channel: ForgotOTPChannel, completion: @escaping Handler)
    
    
    // MARK: OTP Functions
    func resendAuthOTP(phoneOrEmail: String?, channel: ForgotOTPChannel, completion: @escaping Handler)
    func resendTokenSignup(phoneOrEmail: String, completion: @escaping Handler) // resend otp for signup flow only
    func verifyOtp(verifyOtpRequest : VerifyOtpRequest, completion : @escaping Handler)
    
    func getUserByEmail(email: String, completion: @escaping Handler)
    func getUserByPhone(phone: String, completion: @escaping Handler)
    
    // MARK: Delete Account
    func deleteUserAccount(userId: String, completion: @escaping Handler)
    
}
