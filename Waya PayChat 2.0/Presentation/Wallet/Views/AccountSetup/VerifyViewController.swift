//
//  VerifyViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 31/08/2021.
//

import Foundation

protocol AccountVerifyView: BaseView {
    var dismiss: (() -> Void)? { get set }
    var channel: ForgotOTPChannel { get set}
}

final class VerifyViewController: UIViewController, AccountVerifyView, Alertable {
    var dismiss: (() -> Void)?
    var channel: ForgotOTPChannel
    private var viewModel: AuthViewModel!
    
    init(channel: ForgotOTPChannel, viewModel: AuthViewModel) {
        self.channel = channel
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showOTPSentSuccess(resend: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func showOTPSentSuccess(resend: Bool) {
        let title: String = (channel == .email) ? "email" : "messages"
        let successView = AlertView(frame:  UIScreen.main.bounds, title: nil, mode: .success(.generic))
        successView.bodyLabel.text = "OTP sent successfully, please check your \(title) to continue"
        successView.continueButton.setTitle("Continue", for: .normal)
        successView.continueButton.onTouchUpInside.subscribe(with: self, callback: { [weak successView] () in
            successView?.removeFromSuperview()
            if resend == false {
                self.completeVerification()
            }
        }).onQueue(.main)
        
        self.view.addSubview(successView)
        successView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        self.view.bringSubviewToFront(successView)
        successView.isUserInteractionEnabled = true
    }
    
    private func resendOTP() {
        LoadingView.show()
        viewModel.resendAuthOTP(phoneOrEmail: nil, channel: channel) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self.showOTPSentSuccess(resend: true)
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func completeVerification() {
//        successView?.removeFromSuperview()
//        successView = nil
        let title = (channel == .email) ? "Verify Email" : "Verify Phone"
        let subtitle = (channel == .email) ? "Please enter the OTP sent to your email" : "Please enter the OTP sent to your phone"
        let otpView = OTPVerifyView(title: title, subtitle: subtitle)
        otpView.frame = UIScreen.main.bounds
        otpView.onBack = {
            self.dismiss?()
        }

        otpView.onError = { [weak self] (error) in
            self?.showAlert(message: error)
        }

        otpView.onResendOTPClicked.subscribe(with: self, callback: { () in
            self.resendOTP()
        })

        otpView.onContinue.subscribe(with: self) { [weak self] (otp) in
            self?.validateOTP(otp: otp, parent: otpView)
        }
        
        self.view.addSubview(otpView)
        otpView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        otpView.isUserInteractionEnabled = true
        self.view.bringSubviewToFront(otpView)
    }
    
    private func validateOTP(otp: String, parent: OTPVerifyView) {
        LoadingView.show()
        viewModel.verifyEmailOrPhone(otp: otp, channel: channel) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    parent.removeFromSuperview()
                    self.showVerifySuccess()
                }
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
        
    }
    
    private func showVerifySuccess() {
        let title = (channel == .phone) ? "phone number" : "email"

        let successView = AlertView(frame:  UIScreen.main.bounds, mode: .success(.generic))
        successView.bodyLabel.text = "Your \(title) has been verified successfully"
        successView.continueButton.setTitle("Back to Home", for: .normal)
        
        self.view.addSubview(successView)
        successView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        self.view.bringSubviewToFront(successView)
        successView.isUserInteractionEnabled = true
        if channel == .phone {
            auth.data.profile!.phoneVerified = true
            auth.data.completedKyc?.append(.phoneVerify)
        } else {
            auth.data.profile!.emailVerified = true
            auth.data.completedKyc?.append(.emailVerify)
        }
        auth.updateLocalPrefs()
        successView.continueButton.onTouchUpInside.subscribe(with: self, callback: { () in
            DispatchQueue.main.async {
                self.dismiss?()
            }
        })
    }
}
