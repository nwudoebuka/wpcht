//
//  WalletActionView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/11/21.
//


class WalletActionItemView: UIView {
    
    var buttonAction : ()
    
    var actionButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 6, y: 0, width: 48, height: 48))
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor(named: "gainsboro-color")?.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = button.frame.size.width/2
        button.backgroundColor = .white
        return button
    }()
    
    var headerLabel : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 52, width: 60, height: 18))
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = UIColor(named: "toolbar-color-primary")
        label.textAlignment = .center
        label.text = "Available Balance"
        
        return label
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        addSubview(actionButton)
        addSubview(headerLabel)
    
    }


}
