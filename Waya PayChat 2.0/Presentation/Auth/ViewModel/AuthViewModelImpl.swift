//
//  AuthViewModel.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/22/21.
//

import Foundation
import Signals

final  class AuthViewModelImpl {
    
    var createAccountRequest: CreateAccountRequest!
    var passwordResetRequest: ResetPasswordRequest!
    var changePasswordRequest: ChangePasswordRequest!
    
    var loginRequest: LoginRequest = LoginRequest(admin: false, emailOrPhoneNumber: "", password: "")
    var resendOTPChannel: (emailOrPhone: String, channel: ForgotOTPChannel)!
    var phoneNumber = ""{
        didSet {
            let filtered = phoneNumber.filter{ $0.isNumber}
            
            if phoneNumber != filtered {
                phoneNumber = filtered
            } 
        }
    }
    var forgotPasswordRequest = ""
    
    var authRepo : AuthRepository
    var serviceLane: [String] = [String]()
    
    /*
     This event fires on login completion
     Returns:
        - status: true/false (true if success)
        - detour: Pinverify (user hasn't created an account pin yet)/ EmailVerify(user has not verified their phone number)
        - error: error message if any
    */
    var loginComplete: Signal = Signal<(Bool, Detour?, String?)>()
    
    /*
     This event fires on registration completion
     Returns:
        - status: true/false (true if success
        - error: error message if any
    */
    var registerComplete = Signal<(Bool, String?)>()
    
    /*
     This event fires on pin setup/change completion
     Returns:
        - status: true/false (true if success
        - error: error message if any
    */
    let pinSetupComplete = Signal<(Bool, String?)>()
    
    /*
     This event fires on pin validation completion
     Returns:
        - status: true/false (true if success
        - error: This is either the error returned from the server or a device level error such as validation failures or network errors
    */
    let pinVerified = Signal<(Bool, String?)>()
    
    /*
     This event fires on profile load completion
     Returns:
        - status: true/false (true if success
        - error: This is either the error returned from the server or a device level error such as validation failures or network errors
    */
    let profileLoaded = Signal<()>()
    
    var wayagramViewModel = WayagramViewModelImpl()
    let userDefault = UserDefaults.standard
    
    /*
     When a user is logging in, we might need to present them a screen
     to create a new pin or verify their account if they had an abandoned
     registration process.
     Returns:
        - verify: show account verification view
        - pin: show pin creation view
     TODO:
        - refactor to handle corporate accounts who haven't taken photos of their business.
    */
    enum Detour {
        case verify
        case pin
    }
    
    // parallel running code tends to fire multiple times in swift. we lock each thread until one request passes
    var auth_process = false
    var wayagram_process = false
    
    init(){
        self.authRepo = AuthRepositoryImpl()
    }
    
    
}

extension AuthViewModelImpl : AuthViewModel{
    
    // MARK: Registration
    func createAccount(completion: ((String) -> Void)? = nil) {
        self.authRepo.createAccount(createAccountRequest: createAccountRequest) { (result) in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.registerComplete => (true, nil)
                }
                
            case .failure(let error):
                self.registerComplete => (false, error.localizedDescription)
            }
        }
    }
    
    func loadBusinessTypes(completion: @escaping Handler) {
        authRepo.getBusinessTypes() { (result, error) in
            if let results = result {
                completion(.success(results))
            } else {
                completion(.failure(.custom(message: error!)))
            }
        }
    }
    
    
    func login() {
        guard auth_process == false else {
            return
        }
        auth_process = true
        authRepo.login(loginRequest: loginRequest) { (result) in
            switch result {
                case .success(let response):
                    if let login_response = response as? Response<LoginResponse>, let data = login_response.data {
                        auth.data.userId = data.user.id
                        auth.data.token = data.token
                        
                        if login_response.status == true {
                            self.loginLoadUserProfile(id: data.user.id)
                        } else {
                            guard data.user.isActive == true else {
                                self.loginComplete => (false, Detour.verify, login_response.message!)
                                return
                            }
                            self.loginComplete => (false, nil, login_response.message!)
                        }
                    } else {
                        self.auth_process = false
                    }
                case .failure(let errMessage):
                    self.auth_process = false
                    self.loginComplete => (false, nil, errMessage.localizedDescription)
            }
        }
    }
    
    private func loginLoadUserProfile(id: Int) {
        
        authRepo.getUserProfile { [weak self] (result) in
            self?.auth_process = false
            switch result {
            case .success(let response):
                guard let profile = response as? UserProfile else {
                    return
                }
                auth.data.profile = profile
                let detour: Detour? = (profile.pinCreated == false) ? .pin : nil
                
                if !auth.data.completedKyc!.contains(.emailVerify) && profile.emailVerified == true {
                    auth.data.completedKyc?.append(.emailVerify)
                }
                
                if !auth.data.completedKyc!.contains(.phoneVerify) && profile.phoneVerified == true {
                    auth.data.completedKyc?.append(.phoneVerify)
                }
                
                self?.loginComplete => (true, detour, nil)
                self?.profileLoaded => ()
            case .failure(let error):
                print("error on login: \(error)")
                self?.loginComplete => (false, nil, nil)
            }
        }
    }
    
    func getUserWayagramProfile(){
        guard wayagram_process == false else  {
            return
        }
        wayagram_process = true
        let id = String(auth.data.userId!)
        wayagramViewModel.getWayagramProfileByUserId(userId: id) { (result) in
            switch result {
            case .success(let profile):
                guard let profile = profile as? WayagramProfile else {
                    return
                }
                auth.data.wayagramProfile = profile
                auth.updateLocalPrefs()
            case .failure(let error):
                print("unable to get wayagram profile: \(error.localizedDescription)")
            }
            
            self.wayagram_process = false
            self.auth_process = false
        }
    }
    
    func resendTokenSignup(phoneOrEmail: String, completion: @escaping Handler) {
        guard serviceLane.contains("resendTokenSignup") == false else {
            return
        }
        serviceLane.append("resendTokenSignup")
        authRepo.resendTokenSignup(phoneOrEmail: phoneOrEmail) { (result) in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func resendAuthOTP(phoneOrEmail: String?, channel: ForgotOTPChannel, completion: @escaping Handler) {
        guard serviceLane.contains("resendAuthOTP") == false else {
            return
        }
        serviceLane.append("resendAuthOTP")
        authRepo.resendAuthOTP(phoneOrEmail: phoneOrEmail, channel: channel) { (result) in
            switch result {
            case .success(_):
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
            self.serviceLane.removeAll(where: { $0 == "resendAuthOTP" })
        }
    }
    
    func verifyEmailOrPhone(otp: String, channel: ForgotOTPChannel, completion: @escaping Handler) {
        guard serviceLane.contains("verifyEmailOrPhone") == false else {
            return
        }
        serviceLane.append("verifyEmailOrPhone")
        authRepo.verifyEmailOrPhone(otp: otp, channel: channel) { (result) in
            switch result {
            case .success(_):
                switch channel {
                case .email:
                    if let kyc = auth.data.completedKyc, !kyc.contains(.emailVerify) {
                        auth.data.completedKyc!.append(.emailVerify)
                    }
                case .phone:
                    if let kyc = auth.data.completedKyc, !kyc.contains(.phoneVerify) {
                        auth.data.completedKyc!.append(.phoneVerify)
                    }
                }
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
            self.serviceLane.removeAll(where: { $0 == "verifyEmailOrPhone" })
        }
    }
    
    
    func verifyOtp(verifyOtpRequest: VerifyOtpRequest, completion: @escaping Handler) {
        guard serviceLane.contains("verifyOtp") == false else {
            return
        }
        serviceLane.append("verifyOtp")
        authRepo.verifyOtp(verifyOtpRequest: verifyOtpRequest) { (result) in
            switch result{
                case .success(let response):
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    completion(.failure(.custom(message: errMessage)))
            }
            self.serviceLane.removeAll(where: { $0 == "verifyOtp" })
        }
    }
    
    func getMyLoginHistory(token: String, completion : @escaping Handler){
        authRepo.getMyLoginHistory(token: token) { (result) in
            switch result{
                case .success(let result):
                    completion(.success(result))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }
            
        }
        
    }
    
    func getMyLastLoginHistory(token: String, completion : @escaping Handler){
        authRepo.getMyLoginHistory(token: token) { (result) in
            switch result{
                case .success(let result):
                    completion(.success(result))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }

        }
    }
    
    func saveLogInHistory(loginHistoryRequest : LoginRequestHistory , completion: @escaping Handler){
        
        authRepo.saveLogInHistory(loginHistoryRequest: loginHistoryRequest) { (result) in
            switch result{
                case .success(let result):
                    print("the get login history \(result)")
                    completion(.success(result))
                case .failure(.custom(let message)):
                    completion(.failure(.custom(message: message)))
            }

        }
    }
    
    //MARK: PIN Functions
    func createAccountPin(createAccountPinRequest: CreateAccountPinRequest, completion: (() -> Void)? = nil) {
        authRepo.createAccountPin(createAccountPin: createAccountPinRequest) { (result) in
            switch result{
                case .success(let response):
                    self.pinSetupComplete => (true, (response as! String))
                    completion?()
                case .failure(.custom(let errMessage)):
                    self.pinSetupComplete => (false, errMessage)
                    completion?()
            }
        }
    }
    
    func validateUserPin(pin: String){
        authRepo.validateUserPin(pin: pin) { (result) in
            switch result {
            case .success(_):
                self.pinVerified => (true, nil)
            case .failure(let error):
                self.pinVerified => (false, error.localizedDescription)
            }
        }
    }
    
    func requestCreatePin(channel: ForgotOTPChannel, completion: @escaping Handler) {
        authRepo.requestCreatePin(channel: channel) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func requestPinChange(channel: ForgotOTPChannel, completion: @escaping Handler) {
        authRepo.requestPinChange(channel: channel) { (result) in
            switch result {
            case .success(let otp):
                completion(.success(otp))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func requestResetPin(channel: ForgotOTPChannel, completion: @escaping Handler) {
        authRepo.requestResetPin(channel: channel) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response as! String))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func resetUserPin(request: ResetPinRequest) {
        authRepo.resetUserPin(request: request) { (result) in
            switch result {
            case .success(let response):
                self.pinSetupComplete => (true, response as? String)
            case .failure(let error):
                self.pinSetupComplete => (false, error.localizedDescription)
            }
        }
    }
    
    func changeUserPin(changeRequest: ChangePinRequest) {
        authRepo.changeUserPin(changeRequest: changeRequest) { (result) in
            switch result {
            case .success(let response):
                self.pinSetupComplete => (true, response as? String)
            case .failure(let error):
                self.pinSetupComplete => (false, error.localizedDescription)
            }
        }
    }
    
    
    // MARK: PASSWORD FUNCTIONS
    func requestResetPassword(phoneOrEmail: String, channel: ForgotOTPChannel, completion: @escaping Handler) {
        authRepo.requestResetPassword(phoneOrEmail: phoneOrEmail, channel: channel) { (result) in
            switch result {
            case .success(_):
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func requestChangePassword(phoneOrEmail: String, channel: ForgotOTPChannel, completion: @escaping Handler) {
        authRepo.requestChangePassword(phoneOrEmail: phoneOrEmail, channel: channel) { (result) in
            switch result {
            case .success(_):
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func changePassword(completion: @escaping Handler) {
        authRepo.changePassword(changePasswordRequest: changePasswordRequest) { (result) in
            switch result {
            case .success(_):
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func resetPassword(completion: @escaping Handler) {
    authRepo.resetPassword(resetPasswordRequest: passwordResetRequest) { (result) in
           switch result{
               case .success(let response):
                   completion(.success(response))
               case .failure(let errMessage):
                completion(.failure(.custom(message: errMessage.localizedDescription)))

           }
       }
   }
    
    func deleteUserAccount(completion: @escaping Handler) {
        authRepo.deleteUserAccount(userId: String(auth.data.userId!), completion: { (result) in
            switch result {
            case .success(let message):
                completion(.success(message))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        })
    }
}
