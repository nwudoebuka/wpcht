//
//  FundViaUssdView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 26/05/2021.
//

import UIKit

class FundViaUssdView: UIView, NavView {
    var onBack: (() -> Void)?
    var dial: (() -> Void)?
    lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
//        view.layer.shadowRadius = 12
        return view
    }()
    
    lazy var heading: UILabel = {
        let label = UI.text(string: "Transact with USSD", style: .bold)
        label.font = UIFont(name: "Lato-Bold", size: 16)
        return label
    }()
    
    lazy var content: UILabel = {
        let txt = UI.text(string: "Use *347*006*2*FundingAmount*6# to perform a Waya transaction or")
        txt.lineBreakMode = .byWordWrapping
        txt.numberOfLines = 0
        txt.textAlignment = .center
        txt.textColor = UIColor(hex: "#828282")
        return txt
    }()
    
    lazy var action: UIButton = {
        return UI.button(title: "Dial USSD Code", style: .secondary)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.getAccountNumber()
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.backgroundColor = UIColor(hex: "#0D0D0D").withAlphaComponent(0.4)
        self.addSubview(container)
        
        container.addSubviews([heading, content, action])
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 176),
            container.widthAnchor.constraint(equalToConstant: 287),
            container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            heading.topAnchor.constraint(equalTo: container.topAnchor, constant: 28),
            heading.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            heading.heightAnchor.constraint(equalToConstant: 20),
            
            content.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 22),
            content.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -22),
            content.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 16),
            
            action.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            action.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -34),
            action.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAround)))
        self.action.addTarget(self, action: #selector(didTapDial), for: .touchUpInside)
        
    }
    
    @objc func didTapAround() {
        self.onBack?()
    }
    
    @objc func didTapDial() {
        self.dial?()
    }
}
