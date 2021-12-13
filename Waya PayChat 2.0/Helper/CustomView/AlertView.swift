//
//  WalletCreateSuccessViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/12/21.
//

import UIKit

protocol Alert {
    var onContinue: ((Bool?) -> Void)? { get set }
    var onHome: (() -> Void)? {get set}
    var onForgot: (() -> Void)? {get set}
}

class AlertView: UIView, Alert {
    var onContinue: ((Bool?) -> Void)?
    var onHome: (() -> Void)?
    var onForgot: (() -> Void)?
    var title: String?
    
    var mode: AlertMode!
    private var save_enabled: Bool = true
    
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "lock2")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var headerText : UILabel = {
        let label = UI.text(string: "", style: .bold)
        label.textAlignment = .center
        label.textColor = UIColor(hex: "1C1C1C")
        label.font = UIFont(name: "LibreBaskerville-Regular", size: 18)?.bold
        return label
    }()
    
    var bodyLabel : UILabel = {
        let label = UI.text(string: "")
        label.textColor = UIColor(named: "color-gray1")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    lazy var bodyHeader: UILabel = {
        let label = UI.text(string: "")
        label.textAlignment = .center
        label.textColor = UIColor(hex: "1C1C1C")
        label.font = UIFont(name: "Lato-Regular", size: 18)?.bold
        return label
    }()
    
    var bodyDetail: UILabel = {
        let btn = UI.text(string: "", style: .bold)
        btn.font = UIFont(name: "Lato-Regular-Bold", size: 18)
        btn.textAlignment = .center
        btn.numberOfLines = 0
        return btn
    }()
        
    let continueButton : UIButton = {
        let button = UI.button(title: "Continue")
        return button
    }()
    
    var forgotPinButton: UIButton = {
        let btn = UI.button(title: "Forgot PIN?", style: .secondary)
        btn.isHidden = true
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    var returnHomeButton: UIButton = {
        let btn = UI.button(title: "Return To Home", style: .secondary)
        btn.isHidden = true
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    lazy var saveLabel: UILabel = {
        return UI.text(string: "Save as a beneficiary")
    }()
    
    lazy var saveSwitch: UISwitch = {
        return UISwitch()
    }()
    var homButtonTopAnchor: NSLayoutConstraint!
    
    convenience init(frame: CGRect, title: String? = nil, mode: AlertMode) {
        self.init(frame: frame)
        self.mode = mode
        headerText.text = title
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView(){
        self.backgroundColor = .white
        addSubviews([
            headerImage, headerText, bodyLabel, bodyHeader,
            bodyDetail, continueButton, forgotPinButton,
            returnHomeButton
        ])
        headerImage.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 82, left: 0, bottom: 0, right: 0))
        headerText.anchor(top: headerImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 47, left: 22, bottom: 0, right: 22))
        
        bodyLabel.anchor(top: headerText.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 12, left: 30, bottom: 0, right: 30))
        
        bodyHeader.anchor(top: bodyLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 24, left: 22, bottom: 0, right: 22))
        
        bodyDetail.anchor(top: bodyHeader.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 30, bottom: 0, right: 30))
        
        NSLayoutConstraint.activate([
            headerImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 160),
            headerImage.widthAnchor.constraint(equalToConstant: 160),
            forgotPinButton.heightAnchor.constraint(equalToConstant: 30),
            returnHomeButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        self.redraw()
        addActions()
    }
    
    func redraw() {
        switch self.mode {
        case .success(let type):
            self.headerImage.image = UIImage(named: "success-icon")
            self.headerText.text = self.title ?? "Successful"
            switch type {
            case .withdrawal:
                self.bodyHeader.isHidden = false
                self.bodyDetail.isHidden = false
                self.addSaveBeneficiarySwitch()
            case .none, .generic:
                continueButton.anchor(top: bodyLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 48, left: 31, bottom: 0, right: 31))
            }
        case .failure(let failure):
            
            self.headerImage.image = UIImage(named: "failure-icon")
            self.headerText.text = failure?.rawValue
            self.bodyLabel.text = failure?.message
            self.bodyHeader.isHidden = true
            self.bodyDetail.isHidden = true
            self.continueButton.setTitle("Try Again", for: .normal)
            switch failure {
            case .incorrect_pin:
                forgotPinButton.isHidden = false
                forgotPinButton.anchor(top: continueButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 31, left: 50, bottom: 0, right: 50))
                returnHomeButton.anchor(top: forgotPinButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 23, left: 50, bottom: 0, right: 50))
            default:
                returnHomeButton.anchor(top: continueButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 23, left: 50, bottom: 0, right: 50))
            }
            self.returnHomeButton.isHidden = false
        case .security:
            self.headerImage.image = UIImage(named: "lock")
            self.continueButton.setTitle("Login", for: .normal)
            break
        case .none:
            break
        }
        continueButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        self.setNeedsDisplay()
        self.layoutIfNeeded()
    }
    
    func addActions() {
        returnHomeButton.addTarget(self, action: #selector(returnHome), for: .touchUpInside)
        continueButton.onTouchUpInside.subscribe(with: self) {
            self.onContinue?(self.save_enabled)
        }
    }
    
    @objc func returnHome() {
        self.onHome?()
    }
    
    private func addSaveBeneficiarySwitch() {
        saveSwitch.setOn(true, animated: true)
        saveSwitch.onValueChanged.subscribe(with: self) {
            self.save_enabled = self.saveSwitch.isOn
        }
        
        let container = UIView()
        container.addSubviews([saveLabel, saveSwitch])
        
        addSubview(container)
        container.anchor(top: bodyDetail.bottomAnchor, leading: leadingAnchor, bottom: continueButton.topAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30))
        saveLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        saveSwitch.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
        saveSwitch.heightAnchor.constraint(equalToConstant: 16).isActive = true
        saveSwitch.widthAnchor.constraint(equalToConstant: 33).isActive = true
        continueButton.anchor(top: container.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 48, left: 30, bottom: 0, right: 30))
    }

    
}
