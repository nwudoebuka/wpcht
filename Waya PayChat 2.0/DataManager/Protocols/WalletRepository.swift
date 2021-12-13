//
//  CardRepository.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 2/5/21.
//

import Foundation


protocol WalletRepository {
    
    func addBankAccount(addBankAccountReq: AddBankRequest, completion: @escaping Handler)
    
    func deleteBankAccount(accountNo : String, completion: @escaping Handler)
    
    func getAllBanks(completion: @escaping Handler)
    
    func getUserBankAccount<T: Codable>(completion: @escaping (_ data: T?, _ error: String?) -> Void)
    
    func resolveAccountNumber(resolveAccountRequest: ResolveAccountRequest,
                              completion: @escaping Handler)
    
    func addCard(addCardRequest: AddCardRequest, completion: @escaping Handler)
    func submitCardPhone(request: SubmitPhoneRequest, completion: @escaping Handler)
    
    
    func deleteBankCard(cardNumber: String, completion: @escaping Handler)
    
    func getUserBankCard(userId : String,
                         completion: @escaping Handler)
    
    func getUserWalletCard(
                         completion: @escaping Handler)
    
    func createWallet(completion: @escaping Handler)
    
    func setDefaultWallet(oldAccountNumber : String, newAccountNumber: String, completion: @escaping Handler)
    
    func chargeCard(chargeCardRequest : ChargeCardRequest, completion: @escaping Handler)
    
    func deleteContactRequest(id : Int, completion : @escaping Handler)
    
    func findAllContact(completion : @escaping Handler)
    
    func getByContactAccountByPhoneNumber(phoneNumber : String, completion : @escaping Handler)
    
    func sendMoneyToContact(sendMoneyToPhoneRequest: SendMoneyToPhoneRequest, completion : @escaping Handler)
    
    func sendMoneyToEmail(email: String, sendMoneyToEmailRequest : SendMoneyToEmailRequest, completion : @escaping Handler)
    
    func sendMoneyToWayaID(sendMoneyToIDRequest : SendMoneyToIDRequest, completion: @escaping Handler)
    
    func filterContact(filterContactRequest : FilterContactRequest, completion: @escaping Handler)
    
    func verifyCard(request: VerifyCardRequest, completion: @escaping Handler)
    
    func getUserVirtualAccount(completion: @escaping Handler)
    
    func chargeBankAccount(request: ChargeBankRequest, completion: @escaping Handler)
    
    func getChargeAbleBanks(completion: @escaping Handler)
    
    func withdrawToBank(request: WithdrawalRequest, completion: @escaping Handler)

    func getWalletHistory(accountNo: String,completion: @escaping Handler)
    
    func getBankBeneficiaries(completion: @escaping Handler)
    func saveBeneficiary(account: BankBeneficiary, completion: @escaping Handler)

}
