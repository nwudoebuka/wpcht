//
//  FundViaBankView.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 24/06/2021.
//

import UIKit

final class FundViaBankView: UIView, NavView {
    var onBack: (() -> Void)?
    var onFundViaExisting: (() -> Void)?
    var onFundViaNew: (() -> Void)?
    
    lazy var backButton: UIButton = {
        let btn = UI.button(title: nil, icon: UIImage(named: "back-nav-arrow"), style: .icon, state: .active)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageEdgeInsets = .zero
        return btn
    }()
    
    lazy var headingLabel: UILabel = {
        let label = UI.text(string: "Fund Wallet via Bank Account")
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    lazy var existingButton: UIView = {
        return createExistingButton()
    }()
    
    lazy var newButton: UIView = {
        return createNewButton()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = UIColor(hex: "#FCFCFC")
        
        self.addSubviews([backButton, headingLabel, existingButton, newButton])
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor),
            
            headingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 19),
            headingLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            existingButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            existingButton.heightAnchor.constraint(equalToConstant: 65),
            existingButton.widthAnchor.constraint(equalToConstant: 163),
            existingButton.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 45),
            
            newButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            newButton.heightAnchor.constraint(equalToConstant: 65),
            newButton.widthAnchor.constraint(equalToConstant: 163),
            newButton.topAnchor.constraint(equalTo: existingButton.bottomAnchor, constant: 19)
        ])
        
        newButton.clipsToBounds = false
        existingButton.clipsToBounds = false
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        existingButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fundViaExisting)))
        newButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fundViaNew)))
        
    }
    
    
    @objc func backTapped() {
        self.onBack?()
    }
    
    @objc func fundViaNew() {
        self.onFundViaNew?()
    }
    
    @objc func fundViaExisting() {
        self.onFundViaExisting?()
    }
    
    private func createNewButton() -> UIView {
        let btn = UIView()
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = false
        btn.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowRadius = 2
        btn.layer.borderWidth = 0.2
        btn.cornerRadius(8)
        
        let icon = UIImageView(image: UIImage(named: "icons/control_point"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let text = UI.text(string: "Fund via New\nBank Acccount")
        text.numberOfLines = 0
        
        btn.addSubviews([icon, text])
        
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: btn.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: btn.leadingAnchor, constant: 8),
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 24),
            
            text.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 9),
            text.topAnchor.constraint(equalTo: btn.topAnchor, constant: 15),
            text.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -8)
        ])
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fundViaNewSelected)))
        return btn
    }
    
    private func createExistingButton() -> UIView {
        let btn = UIView()
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        btn.layer.shadowOffset = CGSize(width: 2, height: 2)
        btn.layer.shadowRadius = 2
        btn.layer.borderWidth = 0.2
        btn.cornerRadius(8)
        
        let icon = UIImageView(image: UIImage(named: "icons/repeat"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let text = UI.text(string: "Fund via\nExisting Acccount")
        text.numberOfLines = 0
        
        btn.addSubviews([icon, text])
        
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: btn.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: btn.leadingAnchor, constant: 8),
            icon.heightAnchor.constraint(equalToConstant: 24),
            icon.widthAnchor.constraint(equalToConstant: 24),
            
            text.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 9),
            text.topAnchor.constraint(equalTo: btn.topAnchor, constant: 15),
            text.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -8)
        ])
        
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fundViaExistingSelected)))
        
        return btn
    }
    
    @objc func fundViaNewSelected(){
        self.onFundViaNew?()
    }
    
    @objc func fundViaExistingSelected() {
        self.onFundViaExisting?()
    }
}
