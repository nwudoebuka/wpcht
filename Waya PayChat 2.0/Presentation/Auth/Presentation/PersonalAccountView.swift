//
//  PersonalAccountView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/4/21.
//
import UIKit
import SwiftValidator
import Signals

class PersonalAccountView: UIView {

    let validator = Validator()
    
    lazy var firstNameTextField : TextInput = {
        let textField = UI.textField(placeholder: "First Name")
        textField.tag = 0
        return textField
    }()
    
    lazy var surnameTextField : TextInput = {
        let textField = UI.textField(placeholder: "Surname")
        textField.tag = 1
        return textField
    }()
    
    
    lazy var emailTextField : TextInput = {
        let textField = UI.textField(placeholder: "Email Address")
        textField.input.autocapitalizationType = .none
        textField.input.onEditingChanged.subscribe(with: self) {[weak textField] () in
            if let text = textField?.input.text {
                textField?.input.text = text.lowercased()
            }
        }
        textField.tag = 2
        return textField
    }()

    
    lazy var phoneNumberTextField : TextInput = {
        let textField = UI.textField(placeholder: "Phone Number")
        textField.input.keyboardType = .numberPad
        textField.tag = 3
        return textField
    }()
    
    let referralTextField : TextInput = {
        let textField = UI.textField(placeholder: "Referral code")
        textField.tag = 4
        return textField
    }()
    
    
    lazy var countryPicker: UIView = {
        let view = UIView()
        let code = UI.text(string: "+234")
        view.addSubview(code)
        code.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        code.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupView()
        setupValidation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        addSubviews([ firstNameTextField, surnameTextField, emailTextField, phoneNumberTextField, referralTextField])
        
        NSLayoutConstraint.activate([
            firstNameTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            firstNameTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40),
            firstNameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            
            surnameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 24),
            surnameTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            surnameTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            surnameTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            surnameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            emailTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 24),
            emailTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            emailTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 24),
            phoneNumberTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            phoneNumberTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40),
            
            referralTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 24),
            referralTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30),
            referralTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            referralTextField.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        phoneNumberTextField.input.leftView = countryPicker
        phoneNumberTextField.input.leftViewMode = .always
        countryPicker.widthAnchor.constraint(equalToConstant: 50).isActive = true
        countryPicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupValidation() {
        validator.registerField(firstNameTextField, rules: [RequiredRule(), MinLengthRule(length: 3)])
        validator.registerField(surnameTextField, rules: [RequiredRule(), MinLengthRule(length: 3)])
        validator.registerField(emailTextField, rules: [RequiredRule(), EmailRule()])
        validator.registerField(phoneNumberTextField, rules: [RequiredRule(), MinLengthRule(length: 11), NumericRule()])
    }
}
