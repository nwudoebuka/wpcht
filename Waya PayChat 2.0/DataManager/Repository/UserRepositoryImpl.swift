//
//  UserRepositoryImpl.swift
//  Waya PayChat 2.0
//
//  Created by Home on 1/25/21.
//

import Foundation

class UserRepositoryImpl {
    
    static let shared : UserRepository  =  UserRepositoryImpl()
    
    private init(){}
}


extension UserRepositoryImpl : UserRepository{
   
    func getAllUserFromRedis(completion: @escaping Handler) {
        
//        guard let url = WayaClient.getAllUser.url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: SaveUserRequest.self) { (response, error) in
//            if let response = response {
//                if response.id == 0{
//                    completion(.success(response))
//                } else {
//                    completion(.failure(.custom(message: response.surname)))
//                }
//            } else {
//                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//            }
//
//        }
    }
    
    // MARK: TODO: Refactor this
//    func saveUserToRedis(saveUserRequest: SaveUserRequest, completion: @escaping Handler) {

//        let request = NetworkRequest(endpoint: .saveUser, method: .post, encoding: .json, body: saveUserRequest.dictionary!)
//
//        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
//
//        }
//        guard let url = WayaClient.saveUser.url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//        NetworkManager.instance.initPOSTRequest(url: url, responseType: SaveUserRequest.self, body: saveUserRequest) { (response, error) in
//
//            print("Authrepositoty : create account , response \(response)")
//            print("Authrepositoty : create account, response \(error)")
//
//            if let response = response {
//                if response.id == 0{
//                    completion(.success(response))
//                } else {
//                    completion(.failure(.custom(message: response.surname)))
//                }
//            } else {
//                completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//            }
//
//        }
//    }
    
    func getUserDetailsAndRolesByID(id: String, completion: @escaping Handler) {
//        print("UserRepositoryIMpl : get user by role \(id)")
//        guard let url = WayaClient.getUserDetailAndRoleByID(id: id).url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//        
//        NetworkManager.instance.initialGETRequest(url: url, responseType: SaveUserRequest.self) { (response, error) in
////            print("Authrepositoty : create account , response \(response)")
//        }
        
    }
    
    func getUserDetailByEmail(email: String , completion: @escaping Handler) {
//        guard let url = WayaClient.getUserDetailAndRoleByEmail(email: email).url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: SaveUserRequest.self) { (response, error) in
////            print("Authrepositoty : create account , response \(response)")
//        }
//
    }
    
    func getMyUserInfo(completion : @escaping Handler){
//        guard let url = WayaClient.getSelfUserInfo.url else {
//            completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttpResponse<String>.self) { (response, error) in
//            print("Authrepositoty : create account , response \(response)")
//        }
    }
}
