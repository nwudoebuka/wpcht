//
//  TransactionViewmodelimpl.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 31/08/2021.
//

import Foundation
import Signals

final class TransactionViewModelImpl: TransactionViewModel {
  
  
    var txnRepo : TransactionRepository
    var txnResponse: [TransactionResponse] {
        return auth.data.txnHistory ?? [TransactionResponse]()
    }

    init(txnRepo: TransactionRepository = TransactionRepositoryImpl.shared){
        self.txnRepo = txnRepo
    }


    func getTransactions(accountNumber: String, completion: Handler?) {
        txnRepo.getTransactions(accountNumber: accountNumber) { (result) in
            switch result {
            case .success(let response):
                if let response = response as? [TransactionResponse] {
                    auth.data.txnHistory = response
                    completion!(result)
                    print("wallet response is \(auth.data.txnHistory)")
                  
                }
            case .failure(let error):
            print("error obtaining transaction: \(error)")
                break
            }
        }
    }
  
}
