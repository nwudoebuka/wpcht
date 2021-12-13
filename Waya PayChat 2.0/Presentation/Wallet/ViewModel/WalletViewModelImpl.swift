//
//  CardViewModel.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/8/21.
//

import Foundation
import Signals

final class WalletViewModelImpl: WalletViewModel {
    
    var cardRepo : WalletRepository
    
    var addBankRequests = [AddBankRequest]()
    var cardResponse: [CardResponse] {
        return auth.data.accounts?.cards ?? [CardResponse]()
    }
    var bankResponse: [BankResponse] {
        return auth.data.accounts?.banks ?? [BankResponse]()
    }
    var userWalletResponse: [UserWalletResponse] {
        return auth.data.accounts?.wallets ?? [UserWalletResponse]()
    }
    var userWalletHistory: TransactionWalletData? {
        return auth.data.walletHistory
    }
    
    private var loadingWallets = false

    var createWalletUserRequest = CreateWalletUserRequest()
    
    var addBankAccountReq : AddBankRequest = AddBankRequest(accountName: "", accountNumber: "", bankName: "", userId: "", bankCode: "", rubiesBankCode: "")
    var cardVerifyReq: VerifyCardRequest?
    var resolveAccountRequest: ResolveAccountRequest = ResolveAccountRequest(accountNumber: "", bankCode: "")
    var chargeCardRequest: ChargeCardRequest?
    var chargeBankRequest: ChargeBankRequest?
    
    var selectedWallet: UserWalletResponse!
    var wallets = Signal<()>()
    var walletHistory = Signal<()>()
    
    
    init(cardRepo: WalletRepository = WalletRepositoryImpl.shared){
        self.cardRepo = cardRepo
    }

    
    func addBankAccount(addBankAccountReq: AddBankRequest, completion: @escaping Handler) {
        cardRepo.addBankAccount(addBankAccountReq: addBankAccountReq) { (result) in
            switch result{
                case .success(let response):
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
//                    print("the  error Messaage \(errMessage)")
                    completion(.failure(.custom(message: errMessage)))

            }
        }
    }
    
    
    func getWalletHistory(accountNumber:String,completion: (() -> Void)? = nil) {
        cardRepo.getWalletHistory(accountNo: accountNumber) { (result) in
            switch result {
            case .success(let response):
                if let response = response as? TransactionWalletData {
                    auth.data.walletHistory = response
                    print("wallet response is \(response)")
                }
            case .failure(let error):
            print("error obtaining wallet: \(error)")
                break
            }
        }
    }
    
    func deleteBankAccount(accountNo: String, completion: @escaping Handler) {
        cardRepo.deleteBankAccount(accountNo: accountNo) { (result) in
            switch result{
                case .success(let response):
                    auth.data.accounts?.banks?.removeAll(where: { $0.accountNumber == accountNo })
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    completion(.failure(.custom(message: errMessage)))

            }
        }
    }
    
    func getAllBanks(completion: @escaping Handler) {
        cardRepo.getAllBanks { (result) in
            switch result{
                case .success(let response):
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    completion(.failure(.custom(message: errMessage)))
            }
        }
    }
    
    func getUserBankAccounts<T>(completion: @escaping (T?, String?) -> Void) where T : Decodable, T : Encodable {
        cardRepo.getUserBankAccount { (_ data: T?, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let response = data {
                completion(response, nil)
                return
            }
        }
    }
 
    func resolveAccountNumber(resolveAccountRequest: ResolveAccountRequest, completion: @escaping Handler) {
        cardRepo.resolveAccountNumber(resolveAccountRequest: resolveAccountRequest) { (result) in
            switch result {
                case .success(let response):
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    completion(.failure(.custom(message: errMessage)))

            }
        }
    }
    
    func chargeBankAccount(completion: @escaping Handler) {
        guard let request = self.chargeBankRequest else {
            completion(.failure(.custom(message: "")))
            return
        }
        cardRepo.chargeBankAccount(request: request) { [weak self] (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func addCard(addCardRequest: AddCardRequest, completion: @escaping Handler) {
        cardRepo.addCard(addCardRequest: addCardRequest) { (result) in
            switch result{
                case .success(let response):
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    completion(.failure(.custom(message: errMessage)))
            }
        }
    }
    
    func submitCardPhone(request: SubmitPhoneRequest, completion: @escaping Handler) {
        cardRepo.submitCardPhone(request: request) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func verifyCardOtp(request: VerifyCardRequest, completion: @escaping Handler) {
        
        cardRepo.verifyCard(request: request) { (result) in
            switch result {
            case .success(let response):
                if let response = response as? Response<String> {
                    completion(.success(response))
                }
            case .failure(let errorMsg):
                completion(.failure(.custom(message: errorMsg.localizedDescription)))
            }
        }
    }
    
    func deleteBankCard(cardNumber: String, completion: @escaping Handler) {
        cardRepo.deleteBankCard(cardNumber: cardNumber) { (result) in
            switch result{
                case .success(let response):
                    auth.data.accounts?.cards?.removeAll(where: { $0.cardNumber == cardNumber })
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    completion(.failure(.custom(message: errMessage)))
            }
        }
    }
    
    func getUserBankCard(userId: String, completion: @escaping Handler) {
        cardRepo.getUserBankCard(userId: userId) { (result) in
            switch result{
                case .success(let response):
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
//                    print("the  error Messaage \(errMessage)")
                    completion(.failure(.custom(message: errMessage)))

            }
        }
    }
    
    func getUserWallets() {
        guard loadingWallets == false else {
            return
        }
        loadingWallets = true
        cardRepo.getUserWalletCard() {[weak self] (result) in
            switch result{
                case .success(let response):
                    if let allWallets = response as? [UserWalletResponse]{
                        if auth.data.accounts == nil {
                            auth.data.accounts = PaymentAccounts() // just make sure this isn't null when it needs to be accessed
                        }
                        auth.data.accounts?.wallets = allWallets
                        auth.updateLocalPrefs()
                    }
                case .failure(.custom(let errMessage)):
                    print("the  error Messaage \(errMessage)")
                    break
            }
            self?.loadingWallets = false
            self?.wallets => ()
        }
    }
    
    func getVirtualAccounts(completion: (() -> Void)? = nil) {
        cardRepo.getUserVirtualAccount() { (result) in
            switch result {
            case .success(let response):
                if let response = response as? VirtualAccountsResponse {
                    auth.data.accounts?.virtualAccount = response
                    auth.updateLocalPrefs()
                }
            case .failure(let error):
                print("error obtaining account: \(error)")
                break
            }
        }
    }
    
    func createWallet(completion: @escaping Handler) {
        cardRepo.createWallet { (result) in
            switch result {
            case .success(_):
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
   
    func setDefaultWallet(accountNumber : String, completion : @escaping  Handler){
        guard let oldDefault = auth.data.accounts?.wallets?.filter({ $0.datumDefault == true}).first else {
            completion(.failure(.custom(message: "No default wallet found")))
            return
        }
        cardRepo.setDefaultWallet(oldAccountNumber: oldDefault.accountNo, newAccountNumber: accountNumber) { (result) in
            switch result {
            case .success(_):
                self.getUserWallets()
                completion(.success(nil))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func chargeCard(completion: @escaping Handler){
        guard let request = self.chargeCardRequest else {
            completion(.failure(.custom(message: "")))
            return
        }
        cardRepo.chargeCard(chargeCardRequest: request) { (result) in
            switch result{
                case .success(let response):
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    print("the  error Messaage \(errMessage)")
                    completion(.failure(.custom(message: errMessage)))
                    
            }
        }
    }
    
    func deleteContactRequest(id : Int, completion : @escaping Handler){
        cardRepo.deleteContactRequest(id: id) { (result) in
            switch result{
                case .success(let response):
                    print("The success response \(String(describing: response))")
                    
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    print("the  error Messaage \(errMessage)")
                    completion(.failure(.custom(message: errMessage)))
                    
            }
        }
    }
    
    func findAllContact(completion : @escaping Handler){
        cardRepo.findAllContact{ (result) in
            switch result{
            case .success(let all):
                completion(.success(all))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getByContactAccountByPhoneNumber(phoneNumber : String, completion : @escaping Handler){
        cardRepo.getByContactAccountByPhoneNumber(phoneNumber: phoneNumber) { (result) in
            switch result{
                case .success(let response):
                    print("The success response \(String(describing: response))")
                    
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    print("the  error Messaage \(errMessage)")
                    completion(.failure(.custom(message: errMessage)))
                    
            }
        }
    }
    
    func sendMoneyToContact(sendMoneyToPhoneRequest: SendMoneyToPhoneRequest, completion : @escaping Handler){
        cardRepo.sendMoneyToContact(sendMoneyToPhoneRequest: sendMoneyToPhoneRequest){ (result) in
            switch result{
                case .success(let response):
                    print("The success response \(String(describing: response))")
                    
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    print("the  error Messaage \(errMessage)")
                    completion(.failure(.custom(message: errMessage)))
                    
            }
        }
    }
    
    func sendMoneyToEmail(email: String, sendMoneyToEmailRequest : SendMoneyToEmailRequest, completion : @escaping Handler){
        cardRepo.sendMoneyToEmail(email: email, sendMoneyToEmailRequest: sendMoneyToEmailRequest){ (result) in
            switch result{
                case .success(let response):
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    completion(.failure(.custom(message: errMessage)))
                    
            }
        }
    }
    
    func sendMoneyToWayaID(sendMoneyToIDRequest : SendMoneyToIDRequest, completion: @escaping Handler){
        cardRepo.sendMoneyToWayaID(sendMoneyToIDRequest: sendMoneyToIDRequest){ (result) in
            switch result{
                case .success(let response):
                    print("The success response \(String(describing: response))")
                    
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    print("the  error Messaage \(errMessage)")
                    completion(.failure(.custom(message: errMessage)))
                    
            }
        }
    }
    
    func filterContact(filterContactRequest : FilterContactRequest, completion: @escaping Handler){
        cardRepo.filterContact(filterContactRequest: filterContactRequest){ (result) in
            switch result{
                case .success(let response):
                    print("The success response \(String(describing: response))")
                    
                    completion(.success(response))
                case .failure(.custom(let errMessage)):
                    print("the  error Messaage \(errMessage)")
                    completion(.failure(.custom(message: errMessage)))
                    
            }
        }
    }
    
    
    func getChargeableBanks(completion: @escaping Handler) {
        cardRepo.getChargeAbleBanks { (result) in
            switch result {
            case .success(let response):
                if let banks = response as? [ChargeAbleBankResponse] {
                    completion(.success(banks))
                } else {
                    completion(.failure(.custom(message: "Unable to get acceptable banks")))
                }
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    private var withdrawing = false // used only in this function as a queue blocker for async
    func withdrawToBank(request: WithdrawalRequest, completion: @escaping Handler) {
        guard withdrawing == false else {
            return
        }
        withdrawing = true
        cardRepo.withdrawToBank(request: request) { (result) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
            self.withdrawing = false
        }
    }
    
    func getBeneficiaries(completion: @escaping Handler) {
        cardRepo.getBankBeneficiaries(completion: { (result) in
            switch result {
            case .success(let accounts):
                completion(.success(accounts))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        })
    }
    func saveBeneficiary(account: BankBeneficiary, completion: (() -> Void)? = nil) {
        cardRepo.saveBeneficiary(account: account, completion: { (result) in
            
        })
    }
}
