//
//  WalletCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/7/21.
//


final class WalletCoordinator: BaseCoordinator, DashBoardCoordinator {
    var navToTransactions: (() -> Void)?
    
    var navToSettings: ((SettingsView?) -> Void)?
    var toogleMenu: (() -> Void)?
    private var transitioning: Bool = false
    
    private let factory: WalletFactoryModule
    private let router: Router
    
    init(router: Router, factory: WalletFactoryModule) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showWalletDefault()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showWalletDefault() {
        let walletFlowOutput = factory.makeWalletOutput()
        
        walletFlowOutput.onNavToogle = { [weak self] in
            self?.toogleMenu?()
        }
        
        walletFlowOutput.navToPaymentSetting = { [weak self] in
            self?.navToSettings?(MainSettings.payments.controller)
        }
        
        walletFlowOutput.navToTransactions = { [weak self] (transactionViewModel) in
            self?.showTransaction(transactionViewModel: transactionViewModel)
        }
        
        walletFlowOutput.navToManageBank = {[weak self] in
            self?.showManageBank()
        }
        
        walletFlowOutput.navToManageCard = {[weak self] in
            self?.showManageCard()
        }
        
        walletFlowOutput.navToManageWallet = {[weak self] in
            self?.showManageWallet()
        }
        
        walletFlowOutput.navToWalletItemDetail = {[weak self] (walletViewModelImpl,txnViewModel) in
            self?.showWalletItemDetailView(walletViewModel: walletViewModelImpl, txnViewModel: txnViewModel)
        }
        
        walletFlowOutput.navToTopUpCard = { [weak self] (walletViewModel)in
            self?.showTopUpCard(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToTopUpBank = { [weak self] (walletViewModel, type) in
            self?.showTopUpBank(walletViewModel: walletViewModel, type: type)
        }
        
        walletFlowOutput.navToPayToID = {[weak self] (walletViewModel,title) in
            self?.showPayToID(walletViewModel: walletViewModel, title: title)
        }
        
        walletFlowOutput.navToPayToPhone = {[weak self] (walletViewModel) in
            self?.showPayToPhone(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToPayToEmail = {[weak self] (walletViewModel) in
            self?.showPayToEmail(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToShowCableView = {[weak self] (walletViewModel) in
            self?.showCableView(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToShowDataPurchaseView = {[weak self] (walletViewModel) in
            self?.showDataPurchaseView(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToShowAirtimeView = {[weak self] (walletViewModel) in
            self?.showAirtimeView(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToShowUtilityView = {[weak self] (walletViewModel) in
            self?.showUtilityView(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToSendRequest = {[weak self] (walletViewModel) in
            self?.showSendRequest(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToReceiveRequest = {[weak self] (walletViewModel) in
            self?.showReceiveRequest(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToAllRequest = {[weak self] (walletViewModel) in
            self?.showAllRequest(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToRequestPayment = {[weak self] (walletViewModel) in
            self?.showRequestPayment(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToScanToPayView = {[weak self] (walletViewModel) in
            self?.showScanToPayView(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToWithdrawView = {[weak self] (walletViewModel, mode) in
            self?.showWithDrawView(walletViewModel: walletViewModel, mode: mode)
        }
        
        walletFlowOutput.navToPayBeneficiary = {[weak self] (walletViewModel) in
            self?.showPayBeneficiary(walletViewModel: walletViewModel)
        }
        
        walletFlowOutput.navToLinkBVN = { [weak self] (walletViewModel) in
            self?.showLinkBVN(walletViewModel)
        }
        
        walletFlowOutput.navToVerify = { [weak self] (channel, viewModel) in
            self?.showVerify(channel: channel, viewModel: viewModel)
        }
        
        router.setRootModule(walletFlowOutput)
    }
    
    
    private func showManageWallet(){
        let manageWallet = factory.makemanageWalletItemView()
        
        manageWallet.onAddWalletSuccessful = { [weak self] in
            self?.router.popToRootModule(animated: true)
        }
        router.push(manageWallet, hideBottomBar: true)
    }
    
    private func showManageCard(){
        let manageCard = factory.makeManageCardView()
        manageCard.onBack = {
            self.router.popToRootModule(animated: true)
        }
        router.push(manageCard, hideBottomBar: true)
    }
    
    private func showManageBank(add: Bool? = false){
        let manageBank = factory.makeManageBankView()
        manageBank.goToAddBank = {[weak self] in
            self?.showAddBankView()
        }
        
        manageBank.gotToShowBankDetails = { [weak self] (bank) in
            self?.showBankDetails(bank: bank)
        }
        router.push(manageBank, hideBottomBar: true)
    }
    
    
    private func showTransaction(transactionViewModel : TransactionViewModelImpl){
        print("saw transaction router")
        let manageTransactions = factory.makeTransaction(transactionViewModel: transactionViewModel)
       
        router.push(manageTransactions, hideBottomBar: true)
    }
    
    private func showAddBankView(){
        let addBankView = factory.makeAddBankView()
        addBankView.onComplete = {
            self.router.popModule()
        }
        router.push(addBankView, hideBottomBar: true)
    }
    
    private func showBankDetails(bank: BankResponse) {
        let detailView = BankDetailViewController()
        detailView.bank = bank
        
        detailView.onBackClicked = {
            self.router.popModule()
        }
        router.push(detailView, hideBottomBar: true)
    }
    
    private func showAddBankDetailView(){
      let addBankDetail = factory.makeAddBankDetailView()
        router.push(addBankDetail, hideBottomBar: true)  
    }
    
    private func showAddCardDetailView(){
        let addCardDetail  = factory.makeAddCardDetailView()
        router.push(addCardDetail, hideBottomBar: true)
    }
    
    private func showWalletItemDetailView(walletViewModel : WalletViewModelImpl,txnViewModel:TransactionViewModelImpl){
        let walletItemDetail = factory.makeWalletItemDetailView(walletViewModel: walletViewModel, txnViewmodel: txnViewModel)
        router.push(walletItemDetail)
    }
    
    private func showTopUpCard(walletViewModel : WalletViewModelImpl){
        let topUpCardView = factory.makeTopUpCardView(walletViewModel: walletViewModel, chargeSource: .card)
        topUpCardView.onTopUpSuccessful = { [weak self] in
            self?.router.popToRootModule(animated: true)
        }
        
        topUpCardView.onBack = { [weak self] in
            self?.router.popToRootModule(animated: false)
        }
        
        topUpCardView.onTopUpFailed = { [weak self] in
            self?.router.popToRootModule(animated: false)
        }
        router.push(topUpCardView, hideBottomBar: true)
    }
    
    private func showTopUpBank(walletViewModel: WalletViewModelImpl, type: BankType) {
        let topUpCardView = factory.makeTopUpCardView(walletViewModel: walletViewModel, chargeSource: .bank(type))
        topUpCardView.onTopUpSuccessful = { [weak self] in
            self?.router.popToRootModule(animated: true)
        }
        topUpCardView.onBack = {
            self.router.popModule()
        }
        topUpCardView.onTopUpFailed = { [weak self] in
            self?.router.popToRootModule(animated: false)
        }
        router.push(topUpCardView, hideBottomBar: true)
    }
    
    private func showPayToEmail(walletViewModel : WalletViewModelImpl){
        let payToEmailView = factory.makePayToEmailView(walletViewModel: walletViewModel)
        payToEmailView.onPayToEmailSuccessful = {[weak self] in
             self?.router.popToRootModule(animated: true)
        }
        router.push(payToEmailView, hideBottomBar: true)
    }
    
    private func showPayToPhone(walletViewModel : WalletViewModelImpl){
        let payToPhoneView = factory.makePayToPhoneView(walletViewModel: walletViewModel)
        payToPhoneView.onPayToPhoneViewSuccess = {[weak self] in
            self?.router.popToRootModule(animated: true)
        }
        router.push(payToPhoneView, hideBottomBar: true) 
    }
    
    private func showPayToID(walletViewModel : WalletViewModelImpl,title:String){
        let payToIDView = factory.makePayToIDView(walletViewModel: walletViewModel, title: title)
        payToIDView.onPayToIDSuccess = {[weak self] in
            self?.router.popModule()
        }
        
//        payToIDView.
        router.push(payToIDView, hideBottomBar: true)
    }
    
    
    private func showPayBeneficiary(walletViewModel: WalletViewModelImpl) {
        let payToBeneficiary = factory.makePayToBeneficiaryView(walletViewModel: walletViewModel)
        
        payToBeneficiary.onClose = { [weak self] in
            self?.router.popModule(animated: true)
        }
        
        payToBeneficiary.onPayToBeneficiarySuccess = { [weak self] in
            self?.router.popModule()
        }
        router.push(payToBeneficiary, hideBottomBar: true)
    }
    
    private func showCableView(walletViewModel : WalletViewModelImpl) {
        let cableView = factory.makeCableView(walletViewModel)
        router.push(cableView)
    }
    
    private func showDataPurchaseView(walletViewModel : WalletViewModelImpl) {
        let dataView = factory.makeDataPurchaseView(walletViewModel)
        
        router.push(dataView)
    }
    
    private func showAirtimeView(walletViewModel : WalletViewModelImpl){
        let airtimeView = factory.makeAirtimeView(walletViewModel)
        
        router.push(airtimeView)
    }
    
    private func showUtilityView(walletViewModel : WalletViewModelImpl){
        let utilityView = factory.makeShowUtilityView(walletViewModel)
        
        router.push(utilityView)
    }
    
    private func showSendRequest(walletViewModel : WalletViewModelImpl){
        let sendRequest = factory.makeSendRequest(walletViewModel)
        router.push(sendRequest)
    }
    
    private func showReceiveRequest(walletViewModel : WalletViewModelImpl){
        let receivePayment = factory.makeReceiveRequest(walletViewModel)
        
        router.push(receivePayment)
    }
    
    private func showAllRequest(walletViewModel : WalletViewModelImpl){
        let allRequestView = factory.makeAllRequest(walletViewModel)
        router.push(allRequestView)
    }
    
    private func showRequestPayment(walletViewModel : WalletViewModelImpl){
        let requestPayment = factory.makeRequestPayment(walletViewModel)
        router.push(requestPayment)
    }
    
    private func showScanToPayView(walletViewModel : WalletViewModelImpl){
        let scanToPay = factory.makeScanToPayView(walletViewModel)
        scanToPay.onClose = {
            self.router.popModule()
        }
        
        scanToPay.onScanToPaySuccess = {
            self.router.popToRootModule(animated: true)
        }
        router.push(scanToPay, hideBottomBar: true)
    }
    
    private func showWithDrawView(walletViewModel : WalletViewModelImpl, mode: WithdrawMode){
        let withDrawView = factory.makeWithdrawView(walletViewModel, mode: mode)
        withDrawView.onExit = {
            self.router.popModule()
        }
        router.push(withDrawView, hideBottomBar: true)
    }
    
    private func showLinkBVN(_ viewModel: WalletViewModelImpl) {
        let bvnView = factory.makeBVNView(viewModel)
        bvnView.onComplete = { [weak self] () in
            self?.router.popModule()
        }
        
        router.push(bvnView, hideBottomBar: true)
    }
    
    private func showVerify(channel: ForgotOTPChannel, viewModel: AuthViewModel) {
        guard transitioning == false else {
            return
        }
        transitioning = true
        let verifyView = factory.makeVerify(channel, viewModel)
        verifyView.dismiss = { [weak self] in
            self?.router.popToRootModule(animated: true)
        }
        router.push(verifyView, hideBottomBar: true)
        transitioning = false
    }
}
