//
//  LandingView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//

protocol LandingView : BaseView {
    var onLoginButtonTap : (() -> Void)? { get set}
    var onRegisterButtonTap : (() -> Void)? {get set}
}
