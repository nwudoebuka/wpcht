//
//  ResendOtpView.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/31/21.
//

import UIKit

class ResendOtpView: UIView {
        
    var titleLabel : UILabel!
    var subHeaderLabel : UILabel! 
    var bodyLabel : UILabel! 
    
    let stackView : UIStackView = {
        let stackView  = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 26
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let button : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
        button.setTitle("Resend OTP", for: .normal)
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "color-primary"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        titleLabel =  libreTextBold(text: "Get OTP", textSize: 18)
        subHeaderLabel = latoTextRegular(text: "Dial *347*006*5# to get OTP \n \n Verify via email address", textSize: 15, textColor: UIColor(named: "color-primary") ?? .orange)
        
        bodyLabel = latoTextRegular(text: "If you did not receive an OTP, you may possibly have your DO NOT DISTURB activated on your network provider. \n \n To enable you receive SMS/OTP please do the following:\n\n - MTN, text ALLOW to 2442.\n - GLO, text CANCEL to 2442.\n- AIRTEL, text STOP to 2442.\n- 9MOBILE, text START to 2442", textSize: 15, textColor: .black)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subHeaderLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(button)
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 27, left: 20, bottom: 36, right: 20))
    }

}
