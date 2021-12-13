//
//  ForgotView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 18/07/2021.
//

import Foundation
import SwiftValidator
import Signals

enum ForgotOTPChannel {
    case email
    case phone
    var title: String {
        return (self == .phone) ? "Phone" : "Email"
    }
}

protocol ForgotView: UIView {
    var onBack: (() -> Void)? { get set}
    var onContinue: Signal<(ForgotOTPChannel, String?)>? { get set}
    var onResend: (() -> Void)? { get set}
    var mode: ResetMode { get set}
    var onError: ((String) -> Void)? { get set}
}

enum ResetMode {
    case password(_ reset: Bool)
    case pin(_ reset: Bool)
    
    var title: String {
        switch self {
        case .pin(let reset):
            return (reset == true) ? "Reset Pin" : "Change PIN"
        case .password(let reset):
            return (reset == true) ? "Reset Password" : "Change Password"
        }
        
    }
    var text: String {
        switch self {
        case .password(_):
            return "Please enter your details, we will send you a verification code to reset your password"
        case .pin(_):
            return "Please enter your details, we will send you a verification code to reset your pin"
        }
    }
}

final class ForgotDetailView: UIView, ForgotView, Alertable {
    
    var mode: ResetMode = .pin(true)  {
        didSet {
            self.redraw()
        }
    }
    var onBack: (() -> Void)?
    var onContinue: Signal<(ForgotOTPChannel, String?)>? = Signal<(ForgotOTPChannel, String?)>()
    var onResend: (() -> Void)?
    var onError: ((String) -> Void)?
    var authviewModel = AuthViewModelImpl()
    private var loggedIn: Bool!
    var toolbar  : CustomToolbar = {
        let toolbar = CustomToolbar()
        toolbar.backButton.setImage(UIImage(named: "back-arrow-orange"), for: .normal)
//        toolbar.rightButton1.isHidden = true
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.titleLabel.text = ""
        return toolbar
    }()
    
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    lazy var headerText: UILabel = {
        let label = UI.text(string: nil)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "LibreBaskerville-Bold", size: 22)
        return label
    }()
    
    lazy var subHeaderText : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "color-gray1")
        return label
    }()
    
    lazy var textField:  TextInput = {
        return UI.textField(placeholder: "Email/Phone")
    }()
    
    var  nextButton : UIButton = {
        return UI.button(title: "Next")
    }()
    
    let picker = UIPickerView()
    
    let resetOptions: [ForgotOTPChannel] = [.email, .phone]
    var selected: ForgotOTPChannel = .phone
    let validator = Validator()
    
    convenience init(_ loggedIn: Bool? = false) {
        self.init(frame: UIScreen.main.bounds)
        self.loggedIn = loggedIn!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func initView() {
        self.backgroundColor = .white
        toolbar.titleLabel.text = mode.title
        toolbar.titleLabel.textAlignment = .center
        toolbar.addBorder(.bottom, color: UIColor.black.withAlphaComponent(0.3), thickness: 0.3)
        toolbar.layer.shadowOffset = CGSize(width: 0, height: 3)
        toolbar.layer.shadowColor = UIColor.black.withAlphaComponent(0.9).cgColor
        toolbar.clipsToBounds = false
        
        let image = (self.mode.title.contains("password")) ? "forgot-password-icon" : "lock1"
        headerImage.image = UIImage(named: image)
        
        self.addSubviews([toolbar, headerImage, headerText, subHeaderText, textField, nextButton])
        toolbar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        headerImage.anchor(top: toolbar.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 51, left: 0, bottom: 0, right: 0))
        
        headerText.anchor(top: headerImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0))
        headerText.centerInSuperview()
        headerText.text = mode.title
        
        subHeaderText.text = mode.text
        subHeaderText.anchor(top: headerText.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 12, left: 32, bottom: 0, right: 32))
        
        textField.anchor(top: subHeaderText.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 30, left: 32, bottom: 0, right: 32))
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nextButton.anchor(top: textField.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 48, left: 32, bottom: 0, right: 32))
        nextButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        NSLayoutConstraint.activate([
            toolbar.heightAnchor.constraint(equalToConstant: 50),
            headerImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 160),
            headerImage.widthAnchor.constraint(equalToConstant: 160),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        if self.loggedIn == true {
            picker.delegate = self
            picker.dataSource = self
            picker.backgroundColor = .white
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didTapDone))
            toolbar.setItems([doneBtn], animated: true)
            
            textField.input.inputView = picker
            textField.input.inputAccessoryView = toolbar
        }
//        toolbar.
        textField.input.placeholder = "Email/Phone Number"
        addActions()
    }
    
    private func addActions() {
        validator.registerField(textField, rules: [RequiredRule()])
        toolbar.backButton.onTouchUpInside.subscribe(with: self) { () in
            self.onBack?()
        }.onQueue(.main)
        
        nextButton.onTouchUpInside.subscribe(with: self) { () in
            self.validator.validate(self)
        }
    }
    
    private func redraw() {
        toolbar.titleLabel.text = mode.title
        headerText.text = mode.title
        subHeaderText.text = mode.text
    }
}

extension ForgotDetailView: ValidationDelegate {
    func validationSuccessful() {
        self.onContinue? => (selected, textField.input.text!)
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for(field, error) in errors {
            if let field = field as? TextInput {
                field.errorLabel.text = error.errorMessage
                field.errorLabel.isHidden = false
            } else {
                self.onError?(error.errorMessage)
                break
            }
        }
    }
}

extension ForgotDetailView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    @objc func didTapDone() {
        let row = picker.selectedRow(inComponent: 0)
        picker.selectRow(row, inComponent: 0, animated: true)
        textField.input.text = resetOptions[row].title
        selected = resetOptions[row]
        self.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return resetOptions.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return resetOptions[row].title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.input.text = resetOptions[row].title
        selected = resetOptions[row]
    }
}
