//
//  LoginView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/3/21.
//

protocol LoginView: BaseView {
    var onLoginSuccessful: (() -> Void)? { get set }
    var onBackButtonTap: (() -> Void)? { get set }
    var onForgotPasswordTap : (() -> Void)? { get set}
    var verifyAccount : ((_ authViewModel: AuthViewModelImpl?) -> Void)? { get set}  
    var createPin : (() -> Void)? { get set}
}
