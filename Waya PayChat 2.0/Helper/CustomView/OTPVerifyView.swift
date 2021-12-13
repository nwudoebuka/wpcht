//
//  OTPVerifyView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 19/07/2021.
//

import Foundation
import Signals

protocol VerifyView: UIView {
    var onError: ((String) -> Void)? { get set}
    var onContinue: Signal<(String)> { get set}
    var onResendOTPClicked: Signal<()> {get set}
    var title: String? {get set }
    var subtitle: String? { get set}
    var onBack: (() -> Void)? { get set}
}

final class OTPVerifyView: UIView, VerifyView {
    var title: String?
    
    var subtitle: String?
    
    var transparentBackground : UIView!
    var authViewModel : AuthViewModelImpl?
    var resendOtpView : ResendOtpView!
    var cardViewModel: WalletViewModelImpl?
    
//    var verifyMode: VerifyMode = .account
    var onError: ((String) -> Void)?
    var onContinue: Signal<(String)> = Signal<(String)>() // returns the OTP entered by the user to its parent view
    var onBack: (() -> Void)?
    var onResendOTPClicked: Signal<()> = Signal<()>()
    
    lazy var backButton: UIButton = {
        return UI.button(title: nil, icon: UIImage(named: "back-arrow-orange"), style: .icon, state: .active)
    }()
    
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "lock1")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var bodyLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textColor = UIColor(named: "color-gray1")
        headerLabel_.textAlignment = .center
        headerLabel_.numberOfLines = 3
        headerLabel_.font = UIFont(name: "Lato-Regular", size: 16)
        return headerLabel_
    }()
    
    var headerText : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textAlignment = .center
        headerLabel_.textColor = UIColor(named: "toolbar-color-secondary")
        headerLabel_.font = UIFont(name: "LibreBaskerville-Regular", size: 22)
        return headerLabel_
    }()
    
    var verifyButton : UIButton = {
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
    
    convenience init(title: String, subtitle: String) {
        self.init(frame: UIScreen.main.bounds)
        self.title = title
        self.subtitle = subtitle
        initView()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        backgroundColor = .white
        otpStackView = PinStackView(frame: .zero, fields: 6, secure: false)
        otpStackView.translatesAutoresizingMaskIntoConstraints = false
        otpStackView.clipsToBounds = true
        
        headerText.text = title
        bodyLabel.text = subtitle
        
        addSubviews([backButton, headerImage, headerText, bodyLabel, otpContainerView, resendButton, verifyButton])
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 22),
            backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 20),
            
            headerImage.topAnchor.constraint(equalTo: topAnchor, constant: 80),
            headerImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerImage.widthAnchor.constraint(equalToConstant: frame.width * 0.44),
            headerImage.heightAnchor.constraint(equalToConstant: frame.width * 0.44),
            
            headerText.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 40),
            headerText.widthAnchor.constraint(equalToConstant: frame.width - 32),
            headerText.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            bodyLabel.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 12),
            bodyLabel.widthAnchor.constraint(equalToConstant: frame.width - 80),
            bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            otpContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            otpContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            otpContainerView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 24),
            otpContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            resendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            resendButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            verifyButton.bottomAnchor.constraint(equalTo: resendButton.topAnchor, constant: -40),
            verifyButton.heightAnchor.constraint(equalToConstant: 44),
            verifyButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            verifyButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        otpContainerView.addSubview(otpStackView)
        otpStackView.anchor(top: otpContainerView.topAnchor, leading: otpContainerView.leadingAnchor, bottom: otpContainerView.bottomAnchor, trailing: otpContainerView.trailingAnchor)
        
        backButton.onTouchUpInside.subscribe(with: self) { [weak self] () in
            self?.onBack?()
        }
        verifyButton.addTarget(self, action: #selector(didTapVerify), for: .touchUpInside)
        resendButton.addTarget(self, action: #selector(didTapNoOTP), for: .touchUpInside)
    }
    
    private func showResendOtpView(){
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
            self.resendOtpView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30))
            self.resendOtpView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            resendOtpView.isUserInteractionEnabled = true
            resendOtpView.button.onTouchUpInside.subscribe(with: self) { () in
                DispatchQueue.main.async {
                    self.resendOtpView.removeFromSuperview()
                    self.transparentBackground.removeFromSuperview()
                    self.transparentBackground = nil
                    self.onResendOTPClicked => ()
                }
            }
            UIApplication.shared.keyWindow!.bringSubviewToFront(self.transparentBackground)            
        }
    }
    
    @objc func handleOKButtonTapped(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentBackground.alpha = 0
        }) {  done in
            self.transparentBackground.removeFromSuperview()
            self.transparentBackground = nil
        }
    }
    
    @objc func didTapNoOTP() {
        self.showResendOtpView()
    }
    
    @objc func didTapVerify() {
        let otp = self.otpStackView.getOTP()
        if otp == "" || otp.length != 6 {
            self.onError?("Please enter the complete OTP received")
        } else {
            self.onContinue => (otp)
        }
    }
}
