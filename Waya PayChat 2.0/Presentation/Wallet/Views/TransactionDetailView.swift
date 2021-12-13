//
//  CustomProceedPaymentView.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/7/21.
//
import Signals

class TransactionDetailView: UIView {

    var alertView: WarningView!
    var beneficiaryNameView : BeneficiaryCustomView!
    var transcationView : BeneficiaryCustomView!
    var beneficiaryBankView : BeneficiaryCustomView!
    var messageLabel : UILabel!
    var confirmButton : UIButton!
    var otpStackView : PinStackView!
    
    var alert: WarningMode?
    var alertLabel: String?
    
    let transactionDetail : TransactionDetail!
    var source: ChargeSource!
    var topConstraint: NSLayoutConstraint!
    
    init(frame: CGRect, transactionDetail : TransactionDetail, alertType: WarningMode? = nil, warningLabel: String? = "") {
        self.transactionDetail = transactionDetail
        self.alert = alertType
        self.alertLabel = warningLabel
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder){
        fatalError("init\(coder) has not been implemented")
    }
    
    private func initView(){
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        
        alertView = WarningView(mode: self.alert, label: self.alertLabel)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        
        beneficiaryNameView = BeneficiaryCustomView()
        beneficiaryNameView.leftValueLabel.text  = transactionDetail.beneficary
        beneficiaryNameView.rightValueLabel.text = transactionDetail.amount.currencySymbol
        
        transcationView = BeneficiaryCustomView()
        transcationView.leftTitleLabel.text = transactionDetail.labelTitle
        transcationView.rightTitleLabel.text = "Transaction Fee"
        transcationView.leftValueLabel.text = transactionDetail.labelValue
        transcationView.rightValueLabel.text = transactionDetail.transactionFee
        
        beneficiaryBankView = BeneficiaryCustomView()
        beneficiaryBankView.leftTitleLabel.text = "Beneficiary Bank"
        beneficiaryBankView.rightTitleLabel.text = "Description"
        beneficiaryBankView.leftValueLabel.text = transactionDetail.bank
        beneficiaryBankView.rightValueLabel.text = transactionDetail.description ?? "Nil"
        beneficiaryBankView.leftValueLabel.textColor = .black
        beneficiaryBankView.rightValueLabel.textColor = .black
        
        messageLabel = latoTextRegular(text: "Please input your 4 digit pin to complete \ntransaction")
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        otpStackView = PinStackView(frame: .zero, fields: 4, style: .underline)
        
        confirmButton = UI.button(title: "Continue")
        confirmButton.alpha = 0.5
        confirmButton.isEnabled = false

        self.addSubviews([
            alertView, beneficiaryNameView, transcationView,
            beneficiaryBankView, messageLabel, confirmButton, otpStackView
        ])
        topConstraint = alertView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        NSLayoutConstraint.activate([
            topConstraint,
            alertView.leadingAnchor.constraint(equalTo: leadingAnchor),
            alertView.trailingAnchor.constraint(equalTo: trailingAnchor),
            alertView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        beneficiaryNameView.anchor(top: alertView.bottomAnchor, leading: leadingAnchor, bottom: nil,
                                   trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0))
        beneficiaryNameView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        beneficiaryNameView.addBorder(.bottom, color: UIColor.black.withAlphaComponent(0.5), thickness: 0.6)
        
        transcationView.anchor(top: beneficiaryNameView.bottomAnchor,  leading: leadingAnchor, bottom: nil,
                               trailing: trailingAnchor,
                               padding: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0))
        transcationView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        beneficiaryBankView.anchor(top: transcationView.bottomAnchor,  leading: leadingAnchor, bottom: nil, 
                               trailing: trailingAnchor,
                               padding: UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0))
        beneficiaryBankView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        messageLabel.anchor(top: beneficiaryBankView.bottomAnchor,  leading: leadingAnchor, bottom: nil, 
                               trailing: trailingAnchor,
                               padding: UIEdgeInsets(top: 38, left: 0, bottom: 0, right: 0))
        
        otpStackView.anchor(top: messageLabel.bottomAnchor,  leading: leadingAnchor, bottom: confirmButton.topAnchor,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 5, left: 50, bottom: 44, right: 50), size: CGSize(width: UIScreen.main.bounds.width - 100, height: 44))
        
        confirmButton.anchor(top: nil,  leading: leadingAnchor, bottom: bottomAnchor,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 0, left: 32, bottom: 70, right: 32))
        confirmButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        otpStackView.delegate = self
        
        alertView.onClose = {
            self.hideWarning()
        }
        if self.alertLabel == nil || self.alertLabel == "" || alert == nil {
            self.hideWarning()
        } else {
            alertView.text = self.alertLabel!
            alertView.mode = self.alert
        }
    }
    
    private func hideWarning() {
        topConstraint.constant = -61
    }
    
    func showWarning(type: WarningMode, text: String) {
        alertView.text = text
        alertView.mode = type
        topConstraint.constant = 0
    }
}

extension TransactionDetailView: OTPDelegate {
    func didChangeValidity(isValid: Bool) {
        confirmButton.isEnabled = isValid
        confirmButton.alpha = (isValid) ? 1.0 : 0.5
    }
}
