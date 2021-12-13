//
//  WalletPinPopView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/12/21.
//

import UIKit

class WalletPinPopView: UIView, OTPDelegate {
 

    var headerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 24)
        label.textColor = UIColor(named: "toolbar-color-secondary")
        label.text = "Input your 4 digit pin"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var bodyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textColor = UIColor(named: "color-gray1")
        label.numberOfLines = 0
        label.text = "Please input your 4 digit pin to create \n a new wallet"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var otpStackView : PinStackView = {
        var otpStack = PinStackView(frame: .zero, fields: 4)
        otpStack.translatesAutoresizingMaskIntoConstraints = false
        return otpStack
    }()
    
    let otpContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view 
    }()
    
    let createWalletButton : UIButton = {
        let button = UI.button(title: "Create Wallet")
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func  initView(){
        addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 90).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
   
        addSubview(bodyLabel)
        bodyLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24).isActive = true
        bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(otpStackView)
        otpStackView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 24).isActive = true
        otpStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        addSubview(createWalletButton)
        createWalletButton.topAnchor.constraint(equalTo: otpStackView.bottomAnchor, constant: 24).isActive = true
        createWalletButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        createWalletButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        createWalletButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    func didChangeValidity(isValid: Bool) {
        
    }
    
}
