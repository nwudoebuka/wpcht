//
//  AuthCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/3/21.
//

//fileprivate var onboardingWasShown = UserDefaults.standard.bool(forKey: "HasLaunched")
fileprivate var authorize = auth

fileprivate enum AuthInstructor {
    case main, auth, onboarding
    
    static func configure() -> AuthInstructor {
        
        if authorize.data.onboardingShown {
            return .onboarding
        }

        if authorize.data.appLockStatus == .locked {
            return .auth
        }
        return .main
    }
}

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorOutput {
    var finishFlow: (() -> Void)?
    
    private var instructor: AuthInstructor {
        return AuthInstructor.configure()
    } 
    
    private let factory: AuthModuleFactory
    private let router: Router
    let authViewModel = AuthViewModelImpl()

    init(router: Router, factory: AuthModuleFactory) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        if auth.data.profile == nil {
            showLanding()
        } else {
            showLanding(moveToLogin: true)
        }
    }
    
    //MARK: - Run current flow controllers
    
    private func showLogin() {
        let loginOutput = factory.makeLoginOutput()
        loginOutput.onLoginSuccessful = { [weak self] in
            self?.showVerifyPin()
        }
        loginOutput.onBackButtonTap = { [weak self] in
            self?.router.popToRootModule(animated: true)
        }
        
        loginOutput.createPin = { [weak self] in
            self?.showCreatePinView()
        }
        
        loginOutput.verifyAccount = {[weak self](authViewModel) in
            self?.router.popToRootModule(animated: true)
            self?.showRegister()
        }
        router.push(loginOutput)
    }
    
    private func showLanding(moveToLogin: Bool? = false) {
        let landingOutput = factory.makeLandingView()
        landingOutput.onLoginButtonTap = { [weak self] in
            self?.showLogin()
        }
        landingOutput.onRegisterButtonTap = {
            [weak self] in
            self?.showRegister()
        }
        router.setRootModule(landingOutput)
        if moveToLogin == true {
            showLogin()
        }
    }
    
    private func showRegister(viewModel: AuthViewModelImpl? = nil) {
        let register = factory.makeRegisterHandler(viewModel: viewModel)
        
        register.onBackButtonPressed = { [weak self] in
            self?.router.popModule()
        }
       
        register.onNextButtonTap = { [weak self] (authViewModel) in
            self?.showPasswordView(authViewModel: authViewModel)
        }
        router.push(register)
    }
    
    private func showPasswordView(authViewModel: AuthViewModelImpl) {
        let password = factory.makePasswordView(authViewModel: authViewModel)
        
        password.onBackNavigation = { [weak self] in
            self?.router.popModule()
        }
     
        password.goToVerifyAccount = { [weak self] authViewModel in
            self?.showVerifyAccountView(authViewModel: authViewModel)
        }
        router.push(password)
    }
    
    
    private func showVerifyAccountView(authViewModel: AuthViewModelImpl?){
        let verifyAccountPin = factory.makeVerifyAccount(authViewModel: authViewModel)
        
        verifyAccountPin.goToCreatePin = { [weak self] in
            self?.showCreatePinView()
        }
                
        verifyAccountPin.goToLogin = { [weak self] in
            self?.router.popModule()       
            self?.showLogin()
        }
        router.push(verifyAccountPin)
    }
    
    private func showCreatePinView(){
        let createPin = factory.makeCreatePinView()
        createPin.otpChannel = .phone
        createPin.pinSetSuccess = { [weak self] (profileComplete) in
            if (!profileComplete) {
                self?.showLoginUpdateprofile()
            } else {
                self?.showCustomHomePage()
            }
        }
        router.push(createPin)
    }
    
    private func showCustomHomePage() {
        let customHomePage = factory.makeCustomHomePage()
       
        customHomePage.finishAuthFlow  = { [weak self] in
            if let profile = auth.data.profile {
                if profile.isCompleted == true {
                    self?.finishFlow?()
                } else {
                    self?.showLoginUpdateprofile()
                }
            } else {
                self?.showLoginUpdateprofile()
            }
        }
        router.push(customHomePage)
    }
    
    private func showVerifyPin(){
        let verifyPin = factory.makeVerifyPin()
        
        verifyPin.onPinSuccessful = {[weak self] (pin) in
            auth.toggleLock(status: .walletUnlocked)
            if auth.prefs.defaultView != nil {
                if let profile = auth.data.profile {
                    if profile.isCompleted == true {
                        self?.finishFlow?()
                    } else {
                        self?.showLoginUpdateprofile()
                    }
                } else {
                    self?.showLoginUpdateprofile()
                }
            } else {
                self?.showCustomHomePage()
            }
        }
        
        verifyPin.forgotPin = {
            self.router.popToRootModule(animated: true)
        }
        router.push(verifyPin)
    }
    
    private func showLoginUpdateprofile(){
        let loginUpdateProfile = factory.makeLoginUpdateProfile()
        
        loginUpdateProfile.onUpdateComplete = {[weak self]  in
            self?.finishFlow?()
        }
    
        loginUpdateProfile.onCancelTapped = { [weak self] in
            self?.finishFlow?()
        }
        router.push(loginUpdateProfile)
    }
}
