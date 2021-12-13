//
//  PasswordViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/5/21.
//

import SafariServices
import SwiftValidator
import Signals

final class PasswordViewController: UIViewController, PasswordView, SFSafariViewControllerDelegate, Alertable, UITextFieldDelegate {
    
    var goToVerifyAccount: ((AuthViewModelImpl?) -> Void)?
    var onBackNavigation: (() -> Void)?
    var authViewModel : AuthViewModelImpl?
    var coorporate : Bool = false
    let userDefualts = UserDefaults.standard
    let validator = Validator()
    
    let backButton : UIButton = {
        let button = UI.button(title: nil, icon: UIImage(named: "back-arrow"), style: .icon)        
        return button
    }()
    
    var headingLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Register cont."
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel_.textColor = UIColor(named: "toolbar-color-secondary")
        headerLabel_.font = UIFont(name: "LibreBaskerville-Regular", size: 18)
        return headerLabel_
    }()
    
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "logo")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var instructionLabel : UILabel = {
        let string = "Password must be at least 8 character \n and  contain 1 Number, Special case, \n Upper case and Lower case"
        let headerLabel_ = UI.text(string: string)
        headerLabel_.numberOfLines = 0
        headerLabel_.textColor = UIColor(named: "color-gray1")
        headerLabel_.font = UIFont(name: "Lato-Regular", size: 16)
        return headerLabel_
    }()
    
    var referralTextField : TextInput = {
        let headerLabel_ = UI.textField(placeholder: "Referral Code")
        return headerLabel_
    }()
    
    
    lazy var passwordTextField : TextInput = {
        let txtField = UI.textField(placeholder: "Password")
        txtField.input.rightView =  UIImageView(image: UIImage(named: "password-toogle-icon"))
        txtField.input.rightViewMode = .always
        return txtField
    }()
    
    lazy var confirmPasswordTextField : TextInput = {
        let txtField = UI.textField(placeholder: "Confirm Password")
        txtField.input.rightView =  UIImageView(image: UIImage(named: "password-toogle-icon"))
        txtField.input.rightViewMode = .always
        return txtField
    }()

    var nextButton : UIButton = {
        let button  = UI.button(title: "Next", style: .primary, state: .inactive)
        return button
    }()
    
    var termsLabel : UILabel = {
        let label = UILabel()
        let regularAttr :  [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 12) ?? UIFont(),
                                                             NSAttributedString.Key.foregroundColor:   UIColor(named: "toolbar-color-primary") ?? UIColor.orange,
        ]
        let linkAttributes :  [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 12) ?? UIFont(),
                                                                NSAttributedString.Key.foregroundColor:   UIColor(named: "color-primary") ?? UIColor.orange,
                                                                NSAttributedString.Key.underlineStyle: 1
        ]
        let attrText = NSMutableAttributedString(string: "By signing up, you agree with the terms and conditions")
        attrText.addAttributes(linkAttributes, range: NSRange(location: 34, length: 20))
        attrText.addAttributes(regularAttr, range: NSRange(location: 0, length: 33))
        label.attributedText = attrText
        
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var policyLabel : UILabel = {
        let label = UILabel()
        let regularAttr :  [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 12) ?? UIFont(),
                                                             NSAttributedString.Key.foregroundColor:   UIColor(named: "toolbar-color-primary") ?? UIColor.orange,
        ]
        let linkAttributes :  [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 12) ?? UIFont(),
                                                                //NSAttributedString.Key.link :"https://www.hackingwithswift.com",
                                                                
                                                                NSAttributedString.Key.foregroundColor:   UIColor(named: "color-primary") ?? UIColor.orange,
                                                                NSAttributedString.Key.underlineStyle: 1
        ]
        let attrText = NSMutableAttributedString(string: "and privacy policy")
        attrText.addAttributes(linkAttributes, range: NSRange(location: 4, length: 14))
        attrText.addAttributes(regularAttr, range: NSRange(location: 0, length: 3))
        label.attributedText = attrText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3        
        label.textAlignment = .center
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewConstraint()
        setUpGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidAppear(animated)
        setupValidation()
    }
    
    @objc func tooglePasswordVisibility(){
        passwordTextField.input.isSecureTextEntry.toggle()
    }
    
    @objc func toogleConfirmPasswordVisibility(){
        confirmPasswordTextField.input.isSecureTextEntry.toggle()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField{
            passwordTextField.resignFirstResponder()
        } else  if textField == confirmPasswordTextField {
            confirmPasswordTextField.resignFirstResponder()
        } else if textField == referralTextField{
            referralTextField.resignFirstResponder()
        }
        return true
    }

    func setViewConstraint(){
        view.addSubviews([
            headerImage, backButton, headingLabel, instructionLabel,
            passwordTextField, confirmPasswordTextField, policyLabel, nextButton, termsLabel
        ])
        NSLayoutConstraint.activate([
            headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            headerImage.heightAnchor.constraint(equalToConstant: 36),
            headerImage.widthAnchor.constraint(equalToConstant: 86),
            
            backButton.centerYAnchor.constraint(equalTo: headerImage.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            
            headingLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        
        
        if authViewModel?.createAccountRequest.type == .corporate {
            
            view.addSubview(referralTextField)
            instructionLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 24).isActive = true
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            instructionLabel.textAlignment = .center
            
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            referralTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 40).isActive = true
            referralTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            referralTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
            referralTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            passwordTextField.topAnchor.constraint(equalTo: referralTextField.bottomAnchor, constant: 20).isActive = true
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
            passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        } else {
            passwordTextField.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 20).isActive = true
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            passwordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
            passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            let passwordHint = """
                - Password must be at least 8 characters or more \n
                - must contain a Number, \n
                - must contain a Special case, \n
                - must contain at least an Upper case \n
                - must contain at least a Lower case
            """
            
            let attributedString = NSMutableAttributedString(string: passwordHint)

            // *** Create instance of `NSMutableParagraphStyle`
            let paragraphStyle = NSMutableParagraphStyle()

            // *** set LineSpacing property in points ***
            paragraphStyle.lineSpacing = 0.4 // Whatever line spacing you want in points
            paragraphStyle.lineHeightMultiple = 0.7

            // *** Apply attribute to string ***
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

            // *** Set Attributed String to your label ***
            instructionLabel.attributedText = attributedString
            
            instructionLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
            instructionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            instructionLabel.textColor = Colors.darkerBlue
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20).isActive = true
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            confirmPasswordTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
       
        passwordTextField.input.isSecureTextEntry = true
        
        passwordTextField.input.rightView?.isUserInteractionEnabled = true
        passwordTextField.input.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tooglePasswordVisibility)))

        confirmPasswordTextField.input.isSecureTextEntry = true
        
        confirmPasswordTextField.input.rightView?.isUserInteractionEnabled = true
        confirmPasswordTextField.input.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toogleConfirmPasswordVisibility)))
        
        nextButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        
        policyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        policyLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true        
        policyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        
        termsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -10).isActive = true
        termsLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true        
        termsLabel.bottomAnchor.constraint(equalTo: policyLabel.topAnchor).isActive = true
        
        nextButton.isEnabled = false
        passwordTextField.input.delegate = self
        confirmPasswordTextField.input.delegate = self
        referralTextField.input.delegate = self
    }
    
    @objc func openPrivacyPolicy(gesture: UITapGestureRecognizer){
        
        let range  = NSRange(location: 34, length: 20)
        let tapLocation = gesture.location(in: termsLabel)
        let tapIndex = termsLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        if tapIndex > range.location  && tapIndex < range.location + range.length{
            let urlString = "https://www.wayapaychat.com/privacy-page"
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                vc.delegate = self
                present(vc, animated: true)
            }
        }
    }    
    
    @objc func openTermsAndConditon(gesture: UITapGestureRecognizer) {
        let range  = NSRange(location: 34, length: 20)
        let tapLocation = gesture.location(in: termsLabel)
        let tapIndex = termsLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        if tapIndex > range.location  && tapIndex < range.location + range.length{
            let urlString = "https://www.wayapaychat.com/terms-of-use"
            if let url = URL(string: urlString) {
                print("Okkpr")
                let vc = SFSafariViewController(url: url)
                vc.delegate = self
                present(vc, animated: true)
            }
        }
    }
    
    private func setUpGesture(){
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        termsLabel.isUserInteractionEnabled = true
        termsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTermsAndConditon(gesture:))))
        
        policyLabel.isUserInteractionEnabled = true
        policyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPrivacyPolicy(gesture:))))
        
        passwordTextField.input.addTarget(self, action: #selector(activateButton), for: .editingChanged)
        confirmPasswordTextField.input.addTarget(self, action: #selector(activateButton), for: .editingChanged)
    }
    
    func setupValidation() {
        self.validator.registerField(passwordTextField, errorLabel: passwordTextField.errorLabel, rules: [RequiredRule(), PasswordRule(message: "Password is invalid")])
        self.validator.registerField(confirmPasswordTextField, errorLabel: confirmPasswordTextField.errorLabel, rules: [RequiredRule(), ConfirmationRule(confirmField: passwordTextField.input, message: "!Password and confirmation does not match")])
    }
    
    @objc func didTapBackButton(){
        onBackNavigation?()
    }
    
    @objc func didTapNextButton(){
        confirmPasswordTextField.errorLabel.isHidden = true
        self.validator.validate(self)
    }
    
    @objc func activateButton(){
        
        if passwordTextField.input.text != nil && passwordTextField.input.text == confirmPasswordTextField.input.text && passwordTextField.input.text != "" {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.3
        }
    }
    
    func createAccount(){
        LoadingView.show()
        authViewModel?.registerComplete.subscribe(with: self) { (success, error) in
            
            LoadingView.hide()
            if let error = error {
                if error == "This email already exists" || error == "This Phone number already exists" {
                    self.showSimpleTwoOptionAlert(title: "Create Account!", messageTitle: "Verify Account", body: error, action: {
                        self.resendOtpAndContinue()
                    })
                } else {
                     self.showAlert(title: "Create Account Failed!", message: error)
                }
            } else {
                self.goToVerifyAccount?(self.authViewModel)
            }
        }.onQueue(.main)
        
        authViewModel?.createAccount()
    }
    
    private func resendOtpAndContinue() {
        DispatchQueue.main.async {
            self.authViewModel!.resendOTPChannel = (self.authViewModel!.createAccountRequest.phoneNumber, .phone)
            let email = self.authViewModel!.createAccountRequest.data["email"] as! String
            LoadingView.show()
            self.authViewModel?.resendTokenSignup(phoneOrEmail: email, completion: { (result) in
                LoadingView.hide()
                switch result {
                case .success(_):
                    self.goToVerifyAccount?(self.authViewModel)
                case .failure(let error):
                    print("error resending OTP: \(error)")
                    self.showAlert(message: "Something went wrong, please try again")
                }
            })
        }
        
    }
}


extension PasswordViewController: ValidationDelegate {
    func validationSuccessful() {
        authViewModel?.createAccountRequest.data["referenceCode"] = referralTextField.text
        authViewModel?.createAccountRequest.data["password"] = passwordTextField.text
        createAccount()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for(field, error) in errors {
            guard let _field = field as? TextInput else {
                return
            }
            
            if _field == passwordTextField {
                self.showAlert(message: "Password is Invalid")
            } else {
                _field.errorLabel.text = error.errorMessage
                _field.errorLabel.isHidden = false
            }
        }
    }
}
