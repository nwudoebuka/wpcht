//
//  ChangePasswordViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 26/07/2021.
//

import UIKit

protocol ChangePasswordView {
    
}

class ChangePasswordViewController: UIViewController, SettingsView, Alertable {
    var onBack: ((Bool) -> Void)?
    var optionSelected: ((SettingsView?) -> Void)?
    var present: ((UIViewController) -> Void)?
    
    // class vars
    private var forgotView: ForgotDetailView!
    private var verifyView: OTPVerifyView!
    private var authViewModel = AuthViewModelImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        let backBtn = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backBtn
        title = "Change Password"
        start()
    }
    
    private func start() {
        forgotView = ForgotDetailView(true)
        forgotView.mode = .password(false)
        forgotView.toolbar.titleLabel.text = "Change Password"
        forgotView.onContinue?.subscribe(with: self, callback: { (channel, emailOrPhone) in
            let value = (channel == .phone) ? auth.data.profile!.phoneNumber : auth.data.profile!.email
            self.startChangePassword(emailOrPhone: value, channel: channel)
        })
        
        forgotView.onBack = { [weak forgotView] in
            forgotView?.removeFromSuperview()
            self.onBack?(false)
        }
        
        UIApplication.shared.keyWindow!.addSubview(forgotView)
        self.view.bringSubviewToFront(forgotView)
        forgotView.isUserInteractionEnabled = true
    }
    
    
    private func startChangePassword(emailOrPhone: String, channel: ForgotOTPChannel) {
        LoadingView.show()
        authViewModel.requestChangePassword(phoneOrEmail: emailOrPhone, channel: channel) { [weak self] (result) in
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
        authViewModel.changePasswordRequest = ChangePasswordRequest(newPassword: "", oldPassword: "", otp: "", phoneOrEmail: emailOrPhone)
        forgotView.removeFromSuperview()
        forgotView = nil
        let verifyView = OTPVerifyView(title: "Change Password", subtitle: "A one time verification code has been sent to the email/phone number you signed up with")
        verifyView.verifyButton.setTitle("Next", for: .normal)
        verifyView.onError = { [weak self] (error) in
            LoadingView.hide()
            self?.showAlert(message: error)
        }
        
        verifyView.onContinue.subscribe(with: self, callback: { (otp) in
            verifyView.removeFromSuperview()
            self.resetPassword(otp: otp)
        })
        
        verifyView.onResendOTPClicked.subscribe(with: self, callback: { () in
            LoadingView.show()
            self.resendOtp(emailOrPhone: emailOrPhone, channel: channel)
        })
        
        verifyView.onBack = {
            verifyView.removeFromSuperview()
            self.start()
        }
        
        UIApplication.shared.keyWindow!.addSubview(verifyView)
        self.view.bringSubviewToFront(verifyView)
        verifyView.isUserInteractionEnabled = true
    }
    
    private func resendOtp(emailOrPhone: String, channel: ForgotOTPChannel) {
        authViewModel.requestChangePassword(phoneOrEmail: emailOrPhone, channel: channel) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self.showAlert(message: "OTP Resent Successfully")
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    @objc func back() {
        self.onBack?(false)
    }
    
    private func resetPassword(otp: String) {
        authViewModel.changePasswordRequest.otp = otp
        let view = PasswordResetViewController(authViewModel: self.authViewModel, reset: false)
        view.onBackButtonTap = {
            view.dismiss(animated: true, completion: nil)
        }
        
        view.onPasswordReset = { [weak view] in
            DispatchQueue.main.async {
                view?.dismiss(animated: true, completion: nil)
                self.showResetSuccess()
                self.showAlert(message: "Your password was changed successfully, you will be logged out")
            }
        }
        self.present(view, animated: true, completion: nil)
    }
    
    private func showResetSuccess() {
        let alert = AlertView(frame: UIScreen.main.bounds, title: "Successful", mode: .success(.generic))
        alert.mode = .success(nil)
        alert.bodyLabel.text = "Your Password has been changed successfully"
        alert.continueButton.setTitle("Continue", for: .normal)
        alert.continueButton.onTouchUpInside.subscribe(with: self) { () in
            alert.removeFromSuperview()
            self.onBack?(true)
        }
        auth.data.loggedIn = false
        UIApplication.shared.keyWindow!.addSubview(alert)
        self.view.bringSubviewToFront(alert)
        alert.isUserInteractionEnabled = true
    }
}
