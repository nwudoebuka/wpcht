//
//  TransferBottomSheetView.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/6/21.
//

import UIKit

class TransferBottomSheetView: UIView {

    var topLine = UIView()
    var titleLabel : UILabel!
    var payToEmailButton : UIButton!
    var payToIndividualButton : UIButton!
    var payToWayaId : UIButton!
    var scanToPay : UIButton!
    var payToPhone : UIButton!
    var sendToBeneficiary : UIButton!
    
    var emailLine : UIView!
    var idLine : UIView!
    var scanLine : UIView!
    var phoneLine : UIView!
    var beneLine : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func  initView(){
        topLine.backgroundColor = UIColor(named: "sliver-gray") ?? .black
        addSubview(topLine)
        topLine.sizeAnchor(height: nil, width: nil, heightConstant: 4, widthConstant: 50)
        topLine.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        topLine.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        topLine.cornerRadius(4)
        
        titleLabel = libreTextBold(text: "Transfer Funds", textSize: 16)
        payToEmailButton = buttonWithImageRight(image: UIImage(named: "ic_pay_email")!, text: "Pay to Email")
        payToIndividualButton = buttonWithImageRight(image: UIImage(named: "ic_pay_person")!, text: "Pay to Waya ID")
        payToWayaId = buttonWithImageRight(image: UIImage(named: "ic_pay_person")!, text: "Pay to Waya ID")
        scanToPay = buttonWithImageRight(image: UIImage(named: "ic_pay_scan")!, text: "Scan to pay")
        payToPhone = buttonWithImageRight(image: UIImage(named: "ic_pay_phone")!, text: "Pay to Phone")
        sendToBeneficiary = buttonWithImageRight(image: UIImage(named: "ic_pay_beneficiary")!, text: "Send to Beneficiaries")

        emailLine = generateLine()
        idLine = generateLine()
        scanLine = generateLine()
        phoneLine = generateLine()
        beneLine = generateLine()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 0))
        
        addSubview(payToEmailButton)
        payToEmailButton.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                          padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 0))
        addSubview(payToIndividualButton)
        payToIndividualButton.anchor(top: payToEmailButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                          padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 0))
        
        addSubview(emailLine)
        emailLine.anchor(top: payToIndividualButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                         padding: UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: 1))
        
        addSubview(payToWayaId)
        payToWayaId.anchor(top: emailLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                          padding: UIEdgeInsets(top: 17, left: 24, bottom: 0, right: 0))
        
        addSubview(idLine)
        idLine.anchor(top: payToWayaId.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                         padding: UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: 1))
        
 
        addSubview(scanToPay)
        scanToPay.anchor(top: idLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                           padding: UIEdgeInsets(top: 17, left: 24, bottom: 0, right: 0))
        
        addSubview(scanLine)
        scanLine.anchor(top: scanToPay.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                         padding: UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: 1))
        
        addSubview(payToPhone)
        payToPhone.anchor(top: scanLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                         padding: UIEdgeInsets(top: 17, left: 24, bottom: 0, right: 0))
        
        addSubview(phoneLine)
        phoneLine.anchor(top: payToPhone.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                        padding: UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: 1))
        
        addSubview(sendToBeneficiary)
        sendToBeneficiary.anchor(top: phoneLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                          padding: UIEdgeInsets(top: 17, left: 24, bottom: 0, right: 0))
        
    }
    
    func generateLine(color : UIColor = UIColor(named: "sliver-gray") ?? .gray) -> UIView {
        let line = UIView()
        line.backgroundColor =  color.withAlphaComponent(0.3)
        return line
    }
}
