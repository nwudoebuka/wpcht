//
//  CorporateAccountDetailsView.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 05/06/2021.
//

import Foundation
import SwiftValidator

class CorporateAccountDetailsView: UIView {
    
    let validator = Validator()
    
    var surnameTextField : TextInput = {
        return UI.textField(placeholder: "Your Surname")
    }()
    
    var firstNameTextField : TextInput = {
        return UI.textField(placeholder: "Your Firstname")
    }()
    
    var stateTextField : TextInput = {
        return UI.textField(placeholder: "State")
    }()
    
    var cityTextField : TextInput = {
        return UI.textField(placeholder: "City")
    }()
    
    var officeAddressTextField : TextInput = {
        return UI.textField(placeholder: "Office Address")
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupView()
        setupValidation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupView() {
        self.addSubviews([
            firstNameTextField,
            surnameTextField,
            officeAddressTextField,
            cityTextField,
            stateTextField,
        ])
        
        NSLayoutConstraint.activate([
            
            surnameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            surnameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            surnameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            surnameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            firstNameTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 20),
            firstNameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            firstNameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            stateTextField.widthAnchor.constraint(equalTo: firstNameTextField.widthAnchor),
            stateTextField.centerXAnchor.constraint(equalTo: firstNameTextField.centerXAnchor),
            stateTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 20),
            stateTextField.heightAnchor.constraint(equalToConstant: 40),
            
            cityTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            cityTextField.topAnchor.constraint(equalTo: stateTextField.bottomAnchor, constant: 20),
            cityTextField.heightAnchor.constraint(equalToConstant: 40),
            cityTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),

            officeAddressTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            officeAddressTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            officeAddressTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 20),
            officeAddressTextField.heightAnchor.constraint(equalToConstant: 44),
        ])
        self.layoutIfNeeded()
    }
    
    func setupValidation() {
        validator.registerField(firstNameTextField.input, rules: [RequiredRule(), AlphaRule()])
        validator.registerField(surnameTextField.input, rules: [RequiredRule(), AlphaRule()])
        validator.registerField(officeAddressTextField.input, rules: [RequiredRule(), MinLengthRule(length: 10, message: "Please enter the full address")])
        validator.registerField(stateTextField.input, rules: [RequiredRule()])
        validator.registerField(cityTextField.input, rules: [RequiredRule()])
    }
}
