//
//  CustomProceedPaymentView.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/7/21.
//


class TransactionDetailView: UIView {

    var beneficiaryNameView : BeneficiaryCustomView!
    var transcationView : BeneficiaryCustomView!
    var beneficiaryBankView : BeneficiaryCustomView!
    var messageLabel : UILabel!
    var confirmButton : UIButton!
    var otpStackView : PinStackView!
    
    let transactionDetail : TransactionDetail!
    
    init(frame: CGRect, transactionDetail : TransactionDetail ) {
        self.transactionDetail = transactionDetail
        super.init(frame: frame)
        initView()
    }
    
    private func initView(){
        beneficiaryNameView = BeneficiaryCustomView()
        beneficiaryNameView.leftValueLabel.text  = transactionDetail.beneficary
        beneficiaryNameView.rightValueLabel.text = transactionDetail.accountNo
        
        transcationView = BeneficiaryCustomView()
        transcationView.leftTitleLabel.text = transactionDetail.labelTitle
        transcationView.rightTitleLabel.text = "Transaction Fee"
        transcationView.leftValueLabel.text = transactionDetail.accountNo
        transcationView.rightValueLabel.text = transactionDetail.transactionFee
        
        beneficiaryNameView = BeneficiaryCustomView()
        beneficiaryNameView.leftTitleLabel.text = "Beneficiary Bank"
        beneficiaryNameView.rightTitleLabel.text = "Description"
        beneficiaryNameView.leftValueLabel.text = transactionDetail.bank
        beneficiaryNameView.rightValueLabel.text = transactionDetail.description
        
        messageLabel = latoTextRegular(text: "Please input your 4 digit pin to complete \ntransaction")
        
        otpStackView = PinStackView()
        let topLine = generateLine()
        
        confirmButton = generatePrimaryButton(title: "Confirm")

        addSubview(beneficiaryNameView)
        addSubview(transcationView)
        addSubview(topLine)
        addSubview(beneficiaryNameView)
        addSubview(messageLabel)
        addSubview(confirmButton)
        addSubview(otpStackView)
        
        beneficiaryNameView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, 
                                   trailing: trailingAnchor, padding: UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0))
        topLine.anchor(top: beneficiaryNameView.topAnchor,  leading: leadingAnchor, bottom: nil, 
                       trailing: trailingAnchor,
                       padding: UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0))
        
        transcationView.anchor(top: topLine.bottomAnchor,  leading: leadingAnchor, bottom: nil, 
                               trailing: trailingAnchor,
                               padding: UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0))
        
        beneficiaryNameView.anchor(top: transcationView.bottomAnchor,  leading: leadingAnchor, bottom: nil, 
                               trailing: trailingAnchor,
                               padding: UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0))
        
        messageLabel.anchor(top: beneficiaryNameView.bottomAnchor,  leading: leadingAnchor, bottom: nil, 
                               trailing: trailingAnchor,
                               padding: UIEdgeInsets(top: 38, left: 0, bottom: 0, right: 0))
        
        confirmButton.anchor(top: nil,  leading: leadingAnchor, bottom: bottomAnchor, 
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 0, left: 32, bottom: 70, right: 32), size: CGSize(width: UIScreen.main.bounds.width - 64, height: 44))
        
        otpStackView.anchor(top: nil,  leading: leadingAnchor, bottom: confirmButton.topAnchor, 
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 0, left: 50, bottom: 44, right: 50), size: CGSize(width: UIScreen.main.bounds.width - 100, height: 44))
        
        
    }
    
    required init?(coder: NSCoder){
        fatalError("init\(coder) has not been implemented")
    }

}
