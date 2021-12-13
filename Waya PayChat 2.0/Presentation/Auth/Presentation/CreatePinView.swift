//
//  CreatePinView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/5/21.
//

enum CreatePinMode {
    case validate
    case noValidate
}

protocol CreatePinView : BaseView {
    var pinSetSuccess : ((_ first_login: Bool) -> Void)? {get set}
    var otpChannel: ForgotOTPChannel? { get set }
    var oldPin: String? { get set}
}
