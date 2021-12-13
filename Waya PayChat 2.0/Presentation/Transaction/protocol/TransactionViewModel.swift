//
//  TransactionViewModel.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 31/08/2021.
//

import Foundation


protocol TransactionViewModel {
    
    func getTransactions(accountNumber: String, completion: Handler?)
    
 
}
