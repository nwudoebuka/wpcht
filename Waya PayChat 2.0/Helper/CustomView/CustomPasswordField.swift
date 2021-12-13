//
//  CustomPasswordField.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/31/21.
//

import UIKit

class CustomPasswordField: UIView, UITextFieldDelegate {
    
    lazy var titleTextField : TextInput = {
        let textField = UI.textField()
        textField.input.isSecureTextEntry = true
        textField.input.rightView =  UIImageView(image: UIImage(named: "password-toogle-icon"))
        textField.input.rightViewMode = .always
        return textField
    }()
    
    let titleLine : UIView = {
        let line = UIView()
        line.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.3)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
    
        
        addSubview(titleTextField)
        titleTextField.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        
        addSubview(titleLine)
        titleLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        titleLine.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 2).isActive = true
        
        titleTextField.input.delegate = self
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case titleTextField :
                titleTextField.resignFirstResponder()
            default:
                break
        }
        return true
    }
}

