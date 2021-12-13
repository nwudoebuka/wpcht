//
//  PasswordView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/5/21.
//

protocol PasswordView: BaseView {
    var onBackNavigation: (() -> Void)? { get set }
    var goToVerifyAccount: ((_ authviewModel: AuthViewModelImpl?) -> Void)? {get set }
}
