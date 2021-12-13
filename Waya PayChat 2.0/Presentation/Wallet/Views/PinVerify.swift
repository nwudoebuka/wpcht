//
//  PinVerify.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 15/06/2021.
//

import UIKit
import Signals

class PinVerify: UIView {
    
    var pinEntered = Signal<(String)>()
    var numberOfFields: Int = 4
    var otpStackView : PinStackView!
    
    lazy var content: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.backgroundColor = .white
        return view
    }()
    
    lazy var message: UILabel = {
        let txt = UI.text(string: "Enter PIN to unlock")
        return txt
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.backgroundColor = Colors.black.withAlphaComponent(0.4)
        
        addSubview(content)
        otpStackView = PinStackView(frame: .zero, fields: self.numberOfFields)
        otpStackView.secured = true
        otpStackView.translatesAutoresizingMaskIntoConstraints = false
        otpStackView.clipsToBounds = true
        
        content.addSubviews([message, otpStackView])
        
        NSLayoutConstraint.activate([
            content.heightAnchor.constraint(equalToConstant: 187),
            content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            content.centerYAnchor.constraint(equalTo: centerYAnchor),
            content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            message.centerXAnchor.constraint(equalTo: content.centerXAnchor),
            message.topAnchor.constraint(equalTo: content.topAnchor, constant: 28),
            
            otpStackView.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -55),
            otpStackView.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 20),
            otpStackView.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -20),
            otpStackView.heightAnchor.constraint(equalToConstant: 40)
        ])
        otpStackView.delegate = self
    }
}


extension PinVerify: OTPDelegate {
    
    func didChangeValidity(isValid: Bool) {
        guard isValid == true else {
            return
        }
        let pin = otpStackView.getOTP()
        if pin.length == numberOfFields {
            self.pinEntered => pin
        }
    }
}
