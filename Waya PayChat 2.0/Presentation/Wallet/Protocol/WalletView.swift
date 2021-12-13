//
//  WalletView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 18/06/2021.
//

import Foundation

protocol WalletView : BaseView{
    var onNavToogle: (() -> Void)? { get set }
    var navToPaymentSetting : (() -> Void)? { get set }
    var navToTransactions : ((_ transactionViewModel : TransactionViewModelImpl) -> Void)? { get set }
    var navToManageWallet : (() -> Void)? { get set }
    var navToManageCard : (() -> Void)? { get set }
    var navToManageBank : (() -> Void)? { get set }
    var navToWalletItemDetail : ((_ walletViewModel : WalletViewModelImpl, _ txnViewModelImpl:TransactionViewModelImpl) -> Void)? {get set}
    var navToTopUpCard: ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    var navToTopUpBank: ((_ walletViewModel : WalletViewModelImpl, _ type: BankType) -> Void)? {get set}
    var navToPayToEmail : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    var navToPayToID : ((_ walletViewModel : WalletViewModelImpl,_ title:String) -> Void)? {get set}
    var navToPayToPhone : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    var navToPayBeneficiary: ((_ walletViewModel: WalletViewModelImpl) -> Void)? {get set}
    
    //show billPaymentViews
    var navToShowCableView : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    var navToShowDataPurchaseView  : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    var navToShowAirtimeView : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    var navToShowUtilityView : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    
    //show RequestViews
    var navToSendRequest : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    var navToReceiveRequest : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    var navToAllRequest : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    
    //show Receive Views
    var navToRequestPayment : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    var navToScanToPayView : ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    
    //show Withdraw Views
    var navToWithdrawView : ((_ walletViewModel : WalletViewModelImpl, _ mode: WithdrawMode) -> Void)? {get set}
    
    // Show BVN Linking Views
    var navToLinkBVN: ((_ walletViewModel : WalletViewModelImpl) -> Void)? {get set}
    
    // show Email/Phone Verify
    var navToVerify: ((ForgotOTPChannel, AuthViewModel) -> Void)? { get set }
}
