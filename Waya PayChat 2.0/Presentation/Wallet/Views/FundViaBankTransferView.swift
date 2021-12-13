//
//  FundViaBankTransferView.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 24/06/2021.
//

import UIKit

final class FundViaBankTransferView: UIView, NavView {
    var onBack: (() -> Void)?
    var onCopy: ((String) -> Void)?
    var accountNumber: String!
    var bankName: String!
    
    lazy var backButton: UIButton = {
        let btn = UI.button(title: nil, icon: UIImage(named: "back-nav-arrow"), style: .icon, state: .active)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = .zero
        return btn
    }()
    
    lazy var headingLabel: UILabel = {
        let label = UI.text(string: "Bank Transfer")
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UI.text(string: "Account Information")
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    lazy var accountNumberLabel: UILabel = {
        return UI.text(string: "XXXXXXXXXXX/XXXXX")
    }()
    
    lazy var copyButton: UIButton = {
        let btn = UI.button(title: nil, icon: UIImage(named: "icon-copy"), style: .icon)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = .zero
        return btn
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UI.text(string: "Sending money to this account number \nwill credit your Waya wallet.")
        label.textAlignment = .center
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.getAccountNumber()
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func  initView(){
        self.backgroundColor = UIColor(hex: "#FFFFFF")
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .center
        
        let accountView = UIView()
        accountView.translatesAutoresizingMaskIntoConstraints = false
        accountView.backgroundColor = .white
        accountView.cornerRadius(4)
        let offset = CGSize(width: 1, height: 2)
        accountView.layer.shadowOffset = offset
        self.layer.shadowColor = UIColor(hex: "#000000").cgColor
        accountView.layer.shadowRadius = 4
        accountView.layer.shadowOpacity = 0.1
        accountView.clipsToBounds = false
        
        accountView.addSubviews([infoLabel, accountNumberLabel, copyButton])
        
        self.addSubviews([backButton, headingLabel, accountView, descriptionLabel])
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor),
            
            headingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 19),
            headingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            accountView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            accountView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            accountView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 23),
            accountView.heightAnchor.constraint(equalToConstant: 88),
            
            descriptionLabel.topAnchor.constraint(equalTo: accountView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -46),
            
            infoLabel.leadingAnchor.constraint(equalTo: accountView.leadingAnchor, constant: 12),
            infoLabel.topAnchor.constraint(equalTo: accountView.topAnchor, constant: 16),
            accountNumberLabel.leadingAnchor.constraint(equalTo: accountView.leadingAnchor, constant: 12),
            accountNumberLabel.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 12),
            copyButton.trailingAnchor.constraint(equalTo: accountView.trailingAnchor, constant: -17),
            copyButton.bottomAnchor.constraint(equalTo: accountNumberLabel.bottomAnchor),
            copyButton.heightAnchor.constraint(equalToConstant: 20),
            copyButton.widthAnchor.constraint(equalToConstant: 18)
        ])
        
        backButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backTapped)))
        copyButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyTapped)))
    }
    
    func setAccount() {
        let linkAttributes :  [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 24)!,
            NSAttributedString.Key.foregroundColor:   UIColor(hex: "#4F4F4F"),
        ]
        let txt = NSMutableString(format: "%@/%@", accountNumber, bankName)
        let attrText = NSMutableAttributedString(string: txt as String)
        attrText.addAttributes(linkAttributes, range: NSRange(location: 0, length: 11))
        accountNumberLabel.attributedText = attrText
    }
    
    @objc func backTapped() {
        self.onBack?()
    }
    
    @objc func copyTapped() {
        self.onCopy?(self.accountNumber)
    }
    
    private func getAccountNumber() {
        if let account = auth.data.accounts?.virtualAccount {
            self.accountNumber = account.accountNumber
            self.bankName = account.bankName
            self.setAccount()
        }
    }
}

