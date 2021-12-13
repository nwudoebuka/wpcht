//
//  CooporateAccountView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/5/21.
//

import UIKit
import SwiftValidator
import Signals

class CooporateAccountView: UIView, UITextFieldDelegate {
    let validator = Validator()
    
    lazy var organizationNameTextField : TextInput = {
        let textField = UI.textField(placeholder:  "Organization Name")
        textField.tag = 0
        return textField
    }()
    
    let organizationTypeTextField : TextInput = {
        let textField = UI.textField(placeholder: "Organization Type")
        textField.tag = 1
        return textField
    }()
    
    let businessTypeTextField : TextInput = {
        let textField = UI.textField(placeholder: "Business Type")
        textField.tag = 2
        return textField
    }()
    
    lazy var orgEmailAddress : TextInput = {
        let textField = UI.textField(placeholder: "Organization Email Address")
        textField.input.autocapitalizationType = .none
        textField.input.onEditingChanged.subscribe(with: self) {[weak textField] () in
            if let text = textField?.input.text {
                textField?.input.text = text.lowercased()
            }
        }
        textField.tag = 3
        return textField
    }()
    
    let orgPhoneNumber : TextInput = {
        let textField = UI.textField(placeholder: "Organization Phone Number")
        textField.tag = 4
        return textField
    }()
    
    lazy var aggregatorCode: TextInput = {
        let input = UI.textField(placeholder: "Aggregator Code")
        input.tag = 5
        return input
    }()
    
    let orgType = Picker()
    let businessType = Picker()
    
    lazy var countryPicker: UIView = {
        let view = UIView()
        let code = UI.text(string: "+234")
        view.addSubview(code)
        code.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        code.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return view
    }()
    
    let organisationTypes = ["Aggregator", "Agent", "Business Account"]
    var businessTypes = [BusinessType]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupValidation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        orgType.tag = 0
        orgType.dataSource = self
        orgType.delegate = self
        orgType.toolbarDelegate = self
        organizationTypeTextField.input.inputView = orgType
        organizationTypeTextField.input.inputAccessoryView = orgType.toolbar
        
        businessType.tag = 1
        businessType.dataSource = self
        businessType.delegate = self
        businessType.toolbarDelegate = self
        businessTypeTextField.input.inputView = businessType
        businessTypeTextField.input.inputAccessoryView = businessType.toolbar
        
        
        addSubview(organizationNameTextField)
        organizationNameTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        organizationNameTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        organizationNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        organizationNameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
       
        addSubview(organizationTypeTextField)
        organizationTypeTextField.topAnchor.constraint(equalTo: organizationNameTextField.bottomAnchor, constant: 20).isActive = true
        organizationTypeTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        organizationTypeTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        organizationTypeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(businessTypeTextField)
        businessTypeTextField.topAnchor.constraint(equalTo: organizationTypeTextField.bottomAnchor, constant: 20).isActive = true
        businessTypeTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        businessTypeTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        businessTypeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(orgEmailAddress)
        orgEmailAddress.topAnchor.constraint(equalTo: businessTypeTextField.bottomAnchor, constant: 20).isActive = true
        orgEmailAddress.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        orgEmailAddress.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        orgEmailAddress.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(orgPhoneNumber)
        orgPhoneNumber.topAnchor.constraint(equalTo: orgEmailAddress.bottomAnchor, constant: 20).isActive = true
        orgPhoneNumber.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        orgPhoneNumber.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        orgPhoneNumber.heightAnchor.constraint(equalToConstant: 30).isActive = true
        orgPhoneNumber.input.keyboardType = .phonePad
        orgPhoneNumber.input.leftView = countryPicker
        orgPhoneNumber.input.leftViewMode = .always
        countryPicker.widthAnchor.constraint(equalToConstant: 50).isActive = true
        countryPicker.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(aggregatorCode)
        aggregatorCode.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        aggregatorCode.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        aggregatorCode.heightAnchor.constraint(equalToConstant: 30).isActive = true
        aggregatorCode.topAnchor.constraint(equalTo: orgPhoneNumber.bottomAnchor, constant: 20).isActive = true
        aggregatorCode.isHidden = true
        
        orgPhoneNumber.input.delegate = self
        organizationNameTextField.input.delegate = self
        organizationTypeTextField.input.delegate = self
        businessTypeTextField.input.delegate = self
        orgEmailAddress.input.delegate = self
    }
    
    func setupValidation() {
        validator.registerField(orgPhoneNumber.input, rules: [RequiredRule(), MinLengthRule(length: 11), NumericRule()])
        validator.registerField(organizationNameTextField.input, rules: [RequiredRule()])
        validator.registerField(organizationTypeTextField.input, rules: [RequiredRule()])
        validator.registerField(businessTypeTextField.input, rules: [RequiredRule()])
        validator.registerField(orgEmailAddress.input, rules: [RequiredRule(), EmailRule()])
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == businessTypeTextField {
            if businessTypeTextField.input.text == "Aggregator" {
                aggregatorCode.isHidden = false
            } else {
                aggregatorCode.isHidden = true
            }
        }
        textField.resignFirstResponder()
        return true
    }
}

extension CooporateAccountView: UIPickerViewDelegate, UIPickerViewDataSource, PickerDelegate {
    func didTapDone(picker: Picker) {
        let row = picker.selectedRow(inComponent: 0)
        picker.selectRow(row, inComponent: 0, animated: true)
        organizationTypeTextField.resignFirstResponder()
        businessTypeTextField.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickerView.tag == 0) ? organisationTypes[row] : businessTypes[row].businessType
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (pickerView.tag == 0) ? organisationTypes.count : businessTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView.tag == 0) {
            organizationTypeTextField.input.text = organisationTypes[row]
        } else {
            if businessTypes.count > 0 {
                businessTypeTextField.input.text = businessTypes[row].businessType
            }
        }
    }
}
