//
//  PasswordView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/5/21.
//

protocol PasswordView: BaseView {
    var onBackNavigation: (() -> Void)? { get set }
    var goToVerifyAccount: ((_ authviewModel: AuthViewModelImpl?) -> Void)? {get set }
}
