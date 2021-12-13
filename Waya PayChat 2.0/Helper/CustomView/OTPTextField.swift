//
//  OtpTextField.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/5/21.
//

class OTPTextField: UITextField {
    weak var previousTextField: OTPTextField?
    weak var nextTextField: OTPTextField?
    override public func deleteBackward(){
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}
