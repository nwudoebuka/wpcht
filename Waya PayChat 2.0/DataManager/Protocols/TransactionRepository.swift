//
//  TransactionRepository.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 31/08/2021.
//

import Foundation


protocol TransactionRepository {
    
    func getTransactions(accountNumber: String, completion: @escaping Handler)
    
}
