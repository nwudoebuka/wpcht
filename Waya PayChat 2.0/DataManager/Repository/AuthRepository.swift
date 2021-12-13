//
//  AuthRepository.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/20/21.
//

import Foundation

class AuthRepositoryImpl {
    
    static let shared : AuthRepositoryProtocol = AuthRepositoryImpl()
    
    private init(){}
}

extension AuthRepositoryImpl : AuthRepositoryProtocol{
    func createAccount(createAccountRequest: CreateAccountRequest, completion: @escaping Handler) {
        print("AuthRepositoryProtocol : create account \(createAccountRequest)")
        
        guard let url = WayaClient.EndPoints.createAccount.url else {
            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
            return
        }
        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResponse.self, body: createAccountRequest) { (response, error) in
            
            print("Authrepositoty : create account , response \(response)")
            print("Authrepositoty : create account, response \(error)")   
            
            if let response = response {
                if response.status == true{
                    completion(.success(response.message))
                } else {
                    completion(.failure(.custom(message: response.message)))
                }
            } else {
                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
            }
            
        }
    }
    
    func createAccountPin(createAccountPin: CreateAccountPinRequest, completion: @escaping Handler) {
         print("AuthRepositoryProtocol : createAccountPin \(createAccountPin)")
        
        guard let url = WayaClient.EndPoints.createAccountPin.url else {
            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
            return
        }
        NetworkManager.instance.initPOSTRequestWithToken(url: url, responseType: WayaPayHttpResponse.self, body: createAccountPin) { (response, error) in
            
            print("Authrepositoty : login, response \(response)")
            print("Authrepositoty : login, response \(error)")   
            
            if let response = response {
                if response.status == true{
                    completion(.success(response.message))
                } else {
                    completion(.failure(.custom(message: response.message)))
                }
            } else {
                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
            }
            
        }
    }
    
    func resetPassword(resetPasswordRequest: ResetPasswordRequest, completion: @escaping Handler) {
        print("AuthRepositoryProtocol : resetPasswordRequest \(resetPasswordRequest)")
        
        guard let url = WayaClient.EndPoints.login.url else {
            completion(.failure(.custom(message: "Oops!! Unablw to login \(ResponseMessage.noInternerConnection.message)")))
            return
        }
        NetworkManager.instance.initPOSTRequest(url: url, responseType: WayaPayHttpResponse.self, body: resetPasswordRequest) { (response, error) in
            
            print("Authrepositoty : login, response \(response)")
            print("Authrepositoty : login, response \(error)")   
            
            if let response = response {
                if response.status == true{
                    completion(.success(response.message))
                } else {
                    completion(.failure(.custom(message: response.message)))
                }
            } else {
                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
            }
        }
    }
    

    func login(loginRequest: LoginRequest, completion: @escaping Handler) { 
        print("AuthRepositoryProtocol : login \(loginRequest)")
        
        guard let url = WayaClient.EndPoints.login.url else {
            completion(.failure(.custom(message: "Oops!! Unable to login \(ResponseMessage.noInternerConnection.message)")))
            return
        }
        NetworkManager.instance.initPOSTRequest(url: url, responseType: LoginResponse.self, body: loginRequest) { (response, error) in
            
            print("Authrepositoty : login, response \(response)")
            print("Authrepositoty : login, response \(error)")   
            
            if let response = response {
                if response.code == 0{
                    completion(.success(response))
                } else {
                    completion(.failure(.custom(message: response.message)))
                }
            } else {
                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
            }
            
        }
    }
    
    
}
