//
//  PaymentSettingsViewController.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 17/07/2021.
//

import UIKit
import ScrollableView

class PaymentSettingsViewController: ScrollableView, SettingsView, Alertable {
    
    var onBack: ((Bool) -> Void)?
    var optionSelected: ((SettingsView?) -> Void)?
    var present: ((UIViewController) -> Void)?
    let authViewModel = AuthViewModelImpl()
    
    lazy var header: UIView = {
        return ProfileHeader.new()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hex: "#F8F8F8")
        self.setup()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = UIColor(hex: "#E5E5E5")
        content.spacing = 8
        
        let backBtn = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backBtn
        title = "Payment Settings"
        
        self.addViews([header])
        
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: 170),
            header.widthAnchor.constraint(equalTo: content.widthAnchor)
        ])
        generateButtons()
    }
    
    @objc func back() {
        self.onBack?(false)
    }

    private func generateButtons() {
        let buttons = PaymentSettings.allCases.map { (setting: PaymentSettings) -> LargeButton in
            let btn = LargeButton(title: setting.text.title, subtitle: setting.text.subtitle)
            btn.onTap.subscribe(with: self) {[weak self] () in
                self?.showView(setting: setting)
            }.onQueue(.main)
            return btn
        }
        self.addViews(buttons)
        buttons.forEach {
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 52),
                $0.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 22),
                $0.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -23),
            ])
            $0.clipsToBounds = false
        }
    }
    
    private func showView(setting: PaymentSettings) {
        switch setting {
        case .resetPin:
            let pinView = VerifyPinViewController()
            pinView.onPinSuccessful = { [weak self] (pin) in
                guard let pin = pin else {
                    self?.showAlert(message: "Unable to validate user pin")
                    return
                }
                pinView.dismiss(animated: false) {
                    self?.startResetPin(pin: pin)
                }
            }
            pinView.forgotPasswordButton.isHidden = true
            self.present?(pinView)
            
        case .editProfile, .disputeResolution, .manageCard, .manageBank, .credentials, .others:
            break
        }
    }
    
    private func startResetPin(pin: String) {
        
        let forgotView: ForgotView = ForgotDetailView(true) 
        forgotView.mode = .pin(false)
        forgotView.onBack = { [weak forgotView] in
            forgotView?.removeFromSuperview()
        }
        
        forgotView.onError = { [weak self] (error) in
            self?.showAlert(message: error)
        }
        
        forgotView.onContinue?.subscribe(with: self, callback: { [weak self] (channel, emailOrPhone) in
            DispatchQueue.main.async {
                forgotView.removeFromSuperview()
                self?.resetPin(pin: pin, channel: channel)
            }
        })
        
        self.view.addSubview(forgotView)
        self.view.bringSubviewToFront(forgotView)
        forgotView.isUserInteractionEnabled = true
    }
    
    private func resetPin(pin: String, channel: ForgotOTPChannel) {
        let view = CreatePinViewController()
        view.otpChannel = channel
        view.mode = .changePin
        view.oldPin = pin
        view.pinSetSuccess = { (first_login) in
            auth.logout()
            DispatchQueue.main.async {
                view.dismiss(animated: true) {
                    self.onBack?(true)
                }
            }
        }
        self.present?(view)
    }
}
