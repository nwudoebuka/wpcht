//
//  CardRepository.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/5/21.
//

import Foundation


protocol WalletRepository {
    
    func addBankAccount(addBankAccountReq: AddBankRequest, completion: @escaping Handler)
    
    func deleteBankAccount(userId: String, accountNo : String, completion: @escaping Handler)
    
    func getBanks(completion: @escaping Handler)
    
    func getUserBankAccount(userId : String, 
                            completion: @escaping Handler)
    
    func resolveAccountNumber(resolveAccountRequest: ResolveAccountRequest,
                              completion: @escaping Handler)
    
    func addCard(addCardRequest: AddCardRequest,
                 completion: @escaping Handler)
    
    
    func deleteBankCard(userId : String, last4digit: String,
                        completion: @escaping Handler)
    
    func getUserBankCard(userId : String,
                         completion: @escaping Handler)
    
    func getUserWalletCard(userId : String,
                         completion: @escaping Handler)
    
}
