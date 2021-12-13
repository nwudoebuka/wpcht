//
//  CardRepositoryImpl.swift
//  Waya PayChat 2.0
//
//  Created by Home on 2/5/21.
//

import Foundation

class WalletRepositoryImpl {
    
    static let shared : WalletRepository = WalletRepositoryImpl()
    var processing_charge: Bool = false
    
    private init(){}
}

extension WalletRepositoryImpl : WalletRepository{
    func getWalletHistory(accountNo: String,completion: @escaping Handler) {
        let endpoint: WayaClient = .card(.getWalletHistory(accountNumber: accountNo))
        let request = NetworkRequest(endpoint: endpoint, method: .get, encoding: .url, body: [:])
        
        Request.shared.fetch(request) { (status, _ response: Response<TransactionWalletData>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "Unable to get wallet history")))
                    return
                }
                if response.status == true {
                    completion(.success(response.data))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    
    
    func addBankAccount(addBankAccountReq: AddBankRequest, completion: @escaping Handler) {
        let endpoint: WayaClient = .card(.addBankAccount(userid: addBankAccountReq.userId))
        let networkRequest = NetworkRequest(endpoint: endpoint, method: .post, encoding: .json, body: addBankAccountReq.dictionary!)
        Request.shared.fetch(networkRequest) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "Unable to add card")))
                    return
                }
                if response.status == true {
                    completion(.success(true))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func deleteBankAccount(accountNo: String, completion: @escaping Handler) {
        let endpoint: WayaClient = .card(.deleteBankAccount(user: String(auth.data.userId!), accountNumber: accountNo))
        let request = NetworkRequest(endpoint: endpoint, method: .delete, encoding: .urlJson, body: [:])
        
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "Unable to delete account")))
                    return
                }
                if response.status == true {
                    completion(.success(true))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getAllBanks(completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .card(.getAllBanks), method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<[Bank]>?) in
            switch status {
            case .success:
                completion(.success(response!.data!))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getUserBankAccount<T: Codable>(completion: @escaping (_ data: T?, _ error: String?) -> Void) {
        let request = NetworkRequest(endpoint: .card(.getUserBankAccounts(userId: String(auth.data.userId!))), method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: T?) in
            switch status {
            case .success:
                completion(response, nil)
            case .failed(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
    
    func resolveAccountNumber(resolveAccountRequest: ResolveAccountRequest, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .card(.resolveAccountNumber), method: .post, encoding: .json, body: resolveAccountRequest.dictionary!)
        
        Request.shared.fetch(request) { (status, _ response: Response<BankResolveResponse>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "Unable to resolve account number")))
                    return
                }
                if response.status == true{
                    completion(.success(response.data))
                } else {
                    completion(.failure(.custom(message: response.message ?? "")))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func addCard(addCardRequest: AddCardRequest, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .card(.addCard), method: .post, encoding: .json, body: addCardRequest.dictionary!)
        
        Request.shared.fetch(request) { (status, _ response: Response<AddCardResponse>?) in
            switch status {
            case .success:
                completion(.success(response!))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func submitCardPhone(request: SubmitPhoneRequest, completion: @escaping Handler) {
        let req = NetworkRequest(endpoint: .card(.submitCardPhone), method: .post, encoding: .url, body: request.dictionary!)
        Request.shared.fetch(req) { (status, _ response: Response<AddCardResponse>?) in
            switch status {
            case .success:
                completion(.success(response!))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func verifyCard(request: VerifyCardRequest, completion: @escaping Handler) {
        let request_ = NetworkRequest(endpoint: .card(.verifyCardOtp), method: .post, encoding: .url, body: request.dictionary!)
        Request.shared.fetch(request_) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(response!))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func deleteBankCard(cardNumber: String, completion: @escaping Handler) {
        let endpoint: WayaClient = .card(.deleteBankCard(userId: String(auth.data.userId!), cardNumber: cardNumber))
        let request = NetworkRequest(endpoint: endpoint, method: .delete, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "Unable to delete card")))
                    return
                }
                if response.status == true {
                    completion(.success(true))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getUserBankCard(userId: String, completion: @escaping Handler) {
        
        let request = NetworkRequest(endpoint: .card(.getUserBankCard(userId: userId)), method: .get, encoding: .urlJson, body: [:])
        
        Request.shared.fetch(request) { (status, _ response: Response<[CardResponse]>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "failed to get user's cards")))
                    return
                }
                (response.status == true) ? completion(.success(response.data)) : completion(.failure(.custom(message: response.message ?? "")))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getUserWalletCard(completion: @escaping Handler){
        let request = NetworkRequest(endpoint: .wallet(.getUserWallet(userId: String(auth.data.userId!))), method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: ResponseList<UserWalletResponse>?) in
            switch status {
            case .success:
                if let response = response {
                    completion(.success(response.data))
                } else{
                    print("failed to get response")
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func createWallet(completion: @escaping Handler){
        let request = NetworkRequest(endpoint: .wallet(.createWallet), method: .post, encoding: .json, body: ["userId" : String(auth.data.userId!)])
        Request.shared.fetch(request) { (status, _ response: Response<UserWalletResponse>?) in
            switch status {
            case .success:
                completion(.success("Wallet Created"))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func setDefaultWallet(oldAccountNumber : String, newAccountNumber: String, completion: @escaping Handler){
        let params = [
            "oldDefaultAcctNo" : oldAccountNumber,
            "newDefaultAcctNo" : newAccountNumber,
            "userId" : String(auth.data.userId!)
        ]
        let request = NetworkRequest(endpoint: .wallet(.setDefaultWalletAccount), method: .post, encoding: .json, body: params)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(nil))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }

    func chargeCard(chargeCardRequest : ChargeCardRequest, completion: @escaping Handler){
        guard processing_charge == false else {
            return
        }
        processing_charge = true
        let request = NetworkRequest(endpoint: .card(.chargeCard), method: .post, encoding: .url, body: chargeCardRequest.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                completion(.success(response))
            case .failed(let errorMsg):
                completion(.failure(.custom(message: errorMsg.localizedDescription)))
            }
            self.processing_charge = true
        }
    }
    
    func deleteContactRequest(id : Int, completion : @escaping Handler){}
    
    func findAllContact(completion : @escaping Handler){
        let request = NetworkRequest(endpoint: .contact(.findAllContact), method: .get, encoding: .urlJson, body: [:])
        Request.shared.fetch(request) { (status, _ response: [FindAllContactsResponse]?) in
            switch status {
            case .success:
                if let response = response {
                    completion(.success(response))
                } else {
                    completion(.failure(.custom(message: "Unable to load contacts")))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    
    func getByContactAccountByPhoneNumber(phoneNumber : String, completion : @escaping Handler){
//        guard  let url: WayaClient = .contact(.getContactByPhoneNumber(phoneNumber: phoneNumber)).url else {
//            completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to set default wallet").message)))
//            return
//        }
//
//        NetworkManager.instance.initialGETRequest(url: url, responseType: WayaPayHttptRespStatus<ContactAmountResponse>.self) { (response, error) in
//
//            if let response = response {
//                if response.status == true{
//                    completion(.success(response.data))
//                } else {
//                    completion(.failure(.custom(message: response.message )))
//                }
//            } else {
//                if(error?.localizedDescription == "The Internet connection appears to be offline."){
//                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
//                } else{
//                    completion(.failure(.custom(message: ResponseMessage.serverError(operation: "to login").message)))
//                }
//            }
//
//        }
    }
    
    func sendMoneyToContact(sendMoneyToPhoneRequest: SendMoneyToPhoneRequest, completion : @escaping Handler){
        let request = NetworkRequest(endpoint: .contact(.sendMoneyToContact), method: .post, encoding: .json, body: sendMoneyToPhoneRequest.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response  else {
                    completion(.failure(.custom(message: "unable to send money to \(sendMoneyToPhoneRequest.phoneNumber)")))
                    return
                }
                
                (response.code == 200) ? completion(.success(response.message)) : completion(.failure(.custom(message: response.message ?? "")))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            default:
                completion(.failure(.custom(message: status.localizedDescription)))
            }
        }
    }
    
    func sendMoneyToEmail(email: String, sendMoneyToEmailRequest: SendMoneyToEmailRequest, completion : @escaping Handler){
        let endpoint: WayaClient = .contact(.sendMoneyToEmail(email: email))
        let request = NetworkRequest(endpoint: endpoint, method: .post, encoding: .json, body: sendMoneyToEmailRequest.dictionary!)
        
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                if let response = response {
                    if response.status == true {
                        completion(.success(response.message!))
                    } else {
                        completion(.failure(.custom(message: response.message!)))
                    }
                } else {
                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            default:
                completion(.failure(.custom(message: status.localizedDescription)))
            }
        }
    }
    
    func sendMoneyToWayaID(sendMoneyToIDRequest : SendMoneyToIDRequest, completion: @escaping Handler){
        
        let request = NetworkRequest(endpoint: .contact(.sendMoneyToUserId), method: .post, encoding: .json, body: sendMoneyToIDRequest.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                guard let response = response  else {
                    completion(.failure(.custom(message: "unable to send money to \(sendMoneyToIDRequest.toId)")))
                    return
                }
                
                (response.code == 200) ? completion(.success(response.message)) : completion(.failure(.custom(message: response.message ?? "")))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            default:
                completion(.failure(.custom(message: status.localizedDescription)))
            }
        }
    }
    
    func filterContact(filterContactRequest : FilterContactRequest, completion: @escaping Handler){
        
        let request = NetworkRequest(endpoint: .contact(.filterContact), method: .post, encoding: .json, body: filterContactRequest.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<ContactResponse>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "Unable to filter contact")))
                    return
                }
                (response.status == true) ? completion(.success(response.message)) : completion(.failure(.custom(message: response.message ?? "")))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            default:
                completion(.failure(.custom(message: status.localizedDescription)))
            }
        }
    }
    
    func getUserVirtualAccount(completion: @escaping Handler) {
        if let user = auth.data.userId {
            let request = NetworkRequest(endpoint: .accounts(.getVirtualAccounts(user: String(user))), method: .get, encoding: .urlJson, body: [:])
            Request.shared.fetch(request) { (status, _ response: Response<VirtualAccountsResponse>?) in
                switch status {
                case .success:
                    completion(.success(response!.data))
                case .failed(let error):
                    completion(.failure(.custom(message: error.localizedDescription)))
                default:
                    completion(.failure(.custom(message: ResponseMessage.noInternerConnection.message)))
                }
            }
        } else {
            completion(.failure(.custom(message: "User not authenticated"))) // redirect to logout
            return
        }
    }
    
    func chargeBankAccount(request: ChargeBankRequest, completion: @escaping Handler) {
        guard processing_charge == false else {
            return
        }
        processing_charge = true
        let user = String(auth.data.userId!)
        let request_ = NetworkRequest(endpoint: .card(.chargeBankAccount(user: user)), method: .post, encoding: .json, body: request.dictionary!)
        
        Request.shared.fetch(request_) { (status, _ response: Response<ChargeBankResponse>?) in
            switch status {
            case .success:
                completion(.success(response))
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
            
            self.processing_charge = false
        }
    }
    
    func getChargeAbleBanks(completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .card(.getChargeAbleBanks), method: .get, encoding: .url, body: [:])
        Request.shared.fetch(request) { (status, _ response: Response<[ChargeAbleBankResponse]>?) in
            switch status {
            case .success:
                if let response = response {
                    if response.status == true && response.data != nil{
                        completion(.success(response.data))
                    } else {
                        completion(.failure(.custom(message: "No banks found")))
                    }
                } else {
                    completion(.failure(.custom(message: "")))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func withdrawToBank(request: WithdrawalRequest, completion: @escaping Handler) {
        let netRequest = NetworkRequest(endpoint: .withdrawal(.withdrawToBank), method: .post, encoding: .json, body: request.dictionary!)
        Request.shared.fetch(netRequest) { (status, _ response: Response<String>?) in
            switch status {
            case .success:
                if response!.status == true {
                    completion(.success(response?.message))
                } else {
                    completion(.failure(.custom(message: response!.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func getBankBeneficiaries(completion: @escaping Handler) {
        let user = String(auth.data.userId!)
        let endpoint = WayaClient.withdrawal(.getBeneficiaries(id: user))
        let request = NetworkRequest(endpoint: endpoint, method: .get, encoding: .urlJson, body: [:])
        
        Request.shared.fetch(request) { (status, _ response: Response<[BankBeneficiary]>?) in
            switch status {
            case .success:
                guard let response = response else {
                    completion(.failure(.custom(message: "No response received from server")))
                    return
                }
                if response.status == true {
                    completion(.success(response.data))
                } else {
                    completion(.failure(.custom(message: response.message!)))
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
    
    func saveBeneficiary(account: BankBeneficiary, completion: @escaping Handler) {
        let request = NetworkRequest(endpoint: .withdrawal(.saveBeneficiary), method: .post, encoding: .json, body: account.dictionary!)
        Request.shared.fetch(request) { (status, _ response: Response<String>?) in
            
        }
    }
}
