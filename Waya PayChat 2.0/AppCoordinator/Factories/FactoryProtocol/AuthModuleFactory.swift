//
//  AuthModuleFactory.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//

protocol AuthModuleFactory {
    func makeLoginOutput() -> LoginView
    func makeRegisterHandler(viewModel: AuthViewModelImpl?) -> RegisterView
    func makeLandingView() -> LandingView
    func makePasswordView(authViewModel : AuthViewModelImpl?) -> PasswordView
    func makeVerifyAccount(authViewModel : AuthViewModelImpl?) -> VerifyAccountView 
    func makeCreatePinView() -> CreatePinView
    func makeCustomHomePage() -> SelectLandingPageView
    func makeVerifyPin() -> VerifyPinView 
    func makeForgotPassword() -> ForgotPasswordView
    func makeLoginUpdateProfile() -> LoginUpdateProfileView
}
