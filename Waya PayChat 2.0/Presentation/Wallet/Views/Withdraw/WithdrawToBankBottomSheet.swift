//
//  WithdrawToBankBottomSheet.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 19/08/2021.
//

import Foundation
import Signals

enum WithdrawMode: Int {
    case new
    case saved
    case beneficiary
}

fileprivate class WithdrawButton: UIView {
    
    lazy var icon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "wallet-icon")?.withRenderingMode(.alwaysTemplate))
        view.tintColor = UIColor(hex: "#064A72")
        return view
    }()
    
    lazy var title: UILabel = {
        var title = UI.text(string: "", style: .bold)
        title.font = UIFont(name: "Lato-Regular", size: 16)
        return title
    }()
    var mode: WithdrawMode!
    let onClick = Signal<(WithdrawMode)>()
    
    convenience init(title: String, mode: WithdrawMode) {
        self.init()
        self.title.text = title
        self.mode = mode
        initView()
    }
    
    private func initView() {
        self.addSubviews([icon, title])
        icon.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0))
        icon.heightAnchor.constraint(equalToConstant: 18).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        title.anchor(top: nil, leading: icon.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 21, bottom: 0, right:51 ))
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clicked)))
    }
    
    @objc func clicked() {
        self.onClick => (self.mode)
    }
}

class WithdrawToBankBottomSheet: UIView {
    
    
    var topLine = UIView()
    var titleLabel : UILabel!
    
    fileprivate lazy var savedBank: WithdrawButton = {
        return WithdrawButton(title: "Withdraw to Saved Bank Account", mode: .saved)
    }()
    
    fileprivate lazy var newBank: WithdrawButton = {
        return WithdrawButton(title: "Withdraw to New Bank Account", mode: .new)
    }()
    
    fileprivate lazy var beneficiary: WithdrawButton = {
        return WithdrawButton(title: "Withdraw to Beneficiaries", mode: .beneficiary)
    }()
    
    let onClick = Signal<(WithdrawMode)>()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
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
        
        titleLabel = libreTextBold(text: "Withdraw Funds", textSize: 16)
        
        addSubviews([titleLabel, savedBank, newBank, beneficiary])
        titleLabel.anchor(top: topLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 0))
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        savedBank.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 21, left: 21, bottom: 0, right: 0))
        savedBank.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        newBank.anchor(top: savedBank.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 21, left: 21, bottom: 0, right: 0))
        newBank.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        beneficiary.anchor(top: newBank.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 21, left: 21, bottom: 0, right: 0))
        beneficiary.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.addActions()
    }
    
    private func addActions() {
        savedBank.onClick.subscribe(with: self) { (mode) in
            self.onClick => (mode)
        }
        
        newBank.onClick.subscribe(with: self) { (mode) in
            self.onClick => (mode)
        }
        
        beneficiary.onClick.subscribe(with: self) { (mode) in
            self.onClick => (mode)
        }
    }
    
}
