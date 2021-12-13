//
//  TransactionRepositoryImpl.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 31/08/2021.
//


import Foundation

class TransactionRepositoryImpl {
    
    static let shared : TransactionRepository = TransactionRepositoryImpl()

    
    init(){}
}

extension TransactionRepositoryImpl : TransactionRepository{
    func getTransactions(accountNumber accountNo: String,completion: @escaping Handler) {
        let endpoint: WayaClient = .card(.getTransactionHistory(accountNumber: accountNo))
        let request = NetworkRequest(endpoint: endpoint, method: .get, encoding: .url, body: [:])
        
        Request.shared.fetch(request) { (status, _ response: Response<[TransactionResponse]>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "Unable to get transaction history")))
                    return
                }
                if response.status == true {
                    print("txn history success is \(response.data)")
                    completion(.success(response.data))
                } else {
                    completion(.failure(.custom(message: "Unable to get transaction history \(response.message!)")))
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
   
}
