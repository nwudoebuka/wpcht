//
//  WalletActionView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/11/21.
//

import UIKit

class WalletActionItemView: UIView {
    
    
    var actionButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor(named: "gainsboro-color")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = button.frame.size.width/2
        button.backgroundColor = .white
        return button
    }()
    
    var headerLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 52, width: 64, height: 20))
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = UIColor(named: "toolbar-color-primary")
        label.adjustsFontSizeToFitWidth = true
        label.text = "Available Balance"
        return label
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        addSubview(actionButton)
        addSubview(headerLabel)
    }

}
