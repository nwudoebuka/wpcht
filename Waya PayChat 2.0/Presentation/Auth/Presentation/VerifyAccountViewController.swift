//
//  VerifyAccountViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/5/21.
//
import Signals
protocol VerifyAccountView : BaseView {
    var goToCreatePin : (() -> Void)? {get set}   
    var goToLogin : (()-> Void)? { get set}
    var onComplete: ((Bool) -> Void)? {get set}
}

enum VerifyMode {
    case account
    case card
}

class VerifyAccountViewController: UIViewController, VerifyAccountView, Alertable{

    var goToCreatePin: (() -> Void)?
    var goToLogin: (() -> Void)?
    var onComplete: ((Bool) -> Void)?
    
    var transparentBackground : UIView!
    var authViewModel : AuthViewModelImpl?
    var resendOtpView : ResendOtpView!
    var cardViewModel: WalletViewModelImpl?
    
    var verifyMode: VerifyMode = .account    
    
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "lock1")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var bodyLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "A one time verification code has been \n sent to your phone number"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel_.textColor = UIColor(named: "color-gray1")
        headerLabel_.textAlignment = .center
        headerLabel_.numberOfLines = 3
        headerLabel_.font = UIFont(name: "Lato-Regular", size: 16)
        return headerLabel_
    }()
    
    var headerText : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Verify your Account"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textAlignment = .center
        headerLabel_.textColor = UIColor(named: "toolbar-color-secondary")
        headerLabel_.font = UIFont(name: "LibreBaskerville-Regular", size: 22)
        return headerLabel_
    }()
    
    let verifyButton : UIButton = {
        let button = UI.button(title: "Verify")
        return button
    }()
    
    let resendButton : UIButton = {
        let button = UI.button(title: "Did not get OTP?")
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor(named: "color-primary"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var otpStackView : PinStackView!
    
    let otpContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view 
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewConstraint()
        hideKeyboardWhenTappedAround()
        gestureHandler()
    }
    
    
    private func setUpViewConstraint(){
        otpStackView = PinStackView(frame: .zero, fields: 6, secure: false)
        otpStackView.translatesAutoresizingMaskIntoConstraints = false
        otpStackView.clipsToBounds = true
        
        view.addSubviews([
            headerImage, headerText, bodyLabel
        ])
        
        headerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerImage.widthAnchor.constraint(equalToConstant: view.frame.width * 0.44).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: view.frame.width * 0.44).isActive = true
        
        headerText.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 40).isActive = true
        headerText.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        headerText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bodyLabel.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 12).isActive = true
        bodyLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 80).isActive = true
        bodyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        view.addSubview(otpContainerView)
        otpContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        otpContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        otpContainerView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 24).isActive = true
        otpContainerView.heightAnchor.constraint(equalToConstant: (view.frame.width - 120)/6).isActive = true
        
        otpContainerView.addSubview(otpStackView)
        otpStackView.anchor(top: otpContainerView.topAnchor, leading: otpContainerView.leadingAnchor, bottom: otpContainerView.bottomAnchor, trailing: otpContainerView.trailingAnchor)
        
        view.addSubview(resendButton)
        resendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(verifyButton)
        verifyButton.bottomAnchor.constraint(equalTo: resendButton.topAnchor, constant: -40).isActive = true
        verifyButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        verifyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func gestureHandler(){
        verifyButton.addTarget(self, action: #selector(didTapVerify), for: .touchUpInside)
        resendButton.addTarget(self, action: #selector(showResendOtpView), for: .touchUpInside)
    }
    
    @objc func showResendOtpView(){
        if  self.transparentBackground == nil {
            self.transparentBackground = UIView(frame: UIScreen.main.bounds)
            self.transparentBackground.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleOKButtonTapped(_:)))
            tap.numberOfTapsRequired = 1
            self.transparentBackground.addGestureRecognizer(tap)
            self.transparentBackground.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.addSubview(self.transparentBackground)
            self.resendOtpView = ResendOtpView()
            self.resendOtpView.cornerWithWhiteBg(14)
            self.transparentBackground.addSubview(self.resendOtpView)
            self.resendOtpView.translatesAutoresizingMaskIntoConstraints = false
            self.resendOtpView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30))
            self.resendOtpView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            resendOtpView.isUserInteractionEnabled = true
            resendOtpView.button.addTarget(self, action: #selector(resendOtp), for: .touchUpInside)
            UIApplication.shared.keyWindow!.bringSubviewToFront(self.transparentBackground)
            self.view.bringSubviewToFront(self.transparentBackground)
            
        }
    }
    
    @objc func handleOKButtonTapped(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentBackground.alpha = 0
        }) {  done in
            self.resendOtpView.removeFromSuperview()
            self.transparentBackground.removeFromSuperview()
            self.transparentBackground = nil
        }
    }
    
    @objc func didTapVerify(){
        performVerification()
    }
    
    private func performVerification(){
        LoadingView.show()
        let otp = otpStackView.getOTP()
        if otp == "" {
            self.showAlert(message: "Please enter a valid OTP Code")
            return
        }
        if self.verifyMode == .account {
            let verifyOtpRequest = VerifyOtpRequest(otp: otp, phoneOrEmail: authViewModel!.createAccountRequest.phoneNumber )
            authViewModel!.verifyOtp(verifyOtpRequest: verifyOtpRequest) { [weak self](result) in
                LoadingView.hide()
                switch(result){
                    case .success(_):
                        self?.goToLogin?()
                    case .failure(.custom(let message)):
                        self?.showAlert(title: "Verification Failed", message: message)

                }
            }
        } else if verifyMode == .card {
            cardViewModel?.cardVerifyReq!.otp = otp
            cardViewModel!.verifyCardOtp(request: cardViewModel!.cardVerifyReq!) { [weak self] (result) in
                LoadingView.hide()
                switch result {
                case .success(let response):
                    if let response = response as? Response<String> {
                        self?.showAlert(message: response.message!)
                        self?.onComplete?(true)
                    } else {
                        self?.showAlert(message: "an unknown error occured")
                        self?.onComplete?(false)
                    }
                    
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                    self?.onComplete?(false)
                }
            }
        }
    }
    
    @objc func resendOtp(){
        LoadingView.show()
        guard let channel = authViewModel!.resendOTPChannel else {
            return
        }
        
        switch self.verifyMode {
        case .account:
            authViewModel!.resendTokenSignup(phoneOrEmail: channel.0) { [weak self] (result) in
                LoadingView.hide()
                let alert = UIAlertController()
                let action = UIAlertAction(title: "OK", style: .default) { (_) in
                    self?.handleOKButtonTapped(nil)
                }
                alert.addAction(action)
                switch(result){
                case .success(let message):
                    alert.title = "Success"
                    alert.message = (message as! String)
                case .failure(.custom(let message)):
                    alert.title = "Sending Verification Failed!"
                    alert.message = message
                }
                self?.present(alert, animated: true, completion: nil)
            }
        case .card:
            break
        }
        
        
    }

}
