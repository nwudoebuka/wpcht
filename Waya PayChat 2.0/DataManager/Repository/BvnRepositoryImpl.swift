//
//  BvnRepositoryImpl.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/3/21.
//

import Foundation

struct BvnRepositoryImpl {
    
//    private init(){}
}

extension BvnRepositoryImpl : BvnRepository{
    func isBvnLinked(completion: @escaping Handler) {
//        guard let url = WayaClient.isBvnLinkedToAccount.url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "is bvn linked").message)))
//            return
//        }
//
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: SaveUserRequest.self) { (response, error) in
//            print("Authrepositoty : create account , response \(response)")
//        }
        
    }
    
    func linkBvnToAccount(linkBvnRequest: LinkBvnRequest, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .kyc(.linkBvnToAccount), method: .post, encoding: .json, body: linkBvnRequest.dictionary!)
        
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let data = response else {
                    completion(.failure(.custom(message: "No response received")))
                    return
                }
                if data.status == true {
                    completion(.success(data.message!))
                } else {
                    completion(.failure(.custom(message: data.message!)))
                }
                
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func verifyBvnToAccount(otp: String, user: String, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .kyc(.verifyBvn(otp: otp, user: user)), method: .post, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "No response received")))
                    return
                }
                if response.status == true {
                    completion(.success(nil))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func resendOTP(user: String, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .kyc(.resendOTP(user: user)), method: .post, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "No response received")))
                    return
                }
                if response.status == true {
                    completion(.success(nil))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
        
    }
    
    
}
