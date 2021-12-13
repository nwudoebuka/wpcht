//
//  WalletService.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 17/08/2021.
//

import Foundation
import Signals

let wallet = CoreBanking.shared

final class CoreBanking: NSObject {
    private static var instance: CoreBanking?
    let walletViewModel = WalletViewModelImpl()
    
    let loaded = Signal<()>()
    
    static var shared: CoreBanking {
        if instance == nil {
            instance = CoreBanking()
//            instance?.load()
        }
        return instance!
    }
    
    override init() {
        super.init()
    }
    
    func load() {
//        walletViewModel.getUserWallets()
//        walletViewModel.getUserBankAccounts() { (_ response: ResponseList<BankResponse>?, error) in
//            if let banks = response?.data {
//                if banks.count > 0 {
//                    self.data.accounts?.banks = banks
//                    if self.data.completedKyc?.firstIndex(of: .accountLinked) == nil {
//                        self.data.completedKyc?.append(.accountLinked)
//                    }
//                } else {
//                    if let index = self.data.completedKyc?.firstIndex(of: .accountLinked){
//                        self.data.completedKyc?.remove(at: index)
//                    }
//                    self.data.accounts?.banks = nil
//                }
//            }
//            self.updateLocalPrefs()
//        }
//
//        walletViewModel.getUserBankCard(userId: String(data.userId!)) { (result) in
//            switch result {
//            case .success(let cardResponse):
//                if let cards = cardResponse as? [CardResponse]{
//                    if cards.count > 0 {
//                        if let kyc = self.data.completedKyc, let _ = kyc.firstIndex(of: .cardLinked) {
//                            self.data.completedKyc!.append(.cardLinked)
//                        }
//                        self.data.accounts?.cards = cards
//                    } else {
//                        if let index = self.data.completedKyc?.firstIndex(of: .cardLinked){
//                            self.data.completedKyc!.remove(at: index)
//                        }
//                        self.data.accounts?.cards = nil
//                    }
//                }
//            case .failure(_):
//                break
//            }
//            self.updateLocalPrefs()
//            self.profileReloaded =>  ()
//        }
    }
}
//var accounts: PaymentAccounts?
//
