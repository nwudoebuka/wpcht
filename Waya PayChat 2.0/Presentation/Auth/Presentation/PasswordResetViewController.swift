//
//  PasswordResetViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/6/21.
//
import SwiftValidator

protocol PasswordResetView: BaseView {
    var onBackButtonTap: (() -> Void)? {get set}
    var onPasswordReset: (() -> Void)? {get set}

}

class PasswordResetViewController: UIViewController, PasswordResetView, Alertable {
   
    // MARK: Hooks
    var onBackButtonTap: (() -> Void)?
    var onPasswordReset: (() -> Void)?
    
    var headerText  : UILabel = {
        let label = UI.text(string: "Reset Password")
        label.textAlignment = .center
        label.textColor = UIColor(named: "toolbar-color-secondary")
        label.font = UIFont(name: "LibreBaskerville-Regular", size: 18)
        return label
    }()
    
    var subHeaderText : UILabel = {
        let label = UI.text(string: "Please enter your new password")
        label.textColor = UIColor(named: "color-gray1")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    
    
    // MARK: UI COMPONENTS
    lazy var oldPasswordTextField : TextInput = {
        let txtField = UI.textField(placeholder: "Old Password")
        txtField.input.isSecureTextEntry = true
        txtField.input.rightView =  UIImageView(image: UIImage(named: "password-toogle-icon"))
        txtField.input.rightViewMode = .always
        txtField.input.rightView?.isUserInteractionEnabled = true
        txtField.input.isUserInteractionEnabled = true
        txtField.input.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleOldPassword)))
        txtField.isHidden = true
        return txtField
    }()
    
    lazy var passwordTextField : TextInput = {
        let txtField = UI.textField(placeholder: "New Password")
        txtField.input.isSecureTextEntry = true
        txtField.input.rightView =  UIImageView(image: UIImage(named: "password-toogle-icon"))
        txtField.input.rightViewMode = .always
        txtField.input.rightView?.isUserInteractionEnabled = true
        txtField.input.isUserInteractionEnabled = true
        txtField.input.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tooglePasswordVisibility)))
        return txtField
    }()
    
    var confirmPasswordTextField : TextInput = {
        let txtField = UI.textField(placeholder: "Confirm Password")
        txtField.input.isSecureTextEntry = true
        txtField.input.rightView =  UIImageView(image: UIImage(named: "password-toogle-icon"))
        txtField.input.rightViewMode = .always
        txtField.input.rightView?.isUserInteractionEnabled = true
        txtField.input.isUserInteractionEnabled = true
        txtField.input.rightView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toogleConfirmPasswordVisibility)))
        return txtField
    }()

    var resetButton : UIButton!
    
    var toolbar  : CustomToolbar = {
        let toolbar = CustomToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.titleLabel.text = ""
        return toolbar
    }()
    
    // MARK: DATA
    var authViewModel : AuthViewModelImpl!
    var reset: Bool!
    let validator = Validator()
    
    
    init(authViewModel : AuthViewModelImpl, reset: Bool? = true){
        self.authViewModel = authViewModel
        self.reset = reset!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    private func setUpViews(){
        view.backgroundColor = .white
        
        resetButton = customPrimaryButton(text: "Reset")
        
        view.addSubviews([toolbar, headerText, subHeaderText, oldPasswordTextField, passwordTextField, confirmPasswordTextField, resetButton])

        toolbar.backgroundColor = .white
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toolbar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        toolbar.backButton.onTouchUpInside.subscribe(with: self) { () in
            self.onBackButtonTap?()
        }
        
        
        if reset != true {
            oldPasswordTextField.isHidden = false
            
            NSLayoutConstraint.activate([
                oldPasswordTextField.topAnchor.constraint(equalTo: subHeaderText.bottomAnchor, constant: 50),
                oldPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                oldPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                oldPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
                
                passwordTextField.topAnchor.constraint(equalTo: oldPasswordTextField.bottomAnchor, constant: 27),
                passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
                passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            ])
            validator.registerField(oldPasswordTextField.input, errorLabel: oldPasswordTextField.errorLabel, rules: [RequiredRule(), PasswordRule()])
        } else {
            passwordTextField.topAnchor.constraint(equalTo: subHeaderText.bottomAnchor, constant: 50).isActive = true
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
            passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        NSLayoutConstraint.activate([
            headerText.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 90),
            headerText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerText.heightAnchor.constraint(equalToConstant: 27),
            
            subHeaderText.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 12),
            subHeaderText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            subHeaderText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 27),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            resetButton.heightAnchor.constraint(equalToConstant: 44),
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            resetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            resetButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 48)
        ])
        
        validator.registerField(passwordTextField.input, errorLabel: passwordTextField.errorLabel, rules: [RequiredRule(), PasswordRule()])
        validator.registerField(confirmPasswordTextField.input, errorLabel: confirmPasswordTextField.errorLabel, rules: [RequiredRule(), ConfirmationRule(confirmField: passwordTextField.input)])
        
        resetButton.onTouchUpInside.subscribe(with: self) { () in
            self.validator.validate(self)
        }
    }
    
    @objc func toggleOldPassword() {
        oldPasswordTextField.input.isSecureTextEntry.toggle()
    }
    
    @objc func tooglePasswordVisibility(){
        passwordTextField.input.isSecureTextEntry.toggle()
    }
    
    @objc func toogleConfirmPasswordVisibility(){
        confirmPasswordTextField.input.isSecureTextEntry.toggle()
    }
    
    @objc func didTapResetPassword(){
        passwordTextField.errorLabel.isHidden = true
        confirmPasswordTextField.errorLabel.isHidden = true
        validator.validate(self)
    }
}

extension PasswordResetViewController: ValidationDelegate {
    func validationSuccessful() {
        LoadingView.show()
        if self.reset == true {
            authViewModel.passwordResetRequest.newPassword = passwordTextField.input.text!
            authViewModel.resetPassword() { (result) in
                LoadingView.hide()
                switch result {
                case .success(_):
                    self.onPasswordReset?()
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        } else {
            authViewModel.changePasswordRequest.oldPassword = oldPasswordTextField.input.text!
            authViewModel.changePasswordRequest.newPassword = passwordTextField.input.text!
            authViewModel.changePassword { (result) in
                LoadingView.hide()
                switch result {
                case .success(_):
                    self.onPasswordReset?()
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
        
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            guard let field = field as? TextInput else{
                return
            }
            field.errorLabel.text = error.errorMessage
            field.errorLabel.isHidden = false
        }
    }
}
