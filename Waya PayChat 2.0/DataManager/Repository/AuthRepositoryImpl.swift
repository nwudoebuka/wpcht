//
//  AuthRepository.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/20/21.
//

import Foundation

public class AuthRepositoryImpl: AuthRepository {
    
    func requestCreatePin(channel: ForgotOTPChannel, completion: @escaping Handler) {
        let trimPhone = (auth.data.profile!.phoneNumber.starts(with: "+")) ? auth.data.profile!.phoneNumber.substring(1) : auth.data.profile!.phoneNumber
        let value = (channel == .phone) ? ["phoneNumber" : trimPhone] : ["email" : auth.data.profile!.email]
        let request = NetworkRequest(endpoint: .auth(.requestCreatePin(channel)), method: .get, encoding: .urlJson, body: value)
        
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let message = response?.message else {
                    completion(.success("OK"))
                    return
                }
                completion(.success(message))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func requestPinChange(channel: ForgotOTPChannel, completion: @escaping Handler) {
        let trimPhone = (auth.data.profile!.phoneNumber.starts(with: "+") == true) ? auth.data.profile!.phoneNumber.substring(1) : auth.data.profile!.phoneNumber
        let value = (channel == .phone) ? ["phoneNumber" : trimPhone] : ["email" : auth.data.profile!.email]
        let request = NetworkRequest(endpoint: .auth(.requestPinChange(channel)), method: .get, encoding: .urlJson, body: value)
        
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let message = response?.message else {
                    completion(.success(nil))
                    return
                }
                completion(.success(message))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func requestResetPin(channel: ForgotOTPChannel, completion: @escaping Handler) {
        let trimPhone = (auth.data.profile!.phoneNumber.starts(with: "+") == true) ? auth.data.profile!.phoneNumber.substring(1) : auth.data.profile!.phoneNumber
        let value = (channel == .phone) ? ["phoneNumber" : trimPhone] : ["email" : auth.data.profile!.email]
        
        let request = NetworkRequest(endpoint: .auth(.requestPinReset(channel)), method: .get, encoding: .urlJson, body: value)
        
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(response?.message))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func resetUserPin(request: ResetPinRequest, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .auth(.resetUserPin), method: .post, encoding: .json, body: request.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(response?.message))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getBusinessTypes(completion: @escaping ([BusinessType]?, String?) -> Void) {
        //TODO: Business types endpoint is locked
        let request = NetworkRequest(endpoint: .auth(.findAllBusinessTypes), method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: [BusinessType]?) in
            switch status {
            case .success:
                completion(response, nil)
            case .failed(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func createAccount(createAccountRequest: CreateAccountRequest, completion: @escaping Handler) {
               
        let payload = createAccountRequest.data
        let request = NetworkRequest(endpoint: .auth(.createAccount(createAccountRequest.type)), method: .post, encoding: .json, body: payload)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "error parsing response from server")))
                    return
                }
                if response.status == true {
                    completion(.success(response.message))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func createAccountPin(createAccountPin: CreateAccountPinRequest, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .auth(.createAccountPin), method: .post, encoding: .json, body: createAccountPin.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(response?.message))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    
    // MARK: PASSWORD FUNCTIONS
    func resetPassword(resetPasswordRequest: ResetPasswordRequest, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .auth(.resetPassword), method: .post, encoding: .json, body: resetPasswordRequest.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(nil))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    func changePassword(changePasswordRequest: ChangePasswordRequest, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .auth(.changePassword), method: .post, encoding: .json, body: changePasswordRequest.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
                case .success:
                    completion(.success(nil))
                case .failed(let error):
                    completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    func requestResetPassword(phoneOrEmail: String, channel: ForgotOTPChannel, completion: @escaping Handler) {
        let body: [String: String] = (channel == .phone) ? ["phoneNumber" : phoneOrEmail] : ["email" : phoneOrEmail]
        
        let request = NetworkRequest(endpoint: .auth(.requestPasswordReset(channel)), method: .get, encoding: .urlJson, body: body)
        
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(nil))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
        
    }
    func requestChangePassword(phoneOrEmail: String, channel: ForgotOTPChannel, completion: @escaping Handler){
        let body: [String: String] = (channel == .phone) ? ["phoneNumber" : phoneOrEmail] : ["email" : phoneOrEmail]
        
        let request = NetworkRequest(endpoint: .auth(.requestPasswordChange(channel)), method: .get, encoding: .urlJson, body: body)
        
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(nil))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
        

    func login(loginRequest: LoginRequest, completion: @escaping Handler) {
        
        let request = NetworkRequest(endpoint: .auth(.login), method: .post, encoding: .json, body: loginRequest.dictionary!)
        
        Request.shared.fetch(request) { (status, _ user: Response<LoginResponse>?) in
            switch status {
            case .success:
                completion(.success(user))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func resendTokenSignup(phoneOrEmail: String, completion: @escaping Handler) {
        let param: String
        
        if (phoneOrEmail.starts(with: "+") || phoneOrEmail.isNumeric()) {
            param = phoneOrEmail.substring(1).formatPhoneNumber()
        } else {
            param = phoneOrEmail
        }
        
        let request = NetworkRequest(endpoint: .auth(.resendTokenSignup(emailOrPhone: param)), method: .get, encoding: .urlJson, body: [:])
        
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let message = response?.message else {
                    completion(.success("Sent Successfully"))
                    return
                }
                completion(.success(message))
            case .failed(let error):
               completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func resendAuthOTP(phoneOrEmail: String?, channel: ForgotOTPChannel, completion: @escaping Handler) {
        let endpoint: WayaClient
        if (phoneOrEmail != nil) {
            endpoint = .auth(.resendAuthOTP(phoneOrEmail!))
        } else {
            let trimPhone = (auth.data.profile!.phoneNumber.starts(with: "+") == true) ? auth.data.profile!.phoneNumber.substring(1) : auth.data.profile!.phoneNumber
            let value = (channel == .email) ? auth.data.profile!.email : trimPhone
            endpoint = .auth(.resendAuthOTP(value))
        }
        let request = NetworkRequest(endpoint: endpoint, method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(nil))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func verifyEmailOrPhone(otp: String, channel: ForgotOTPChannel, completion: @escaping Handler) {
        let endpoint: WayaClient = .auth(.verifyPhoneOrEmail(channel))
        let trimPhone = (auth.data.profile!.phoneNumber.starts(with: "+") == true) ? auth.data.profile!.phoneNumber.substring(1) : auth.data.profile!.phoneNumber
        let value = (channel == .email) ? auth.data.profile!.email : trimPhone
        let payload: [String:String] = ["otp" : otp, "phoneOrEmail" : value]
        
        let request = NetworkRequest(endpoint: endpoint, method: .post, encoding: .json, body: payload)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(nil))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func verifyOtp(verifyOtpRequest: VerifyOtpRequest, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .auth(.verifyOtp), method: .post, encoding: .json, body: verifyOtpRequest.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "Unable to connect")))
                    return
                }
                if response.status == true {
                    completion(.success(response))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }

    func getMyLoginHistory(token: String, completion : @escaping Handler){
        let request = NetworkRequest(endpoint: .auth(.getMyLoginHistory), method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "unable to change password")))
                    return
                }
                (response.status == true) ? completion(.success(response)) : completion(.failure(.custom(message: response.message!)))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
        
    func saveLogInHistory(loginHistoryRequest : LoginRequestHistory , completion: @escaping Handler){
        
        let request = NetworkRequest(endpoint: .auth(.saveUserLoginHistory), method: .post, encoding: .json, body: loginHistoryRequest.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<[LoginHistoryResponse]>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "unable to save login history")))
                    return
                }
                (response.status == true) ? completion(.success(response)) : completion(.failure(.custom(message: response.message!)))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getUserLoginHistory(userId : String, completion: @escaping Handler){
//        guard let url = WayaClient.getUserLoginHistroy(userId: userId).url else {
//            completion(.failure(.custom(message: "\(ResponseMessage.serverError(operation: "to Login").message)")))
//            return
//        }
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<[LoginHistoryResponse]>.self) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
    }
    
    func getUserLastLoginHistory(userId : String, completion: @escaping Handler){
//        guard let url = WayaClient.getUserLastLoginHistory(userId: userId).url else {
//            completion(.failure(.custom(message: "\(ResponseMessage.serverError(operation: "to Login").message)")))
//            return
//        }
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<LoginHistoryResponse>.self) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message)))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//        }
    }
    
    func validateUserPin(pin: String, completion: @escaping Handler){
        let request = NetworkRequest(endpoint: .auth(.validatePin(pin: pin)), method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: status.localizedDescription)))
                    return
                }
                if response.status == true{
                    completion(.success(response))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func changeUserPin(changeRequest: ChangePinRequest, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .auth(.changeUserPin), method: .post, encoding: .json, body: changeRequest.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "Invalid response")))
                    return
                }
                if response.status == true {
                    completion(.success(response.message!))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    
    
    func getUserByEmail(email: String, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .auth(.getUserInfoByEmail(email: email)), method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                if let response = response {
                    completion(.success(response))
                } else {
                    completion(.failure(.custom(message: "")))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getUserByPhone(phone: String, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .auth(.getUserInfoByPhone(phone: phone)), method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                if let response = response {
                    completion(.success(response))
                } else {
                    completion(.failure(.custom(message: "")))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getMyLastLoginHistory(token: String, completion: @escaping Handler) {
        
    }
    
    func getUserProfile(completion: @escaping Handler) {
        let request = NetworkRequest(
            endpoint: .auth(.getUserPersonalProfile(userId: String(auth.data.userId!))),
            method: .get,
            encoding: .urlJson,
            body: [:]
        )
        Request.shared.fetch(request) { (status, _ response: Response<UserProfile>?) in
            switch status {
            case .success:
                if let response = response {
                    completion(.success(response.data!))
                } else {
                    completion(.failure(.custom(message: "Failed to load profile")))
                }
            case .failed(let error):
                print("error: \(error)")
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func deleteUserAccount(userId: String, completion: @escaping Handler) {
        let endpoint: WayaClient = .auth(.deleteUserAccount(id: userId))
        let request = NetworkRequest(endpoint: endpoint, method: .delete, encoding: .urlJson, body: [:])
        
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                if let response = response {
                    if response.status == true {
                        completion(.success(response.message!))
                    } else {
                        completion(.failure(.custom(message: response.message!)))
                    }
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
}
