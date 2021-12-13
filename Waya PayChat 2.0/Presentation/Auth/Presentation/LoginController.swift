//
//  LoginViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//
import SwiftValidator
import Signals

final class LoginController: UIViewController, LoginView, UITextFieldDelegate, Alertable {
    
    //controller handler
    var onLoginSuccessful: (() -> Void)?
    var onBackButtonTap: (() -> Void)?
    var onForgotPasswordTap: (() -> Void)?
    var verifyAccount: ((AuthViewModelImpl?) -> Void)?
    var createPin : (() -> Void)?
    
    var authViewModel  = AuthViewModelImpl()
    var profileViewModel  = ProfileViewModelImpl()
    var wayagramViewModel = WayagramViewModelImpl()
    let validator = Validator()
    
    let userDefault = UserDefaults.standard
    var password = ""
    var email = ""
    var forgotView: ForgotDetailView!
    var verifyView: OTPVerifyView?
    
    let backButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        let image = UIImage(named: "back-arrow")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
      
        return button
    }()
    
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "logo")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var headingLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Welcome Back"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel_.textColor = UIColor(named: "toolbar-color-secondary")
        headerLabel_.font = UIFont(name: "LibreBaskerville-Regular", size: 22)
        return headerLabel_
    }()
    
    let emailTextField : TextInput = {
        let textField = UI.textField(placeholder: "Email or phone number")
        textField.input.keyboardType = UIKeyboardType.emailAddress
        textField.input.enablesReturnKeyAutomatically = true
        textField.input.autocapitalizationType = .none
        return textField
    }()
    
    var passwordTextField : TextInput = {
        let txtField = UI.textField(placeholder: "Password")
        txtField.input.rightView =  UIImageView(image: UIImage(named: "password-toogle-icon"))
        txtField.input.rightViewMode = .always
        txtField.input.rightView?.isUserInteractionEnabled = true
        txtField.input.isUserInteractionEnabled = true
        txtField.input.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tooglePasswordVisibility)))
        return txtField
    }()
    
    @objc func tooglePasswordVisibility(){
        passwordTextField.input.isSecureTextEntry.toggle()
    }
    
    lazy var signInButton : UIButton = {
        let button  = UI.button(title: "Sign in")
        button.isUserInteractionEnabled = true
        return button
    }()
    
    lazy var forgotPasswordButton : UIButton = {
        let button  = UI.button(title: "Forgot Password?", style: .secondary)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 14)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewConstraint()
    }
    
    func setViewConstraint(){
        view.addSubview(backButton)
        view.addSubview(headerImage)
        
        backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerImage.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 22).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: 36).isActive = true
        headerImage.widthAnchor.constraint(equalToConstant: 86).isActive = true 
        
        
        view.addSubview(headingLabel)
        headingLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 90).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        if let first_name = auth.data.profile?.firstName {
            headingLabel.text = "Welcome Back \(first_name)"
        }
        
        view.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 40).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        
        view.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 26).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        
        view.addSubview(signInButton)
        signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 48).isActive = true
        signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 48).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        passwordTextField.input.rightView?.isUserInteractionEnabled = true
        passwordTextField.input.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tooglePasswordVisibility)))
        passwordTextField.input.isSecureTextEntry = true
        addObservers()
    }
    
    func addObservers() {
        authViewModel.loginComplete.subscribe(with: self) { [weak self] (status, _ detour: AuthViewModelImpl.Detour?, error) in
            DispatchQueue.main.async {
                LoadingView.hide()
                if let detour = detour {
                    switch detour {
                    case .verify:
                        self?.goToVerify()
                    case .pin:
                        self?.createPin?()
                    }
                } else if status == true {
                    self?.onLoginSuccessful?()
                } else {
                    self?.showAlert(message: error!)
                }
            }
        }.onQueue(.main)
        
        signInButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        
        validator.registerField(emailTextField, errorLabel: emailTextField.errorLabel, rules: [RequiredRule()])
        validator.registerField(passwordTextField, errorLabel: passwordTextField.errorLabel, rules: [RequiredRule(), PasswordRule()])
    }
    
    @objc func didTapLogin() {
        validator.validate(self)
    }
    
    @objc func didTapBack() {
        self.onBackButtonTap?()
    }
    
    @objc func didTapForgotPassword(){
        forgotView = ForgotDetailView(false)
        forgotView.mode = .password(true)
        forgotView.onContinue?.subscribe(with: self, callback: { (channel, emailOrPhone) in
            let value = (emailOrPhone!.isNumeric() == true || emailOrPhone!.starts(with: "+")) ? emailOrPhone!.formatPhoneNumber() : emailOrPhone!
            self.startResetPassword(emailOrPhone: value)
        })
        
        forgotView.onBack = { [weak forgotView] in
            forgotView?.removeFromSuperview()
        }
        
        self.view.addSubview(forgotView)
        self.view.bringSubviewToFront(forgotView)
        forgotView.isUserInteractionEnabled = true
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField{
            passwordTextField.resignFirstResponder()
        } else  if textField == emailTextField {
            emailTextField.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidAppear(animated)
    }
    
    private func startResetPassword(emailOrPhone: String) {
        LoadingView.show()
        
        let channel: ForgotOTPChannel = (emailOrPhone.isNumeric() == true || emailOrPhone.starts(with: "+")) ? .phone : .email
        authViewModel.requestResetPassword(phoneOrEmail: emailOrPhone, channel: channel) { [weak self] (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self?.showOTPView(emailOrPhone: emailOrPhone, channel: channel)
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func showOTPView(emailOrPhone: String, channel: ForgotOTPChannel) {
        authViewModel.passwordResetRequest = ResetPasswordRequest(newPassword: "", otp: "", phoneOrEmail: emailOrPhone)
        forgotView.removeFromSuperview()
        forgotView = nil
        verifyView = OTPVerifyView(title: "Reset Password", subtitle: "A one time verification code has been sent to the email/phone number you signed up with")
        verifyView?.verifyButton.setTitle("Next", for: .normal)
        verifyView?.onError = { [weak self] (error) in
            LoadingView.hide()
            self?.showAlert(message: error)
        }
        
        verifyView?.onContinue.subscribe(with: self, callback: { (otp) in
            self.verifyView?.removeFromSuperview()
            self.resetPassword(otp: otp)
        })
        
        verifyView?.onResendOTPClicked.subscribe(with: self, callback: { () in
            LoadingView.show()
            self.resendOtp(emailOrPhone: emailOrPhone, channel: channel)
        })
        
        verifyView?.onBack = {
            self.verifyView?.removeFromSuperview()
            self.verifyView = nil
        }
        
        self.view.addSubview(verifyView!)
        self.view.bringSubviewToFront(verifyView!)
        verifyView?.isUserInteractionEnabled = true
    }
    
    private func resendOtp(emailOrPhone: String, channel: ForgotOTPChannel) {
        authViewModel.requestResetPassword(phoneOrEmail: emailOrPhone, channel: channel) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self.showAlert(message: "OTP Resent Successfully")
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func resetPassword(otp: String) {
        authViewModel.passwordResetRequest.otp = otp
        let view = PasswordResetViewController(authViewModel: self.authViewModel)
        view.onBackButtonTap = {
            view.dismiss(animated: true, completion: nil)
        }
        
        view.onPasswordReset = { [weak view] in
            DispatchQueue.main.async {
                view?.dismiss(animated: true, completion: nil)
                self.showResetSuccess()
            }
        }
        self.present(view, animated: true, completion: nil)
    }
    
    private func showResetSuccess() {
        let alert = AlertView(frame: UIScreen.main.bounds, title: "Successful", mode: .success(.generic))
        alert.bodyLabel.text = "Your Password has been reset successfully"
        alert.continueButton.setTitle("Login", for: .normal)
        alert.continueButton.onTouchUpInside.subscribe(with: self) { () in
            alert.removeFromSuperview()
        }
        
        UIApplication.shared.keyWindow!.addSubview(alert)
        self.view.bringSubviewToFront(alert)
        alert.isUserInteractionEnabled = true
    }
}

extension LoginController: ValidationDelegate {
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            guard let field = field as? TextInput else {
                return
            }
            field.errorLabel.isHidden = false
            field.errorLabel.text = error.errorMessage
        }
    }
    
    func validationSuccessful() {
        LoadingView.show()
        if emailTextField.text.isNumeric() {
            let username = emailTextField.text.formatPhoneNumber()
            authViewModel.loginRequest.emailOrPhoneNumber = username
            authViewModel.resendOTPChannel = (emailOrPhone: username, channel: .phone)
        } else {
            authViewModel.loginRequest.emailOrPhoneNumber = emailTextField.text
            authViewModel.resendOTPChannel = (emailOrPhone: emailTextField.text, channel: .email)
        }
        authViewModel.loginRequest.password = passwordTextField.text
        authViewModel.login()
    }
    
    func goToVerify() {
        
        self.showSimpleTwoOptionAlert(title: "Error", messageTitle: "Yes", body: "Your Email/Phone already exists but is not verified. complete your Registration now?") {
            self.verifyAccount?(self.authViewModel)
        }
    }
}

