//
//  ModuleFactoryImp.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/2/21.
//

final class ModuleFactoryImpl: AuthModuleFactory, OnboardingModuleFactory,
                               SettingsModuleFactory, NotificationFactoryModule,
                               HomeFactoryModule, ChatFactoryModule,
                               WalletFactoryModule, DiscoverFactoryModule {

    func makeTransaction(transactionViewModel:TransactionViewModelImpl) -> TransactionView {
        return TransactionsViewController(transactionViewModel: transactionViewModel)
    }
   
    func makeSettingsOutput() -> SettingsView {
        return SettingsViewController()
    }
    
    
    func makePayToBeneficiaryView(walletViewModel: WalletViewModelImpl) -> PayToBeneficiaryView {
        return PayToBeneficiaryViewController(walletViewModel: walletViewModel)
//        return controller
    }
    
    func makeCommentView(wayagramViewModel : WayagramViewModelImpl) -> CommentView{
        return CommentViewController(wayagramViewModel: wayagramViewModel)
    }

    
    func makePostDetailView(wayagramViewModel: WayagramViewModelImpl) -> PostDetailView {
        return PostDetailViewController(wayagramViewModel: wayagramViewModel)
    }
    
    func makeNotificationOutput() -> NotificationView {
        return  NotificationViewController.controllerFromStoryboard(.notification)
    }
    
    func makeHomeOutput(dataController : DataController, wayagramViewModel: WayagramViewModelImpl) -> HomeView {
        let homeOutput =  HomeViewController.controllerFromStoryboard(.home)
        homeOutput.dataController = dataController
        homeOutput.wayagramViewModel = wayagramViewModel
        return  homeOutput

    }
    
    func makeChatOutput() -> ChatView {
        return  ChatViewController.controllerFromStoryboard(.chat)
    }
    
    func makeWalletOutput() -> WalletView {
        return  WalletViewController.controllerFromStoryboard(.wallet)
    }
    
    func makeTransactionOutput() -> TransactionView {
        return  TransactionsViewController.controllerFromStoryboard(.wallet)
    }
    
    func makeDiscoverOutput() -> DiscoverView {
        return  DiscoverViewController.controllerFromStoryboard(.discover)
    }
    
    
    func makePasswordView(authViewModel : AuthViewModelImpl?) -> PasswordView {
        let controller = PasswordViewController.controllerFromStoryboard(.auth)
        controller.authViewModel = authViewModel
        return controller
    }
        
    func makeVerifyAccount(authViewModel : AuthViewModelImpl?) -> VerifyAccountView {
        let controller = VerifyAccountViewController.controllerFromStoryboard(.auth)
        controller.authViewModel = authViewModel
        return controller
    }
    
    func makeCreatePinView() -> CreatePinView {
        let controller = CreatePinViewController.controllerFromStoryboard(.auth)
        return controller
    }
    
    func makeLandingView() -> LandingView {
       return  LandingViewController.controllerFromStoryboard(.auth)
    }
    
    func makeRegisterHandler(viewModel: AuthViewModelImpl? = nil) -> RegisterView {
        let controller = RegisterViewController.controllerFromStoryboard(.auth)
        if let model = viewModel {
            controller.authViewModel = model
        }
        return controller
        
    }
    
    func makeOnboardingModule() -> OnboardingView {
        return OnboardingController.controllerFromStoryboard(.onboarding)
    }
    
    
    func makeLoginOutput() -> LoginView {
        return LoginController.controllerFromStoryboard(.auth)
    }
    
    
    func makeCustomHomePage() -> SelectLandingPageView {
        return CustomizeHomeLandingView.controllerFromStoryboard(.auth)
    }
    
    func makeVerifyPin() -> VerifyPinView {
        return VerifyPinViewController.controllerFromStoryboard(.dashboard)
    }
    
    func makeForgotPassword() -> ForgotPasswordView {
        return ForgotPasswordViewController.controllerFromStoryboard(.auth)
    }
    
    func makeLoginUpdateProfile() -> LoginUpdateProfileView{
        return LoginUpdateProfileViewController.controllerFromStoryboard(.auth)
    }
    
    func makeManageCardView() -> ManageCardView {
        return ManageCardViewController.controllerFromStoryboard(.wallet)
    }
    
    func makeManageBankView() -> ManageBankView {
        return ManageBankViewController.controllerFromStoryboard(.wallet)
    }
    
    func makemanageWalletItemView() -> ManageWalletView {
        return ManageWalletViewController.controllerFromStoryboard(.wallet)
    }
    
    func makeAddBankDetailView() -> AddBankView {
        return AddBankViewController.controllerFromStoryboard(.wallet)
    }
    
    func makeAddCardDetailView() -> AddCardView {
        return AddCardViewController.controllerFromStoryboard(.wallet)
    }
    
    func makeWalletItemDetailView(walletViewModel : WalletViewModelImpl,txnViewmodel:TransactionViewModelImpl) -> WalletItemDetailView {
        return WalletItemDetailViewController(walletViewModel: walletViewModel, txnViewmodelImpl: txnViewmodel)
    }
    
    func makeAddCardView() -> AddCardView {
        return AddCardViewController.controllerFromStoryboard(.wallet)
    }
    
    func makeAddBankView() -> AddBankView {
        return AddBankViewController.controllerFromStoryboard(.wallet) 
    }
    
    func makeCreateMomentView() -> CreateMomentView {
        return CreateMomentViewController.controllerFromStoryboard(.home)
    }
    
    func makeCreatePostView(dataController : DataController) -> CreatePostView {
        let controller =  CreatePostViewController.controllerFromStoryboard(.home)
        controller.dataController = dataController
        return controller
    }
    
    func makeHomeFollowingView() -> HomeFollowingView {
        return HomeFollowingViewController.controllerFromStoryboard(.home)
    }
    
    func makeTopUpCardView(walletViewModel: WalletViewModelImpl, chargeSource: ChargeSource) -> TopUpCardView{
        return TopUpCardViewController(walletViewModel: walletViewModel, chargeSource: chargeSource)
    }

    func makePayToEmailView(walletViewModel: WalletViewModelImpl) -> PayToEmailView {
        return PayToEmailViewController(walletViewModel: walletViewModel)
    }
    
    func makePayToIDView(walletViewModel: WalletViewModelImpl,title: String) -> PayToIDView {
        let viewController = PayToIDViewController(walletViewModel: walletViewModel,title: title)
        return viewController
    }
    
    func makePayToPhoneView(walletViewModel: WalletViewModelImpl) -> PayToPhoneView {
        return PayToPhoneViewController(walletViewModel: walletViewModel)
    }
    
    func makeCableView(_ walletViewModel: WalletViewModelImpl) -> CableView {
        return CableViewController.init(walletViewModel: walletViewModel)
    }
    
    func makeDataPurchaseView(_ walletViewModel: WalletViewModelImpl) -> DataPurchaseView {
        return DataPurchaseViewController(walletViewModel: walletViewModel)
    }
    
    func makeAirtimeView(_ walletViewModel: WalletViewModelImpl) -> AirtimeView {
        return AirtimeViewController(walletViewModel: walletViewModel)
    }
    
    func makeShowUtilityView(_ walletViewModel: WalletViewModelImpl) -> UtilityView {
        return UtilityViewController(walletViewModel: walletViewModel)
    }
    
    func makeSendRequest(_ walletViewModel: WalletViewModelImpl) -> SendRequestView {
        return SendRequestViewController(walletViewModel : walletViewModel)
    }
    
    func makeReceiveRequest(_ walletViewModel: WalletViewModelImpl) -> ReceiveRequestView {
        return ReceiveRequestViewController(walletViewModel: walletViewModel)
    }
    
    func makeAllRequest(_ walletViewModel: WalletViewModelImpl) -> AllRequestView {
        return AllRequestViewController(walletViewModel: walletViewModel)
    }
    
    func makeRequestPayment(_ walletViewModel: WalletViewModelImpl) -> RequestPaymentView {
        return RequestPaymentViewController(walletViewModel: walletViewModel)
    }
    
    func makeScanToPayView(_ walletViewModel: WalletViewModelImpl) -> ScanToPayView {
        return ScanToPayViewController(walletViewModel: walletViewModel)
    }
    
    func makeWithdrawView(_ walletViewModel: WalletViewModelImpl, mode: WithdrawMode) -> WithdrawView {
        return WithdrawViewController(walletViewModel: walletViewModel, mode: mode)
    }

    func makeBVNView(_ walletViewModel: WalletViewModelImpl) -> BVNView {
        return LinkBVNViewController(walletViewModel: walletViewModel)
    }
    
    func makeVerify(_ channel: ForgotOTPChannel, _ viewModel: AuthViewModel) -> AccountVerifyView {
        return VerifyViewController(channel: channel, viewModel: viewModel)
    }
}
