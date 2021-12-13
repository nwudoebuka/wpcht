//
//  WalletFactoryModule.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/7/21.
//

protocol WalletFactoryModule {
    func makeWalletOutput() -> WalletView
    
    // manage card, bank and wallet view 
    func makeManageCardView() -> ManageCardView
    func makeManageBankView() -> ManageBankView
    func makeTransaction(transactionViewModel:TransactionViewModelImpl) -> TransactionView
    func makemanageWalletItemView() -> ManageWalletView
    
    //make add  bank detail view 
    func makeAddBankDetailView() -> AddBankView
    func makeAddCardDetailView() -> AddCardView
    func makeWalletItemDetailView(walletViewModel : WalletViewModelImpl,txnViewmodel:TransactionViewModelImpl) -> WalletItemDetailView
    
    //make add card view 
    func makeAddCardView() -> AddCardView
    func makeAddBankView() -> AddBankView
    
    func makeTopUpCardView(walletViewModel: WalletViewModelImpl, chargeSource: ChargeSource) -> TopUpCardView
    func makePayToEmailView(walletViewModel: WalletViewModelImpl) -> PayToEmailView
    func makePayToIDView(walletViewModel: WalletViewModelImpl,title:String) -> PayToIDView
    func makePayToPhoneView(walletViewModel: WalletViewModelImpl) -> PayToPhoneView
    func makePayToBeneficiaryView(walletViewModel: WalletViewModelImpl) -> PayToBeneficiaryView
    
    //make billPaymentViews
    func  makeCableView(_ walletViewModel : WalletViewModelImpl) -> CableView
    func makeDataPurchaseView(_ walletViewModel : WalletViewModelImpl) -> DataPurchaseView
    func makeAirtimeView (_ walletViewModel : WalletViewModelImpl) -> AirtimeView
    func makeShowUtilityView (_ walletViewModel : WalletViewModelImpl) -> UtilityView
    
    //show RequestViews
    func  makeSendRequest(_ walletViewModel : WalletViewModelImpl) -> SendRequestView
    func  makeReceiveRequest (_ walletViewModel : WalletViewModelImpl) -> ReceiveRequestView
    func  makeAllRequest (_ walletViewModel : WalletViewModelImpl) -> AllRequestView
    
    //show Receive Views
    func  makeRequestPayment (_ walletViewModel : WalletViewModelImpl) -> RequestPaymentView
    func  makeScanToPayView (_ walletViewModel : WalletViewModelImpl) -> ScanToPayView
    
    //show Withdraw Views 
    func  makeWithdrawView (_ walletViewModel : WalletViewModelImpl, mode: WithdrawMode) -> WithdrawView
    
    // Link BVN
    func makeBVNView(_ walletViewModel: WalletViewModelImpl) -> BVNView
    func makeVerify(_ channel: ForgotOTPChannel, _ viewModel: AuthViewModel) -> AccountVerifyView
}
