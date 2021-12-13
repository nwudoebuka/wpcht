//
//  CardViewModelProtocol.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/8/21.
//

import Foundation


protocol WalletViewModel {
    
    func addBankAccount(addBankAccountReq: AddBankRequest, completion: @escaping Handler)
    
    func deleteBankAccount(accountNo : String, completion: @escaping Handler)
    
    func getAllBanks(completion: @escaping Handler)
    
//    func getUserBankAccount<T: Codable>(userId : String, type: T, completion: @escaping Handler)
    func getUserBankAccounts<T: Codable>(completion: @escaping (_ data: T?, _ error: String?) -> Void) -> Void
    func chargeBankAccount(completion: @escaping Handler) -> Void
    
    func resolveAccountNumber(resolveAccountRequest: ResolveAccountRequest,
                              completion: @escaping Handler)
    
    func addCard(addCardRequest: AddCardRequest, completion: @escaping Handler)
    func submitCardPhone(request: SubmitPhoneRequest, completion: @escaping Handler)
    
    func deleteBankCard(cardNumber: String, completion: @escaping Handler)
    
    func getUserBankCard(userId : String, completion: @escaping Handler)
 
    func createWallet(completion: @escaping Handler)
        
    func setDefaultWallet(accountNumber : String, completion : @escaping  Handler)
    
    func chargeCard(completion: @escaping Handler)
    
    func deleteContactRequest(id : Int, completion : @escaping Handler)
    
    func findAllContact(completion : @escaping Handler)
    
    func getByContactAccountByPhoneNumber(phoneNumber : String, completion : @escaping Handler)
    
    func sendMoneyToContact(sendMoneyToPhoneRequest: SendMoneyToPhoneRequest, completion : @escaping Handler)
    
    func sendMoneyToEmail(email: String, sendMoneyToEmailRequest : SendMoneyToEmailRequest, completion : @escaping Handler)
    
    func sendMoneyToWayaID(sendMoneyToIDRequest : SendMoneyToIDRequest, completion: @escaping Handler)
    
    func filterContact(filterContactRequest : FilterContactRequest, completion: @escaping Handler)
        
    func getChargeableBanks(completion: @escaping Handler)
    
    func withdrawToBank(request: WithdrawalRequest, completion: @escaping Handler)
}
