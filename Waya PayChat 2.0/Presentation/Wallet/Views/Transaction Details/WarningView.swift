//
//  WarningView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 15/08/2021.
//

import Foundation

enum WarningMode {
    case info
    case error
    case warning
    
    var color: UIColor {
        switch self {
        case .error, .info:
            return UIColor(hex: "#EB5757")
        case .warning:
            return UIColor(hex: "#D19F04")
        }
    }
    
    var alignment: NSTextAlignment {
        switch self {
        case .info:
            return .left
        case .error, .warning:
            return .center
        }
    }
}

class WarningView: UIView {
    
    var icon: UIImageView =  {
        return UIImageView(image: UIImage(named: "icons/warning_icon")?.withRenderingMode(.alwaysTemplate))
    }()
    
    var errorText: UILabel = {
        let txt = UI.text(string: "", style: .normal, color: .primary)
        txt.numberOfLines = 0
        return txt
    }()
    
    var closeIcon: UIButton = {
        return UI.button(title: nil, icon: UIImage(named: "close-icon")?.withRenderingMode(.alwaysTemplate), style: .icon, state: .active)
    }()
    
    var onClose: (() -> Void)?
    var text: String  = "" {
        didSet { errorText.text = self.text}
    }
    var mode: WarningMode! {
        didSet { self.redraw() }
    }
    
    convenience init(mode: WarningMode? = .error, label: String? = "") {
        self.init()
        self.mode = mode
        self.text = label!
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder){
        fatalError("init\(coder) has not been implemented")
    }
    
    func initView() {
        closeIcon.imageView?.tintColor = UIColor(hex: "#064A72")
        closeIcon.tintColor = UIColor(hex: "#064A72")
        addSubviews([icon, closeIcon, errorText, closeIcon])
        
        icon.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        errorText.anchor(top: nil, leading: icon.trailingAnchor, bottom: nil, trailing: closeIcon.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 20))
        errorText.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        closeIcon.anchor(top: nil, leading: nil, bottom: nil, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        closeIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        closeIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true
        closeIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        closeIcon.onTouchUpInside.subscribe(with: self) { () in
            self.onClose?()
        }
    }
    
    private func redraw() {
        self.backgroundColor = mode.color.withAlphaComponent(0.3)
        icon.tintColor = mode.color
        errorText.textColor = mode.color
        errorText.textAlignment = mode.alignment
        self.layoutIfNeeded()
    }
    
}
