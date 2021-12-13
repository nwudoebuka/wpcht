//
//  LinkBVNViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 16/08/2021.
//

import Foundation
import SwiftValidator

protocol BVNView: BaseView {
    var onComplete: (() -> Void)? { get set}
}

class LinkBVNViewController: UIViewController, BVNView, Alertable {
    var onComplete: (() -> Void)?
    var walletViewModel: WalletViewModelImpl!
    var verifyView: OTPVerifyView?
    let viewModel = ProfileViewModelImpl()
    var alertView: AlertView?
    private var helpPopup: BVNHelpPopup?
    
    lazy var titleLabel: UILabel = {
        let txt = UI.text(string: "Please input your BVN", style: .normal, color: .gray)
        txt.textAlignment = .center
        return txt
    }()
    
    lazy var bvnTextField: TextInput = {
        let field = UI.textField(label: nil, placeholder: "Input your BVN (11 digits)")
        field.input.keyboardType = .numberPad
        return field
    }()
    
    lazy var confirmBVNField: TextInput = {
        let field = UI.textField(placeholder: "Confirm BVN")
        field.input.keyboardType = .numberPad
        return field
    }()
    
    lazy var submitButton: UIButton = {
        return UI.button(title: "Next")
    }()
    
    lazy var instructionLabel: UILabel = {
        let txt = UI.text(string: "Dial *565*0# to get BVN")
        txt.textAlignment = .center
        return txt
    }()
    
    lazy var helpLabel: UIButton = {
        return UI.button(title: "Why we need your BVN ?", icon: nil, style: .secondary, state: .active)
    }()
    
    let validator = Validator()
    
    init(walletViewModel : WalletViewModelImpl){
        self.walletViewModel = walletViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init \(coder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        title = "Add BVN"
        
        self.view.addSubviews([titleLabel, bvnTextField, confirmBVNField, submitButton, instructionLabel, helpLabel])
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 0))
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        bvnTextField.anchor(top: titleLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 60, left: 31, bottom: 0, right: 31))
        bvnTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        confirmBVNField.anchor(top: bvnTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 27, left: 31, bottom: 0, right: 31))
        confirmBVNField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        helpLabel.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 80, bottom: 60, right: 80))
        helpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        instructionLabel.anchor(top: nil, leading: view.leadingAnchor, bottom: helpLabel.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 80, bottom: 58, right: 80))
        
        submitButton.anchor(top: nil, leading: view.leadingAnchor, bottom: instructionLabel.topAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 30, bottom: 57, right: 30))
        submitButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        setupActions()
    }
    
    private func setupActions() {
        validator.registerField(bvnTextField, errorLabel: bvnTextField.errorLabel, rules: [RequiredRule(), NumericRule(), MinLengthRule(length: 11, message: "BVN must be 11 numeric characters"), MaxLengthRule(length: 11, message: "BVN must be 11 numeric characters")])
        validator.registerField(confirmBVNField, errorLabel: confirmBVNField.errorLabel, rules: [RequiredRule(), NumericRule(), ConfirmationRule(confirmField: bvnTextField, message: "!BVN and confirmation does not match")])
        submitButton.onTouchUpInside.subscribe(with: self) { () in
            self.validator.validate(self)
        }
        
        helpLabel.onTouchUpInside.subscribe(with: self) { () in
            self.showBVNHelp()
        }
    }
    
    
    private func showBVNHelp() {
        helpPopup = BVNHelpPopup(frame: UIScreen.main.bounds)
        helpPopup?.onClose = {
            self.helpPopup?.removeFromSuperview()
            self.helpPopup = nil
        }
        
        UIApplication.shared.keyWindow!.addSubview(helpPopup!)
        UIApplication.shared.keyWindow!.bringSubviewToFront(helpPopup!)
        helpPopup?.isUserInteractionEnabled = true
    }
    
    private func completeVerification() {
        verifyView = OTPVerifyView(title: "Verify your BVN", subtitle: "A one time verification code has been \nsent to your email address")
        
        verifyView?.onResendOTPClicked.subscribe(with: self, callback: { () in
            self.resendOTP()
        })
        
        verifyView?.onContinue.subscribe(with: self, callback: { (otp) in
            self.verifyBVN(otp: otp)
        })
        UIApplication.shared.keyWindow!.addSubview(verifyView!)
        UIApplication.shared.keyWindow!.bringSubviewToFront(verifyView!)
        verifyView?.isUserInteractionEnabled = true
    }
    
    
    private func verifyBVN(otp: String) {
        LoadingView.show()
        let request = ValidateBVNRequest(otp: otp, user: String(auth.data.profile!.userId))
        viewModel.verifyBVN(request: request) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self.verifyView?.removeFromSuperview()
                self.showSuccess()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func resendOTP() {
        LoadingView.show()
        
        viewModel.resendOTPForBVN(completion: { [weak self] (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self?.showAlert(message: "OTP resent successfully")
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        })
    }
    
    private func showSuccess() {
        alertView = AlertView()
        alertView?.headerText.text = "BVN Linked\nSuccessfully"
        alertView?.bodyLabel.isHidden = true
        alertView?.continueButton.setTitle("Finish", for: .normal)
        alertView?.continueButton.onTouchUpInside.subscribe(with: self, callback: { () in
            self.alertView?.removeFromSuperview()
            self.onComplete?()
        })
        
        UIApplication.shared.keyWindow!.addSubview(alertView!)
        UIApplication.shared.keyWindow!.bringSubviewToFront(alertView!)
        alertView?.isUserInteractionEnabled = true
    }
}

extension LinkBVNViewController: ValidationDelegate {
    func validationSuccessful() {
        
        guard let dob = auth.data.profile?.dateOfBirth, dob != "" else {
            self.showAlert(message: "No valid date of birth provided, please update your profile with a valid date of birth")
            return
        }
        LoadingView.show()
        viewModel.linkBVN(bvn: bvnTextField.text) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self.completeVerification()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            guard let field = field as? TextInput else {
                self.showAlert(message: error.errorMessage)
                return
            }
            
            field.errorLabel.text = error.errorMessage
            field.errorLabel.isHidden = false
        }
    }
}


class BVNHelpPopup: UIView {
    
    lazy var popup: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = false
        view.layer.cornerRadius = 14
        view.layer.shadowRadius = 4
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 4)
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let icon = UIImage(named: "close-icon")
        return UI.button(title: nil, icon: icon, style: .icon, state: .active)
    }()
    
    lazy var header: UILabel = {
        let view = UI.text(string: "Why we need your\nBVN?")
        view.font = UIFont(name: "Lato-Regular", size: 24)?.bold
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    lazy var fill: UIView = {
        let fill = UIView()
        fill.translatesAutoresizingMaskIntoConstraints = false
        fill.backgroundColor = UIColor(hex: "#EB5757").withAlphaComponent(0.1)
        return fill
    }()
    
    lazy var fillText: UILabel = {
        let txt = UI.text(string: "Linking your BVN doesn’t give WAYA\naccess to your bank information or\nbalances.")
        txt.textColor = UIColor(hex: "#EB5757")
        txt.textAlignment = .center
        txt.numberOfLines = 0
        return txt
    }()
    
    lazy var needLabel: UILabel = {
        let txt = UI.text(string: "We only to need to access to your:", style: .normal, color: .gray)
        txt.textAlignment = .center
        return txt
    }()
    
    lazy var needValue: UILabel = {
        let txt = UI.text(string: "Full Name\nPhone Number\nDate of Birth", style: .bold)
        txt.numberOfLines = 0
        txt.textAlignment = .center
        return txt
    }()
    
    var onClose: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init \(coder) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        
        
        fill.addSubview(fillText)
        popup.addSubviews([header, closeButton, fill, needLabel, needValue])
        
        header.anchor(top: popup.topAnchor, leading: popup.leadingAnchor, bottom: nil, trailing: popup.trailingAnchor, padding: UIEdgeInsets(top: 41, left: 63, bottom: 0, right: 63))
        closeButton.anchor(top: popup.topAnchor, leading: nil, bottom: nil, trailing: popup.trailingAnchor, padding: UIEdgeInsets(top: 21, left: 0, bottom: 0, right: 21))
        closeButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        closeButton.onTouchUpInside.subscribe(with: self) { () in
            self.dismiss()
        }
        
        fill.anchor(top: header.bottomAnchor, leading: popup.leadingAnchor, bottom: nil, trailing: popup.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 41, bottom: 0, right: 41))
        fill.heightAnchor.constraint(equalToConstant: 60).isActive = true
        fillText.anchor(top: fill.topAnchor, leading: fill.leadingAnchor, bottom: fill.bottomAnchor, trailing: fill.trailingAnchor, padding: UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10))
        
        needLabel.anchor(top: fill.bottomAnchor, leading: popup.leadingAnchor, bottom: nil, trailing: popup.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 41, bottom: 0, right: 41))
        needValue.anchor(top: needLabel.bottomAnchor, leading: popup.leadingAnchor, bottom: popup.bottomAnchor, trailing: popup.trailingAnchor, padding: UIEdgeInsets(top: 16, left: 50, bottom: 35, right: 50))
        
        self.addSubviews([popup])
        popup.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        popup.heightAnchor.constraint(equalTo: popup.widthAnchor).isActive = true
        popup.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismiss)))
    }
    
    @objc func dismiss() {
        self.onClose?()
    }
}
