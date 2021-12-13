//
//  CreatePinViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/5/21.
//
import UIKit
import Signals

enum PinSetMode {
    case newPin
    case changePin
    case reset
    
    var subtitle: String {
        return (self == .newPin) ? "A one time verification code has been sent \nto the phone number you signed up with" : "A one time verification code has been sent \nto the email/phone number you signed up with"
    }
    
    var title: String {
        return (self == .newPin) ? "Create PIN" : "Reset PIN"
    }
}

class CreatePinViewController: UIViewController, OTPDelegate , CreatePinView, Alertable {
    
    var pinSetSuccess: ((_ profileComplete: Bool) -> Void)?
    
    var otpChannel: ForgotOTPChannel? = .phone
    var oldPin: String?
    var authViewModel  = AuthViewModelImpl()
    var mode: PinSetMode = .newPin
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "lock2")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var bodyLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Keep your account safe with a 4 digit pin"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textColor = UIColor(named: "color-gray1")
        headerLabel_.textAlignment = .center
        headerLabel_.numberOfLines = 5
        headerLabel_.font = UIFont(name: "Lato-Regular", size: 16)
        return headerLabel_
    }()
    
    var headerText : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Create a secure Pin"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textAlignment = .center
        headerLabel_.textColor = UIColor(named: "toolbar-color-secondary")
        headerLabel_.font = UIFont(name: "LibreBaskerville-Regular", size: 22)
        return headerLabel_
    }()
    
    let continueButton : UIButton = {
        let button = UI.button(title: "Continue")
        return button
    }()
    
    
    var otpStackView : PinStackView = {
        var otpStack = PinStackView(frame: .zero, fields: 4)
        otpStack.translatesAutoresizingMaskIntoConstraints = false
        return otpStack
    }()
    
    var confirmOtpStackView : PinStackView = {
        var otpStack = PinStackView(frame: .zero, fields: 4)
        otpStack.translatesAutoresizingMaskIntoConstraints = false
        return otpStack
    }()
    
    let otpContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view 
    }()
    
    let confirmOtpContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view 
    }()
    
    var inputPinText : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Input PIN"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textAlignment = .left
        headerLabel_.textColor = UIColor(named: "toolbar-color-primary")
        headerLabel_.font = UIFont(name: "Lato-Regular", size: 16)
        return headerLabel_
    }()
    
    var confirmPinText : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Confirm New PIN"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textAlignment = .left
        headerLabel_.textColor = UIColor(named: "toolbar-color-primary")
        headerLabel_.font = UIFont(name: "Lato-Regular", size: 16)
        return headerLabel_
    }()
    
    var bottomConstraint : NSLayoutConstraint!
    
    var alertView: AlertView?
    var otpView: VerifyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpStackView.numberOfFields = 6
        setUpViewConstraint()
        gestureHandler()
    }
    
    private func setUpViewConstraint(){
        view.backgroundColor = .white
        view.addSubview(headerImage)
        headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerImage.widthAnchor.constraint(equalToConstant: view.frame.width * 0.44).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: view.frame.width * 0.44).isActive = true
        headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        view.addSubview(headerText)
        headerText.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 25).isActive = true
        headerText.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        headerText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        view.addSubview(bodyLabel)
        bodyLabel.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 12).isActive = true
        bodyLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
        bodyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bodyLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
       
        view.addSubview(inputPinText)
        inputPinText.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 28).isActive = true
        inputPinText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        
        view.addSubview(otpContainerView)
        otpContainerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        otpContainerView.topAnchor.constraint(equalTo: inputPinText.bottomAnchor, constant: 9).isActive = true
        otpContainerView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.13).isActive = true
        
        otpContainerView.addSubview(otpStackView)
        otpStackView.delegate = self
        otpStackView.heightAnchor.constraint(equalTo: otpContainerView.heightAnchor).isActive = true
        otpStackView.leadingAnchor.constraint(equalTo: otpContainerView.leadingAnchor, constant: 40).isActive = true
        otpStackView.centerYAnchor.constraint(equalTo: otpContainerView.centerYAnchor).isActive = true
        
        view.addSubview(continueButton)
        bottomConstraint = continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        bottomConstraint.isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
       
        
        view.addSubview(confirmPinText)
        confirmPinText.topAnchor.constraint(equalTo: otpContainerView.bottomAnchor, constant: 20).isActive = true
        confirmPinText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        inputView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        view.addSubview(confirmOtpContainerView)
        confirmOtpContainerView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        confirmOtpContainerView.topAnchor.constraint(equalTo: confirmPinText.bottomAnchor, constant: 9).isActive = true
        confirmOtpContainerView.heightAnchor.constraint(equalToConstant: view.frame.width * 0.13).isActive = true
        
        
        confirmOtpContainerView.addSubview(confirmOtpStackView)
        confirmOtpStackView.delegate = self
        confirmOtpStackView.heightAnchor.constraint(equalTo: confirmOtpContainerView.heightAnchor).isActive = true
        confirmOtpStackView.leadingAnchor.constraint(equalTo: confirmOtpContainerView.leadingAnchor, constant: 40).isActive = true
        confirmOtpStackView.centerYAnchor.constraint(equalTo: confirmOtpContainerView.centerYAnchor).isActive = true
        
    }
    
    func didChangeValidity(isValid: Bool) {
        
    }

    private func gestureHandler(){
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }
    
    @objc func didTapContinue(){
        let pin =  otpStackView.getOTP()
        let confirmPin = confirmOtpStackView.getOTP()
                
        guard pin == confirmPin else {
            self.showAlert(message: "Confirm PIN does not match")
            return
        }
        
        authViewModel.pinSetupComplete.subscribe(with: self) { (status, error) in
            DispatchQueue.main.async {
                LoadingView.hide()
                if status == true {
                    self.otpView?.removeFromSuperview()
                    self.showPinsetView()
                } else {
                    self.showAlert(title: "Pin set failed", message: error!)
                }
            }
        }
        LoadingView.show()
        switch mode {
        case .newPin:
            authViewModel.requestCreatePin(channel: .phone) { (result) in
                LoadingView.hide()
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.showOTPView()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(message: error.localizedDescription)
                    }
                }
            }
        case .changePin:
            authViewModel.requestPinChange(channel: self.otpChannel!) { (result) in
                LoadingView.hide()
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.showOTPView()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(message: error.localizedDescription)
                    }
                }
            }
        case .reset:
            authViewModel.requestResetPin(channel: self.otpChannel!) { (result) in
                LoadingView.hide()
                switch result {
                case .success(_):
                    DispatchQueue.main.async {
                        self.showOTPView()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.showAlert(message: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func showPinsetView(){
        alertView = AlertView(frame: UIScreen.main.bounds, title: "Your PIN is set", mode: .security)
        alertView?.headerImage.image = UIImage(named: "lock2")
        alertView?.bodyLabel.text = "You can sign in and out of your account \n with your secure PIN"
        alertView?.bodyLabel.isHidden = false
        alertView?.continueButton.setTitle("Continue", for: .normal)
        
        
        alertView?.layoutIfNeeded()
        alertView?.continueButton.onTouchUpInside.subscribe(with: self, callback: { () in
            DispatchQueue.main.async {
                self.alertView?.removeFromSuperview()
                let newProfile: Bool = (self.mode == .newPin) ? false : true
                self.pinSetSuccess?(newProfile)
            }
        })
        self.view.addSubview(alertView!)
        self.view.bringSubviewToFront(alertView!)
        alertView?.isUserInteractionEnabled = true
    }
    
    private func showOTPView() {
        otpView = OTPVerifyView(title: mode.title, subtitle: mode.subtitle)
        otpView?.onResendOTPClicked.subscribe(with: self) {
            self.resendOtp()
        }
        
        otpView?.onBack = { [weak otpView] in
            otpView?.removeFromSuperview()
        }
        
        otpView?.onContinue.subscribe(with: self) { [weak self] (otp) in
            self?.setPin(otp: otp)
        }
        
        self.view.addSubview(otpView!)
        self.view.bringSubviewToFront(otpView!)
        otpView?.isUserInteractionEnabled = true
    }
    
    private func resendOtp() {
        LoadingView.show()
        switch self.mode {
        case .newPin:
            authViewModel.requestCreatePin(channel: .phone) { (result) in
                LoadingView.hide()
                switch result {
                case .success(let message):
                    self.showAlert(message: message as! String)
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        case .changePin:
            authViewModel.requestPinChange(channel: self.otpChannel!) { (result) in
                LoadingView.hide()
                switch result {
                case .success(let message):
                    self.showAlert(message: message as! String)
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        case .reset:
            authViewModel.requestResetPin(channel: otpChannel!) { (result) in
                LoadingView.hide()
                switch result {
                case .success(let message):
                    self.showAlert(message: message as! String)
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func setPin(otp: String) {
        LoadingView.show()
        let trimPhone = (auth.data.profile!.phoneNumber.starts(with: "+") == true) ? auth.data.profile!.phoneNumber.substring(1) : auth.data.profile!.phoneNumber
        
        switch mode {
        case .newPin:
            let request = CreateAccountPinRequest(phoneOrEmail: trimPhone, pin: otpStackView.getOTP(), otp: otp)
            authViewModel.createAccountPin(createAccountPinRequest: request)
        case .changePin:
            let channel = (self.otpChannel! == .phone) ? trimPhone : auth.data.profile!.email
            let request = ChangePinRequest(newPin: otpStackView.getOTP(), oldPin: self.oldPin ?? "", otp: otp, phoneOrEmail: channel)
            authViewModel.changeUserPin(changeRequest: request)
        case .reset:
            let channel = (self.otpChannel! == .phone) ? trimPhone : auth.data.profile!.email
            let request = ResetPinRequest(phoneOrEmail: channel, pin: otpStackView.getOTP(), otp: otp)
            authViewModel.resetUserPin(request: request)
        }
    }
}
