//
//  HandleView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 26/08/2021.
//

import Foundation
import Signals
import SwiftValidator

class HandleView: UIView, WayagramSetupView {
    let onContinue = Signal<()>()
    var onBack: (() -> Void)?
    var onError: ((String) -> Void)?
    
    let rightButton = UI.button(title: "Continue")
    let validator = Validator()
    
    lazy var toolbar  : CustomToolbar = {
        self.rightButton.titleLabel?.font = UIFont(name: "Lato-Regular", size: 12)?.withWeight(.medium)
        let toolbar = CustomToolbar(rightItems: [self.rightButton], leftItems: nil)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.backButton.isHidden = true
        return toolbar
    }()
    
    var titleLabel = UI.text(string: "Setup Wayagram Handle", style: .bold)
    var handleInput = TextInput(label: nil, placeHolder: "Wayagram handle", errorLabel: "e.g @JohnDoe")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        handleInput.errorLabel.textColor = Colors.lighterText
        handleInput.errorLabel.isHidden = false
        titleLabel.textAlignment = .center
        self.backgroundColor = .white
        self.addSubviews([toolbar, titleLabel, handleInput])
        
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toolbar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        titleLabel.anchor(top: toolbar.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 0))
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        handleInput.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 35, left: 21, bottom: 0, right: 21))
        handleInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        validator.registerField(handleInput, errorLabel: handleInput.errorLabel, rules: [RequiredRule(), RegexRule(regex: "^[a-zA-Z0-9_-]*$", message: "Only alphanumeric, dash and underscores allowed")])
        
        rightButton.onTouchUpInside.subscribe(with: self) {
            self.validator.validate(self)
        }
        
        handleInput.input.text = auth.data.wayagramProfile?.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HandleView: ValidationDelegate {
    func validationSuccessful() {
        self.onContinue => ()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for(field, error) in errors {
            if let field = field as? TextInput {
                field.errorLabel.text = error.errorMessage
                field.errorLabel.textColor = Colors.red
            } else {
                self.onError?(error.errorMessage)
            }
        }
    }
}
