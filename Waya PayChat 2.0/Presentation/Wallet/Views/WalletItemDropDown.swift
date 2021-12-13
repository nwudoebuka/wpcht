//
//  WalletItemDropDown.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/6/21.
//


class WalletItemDropDownView: UIView {
    
    private var selecetedIndex = 0
    
    var defaultWalletUILabel : UILabel!
    var accountStatementButton : UIButton!
    var allWalletsButton : UIButton!
    var defaultWaletUISwitch = UISwitch()
    var disableWalletUISwitch = UISwitch()
    var disableWalletUILabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        defaultWalletUILabel = latoTextRegular(text: "Default Wallet")
        disableWalletUILabel = latoTextRegular(text: "Disable Wallet")
        accountStatementButton = generateButton(title: "Account Statement")
        allWalletsButton = generateButton(title: "All wallets")
      
        addSubview(defaultWalletUILabel)
        defaultWalletUILabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, 
                                    padding: UIEdgeInsets(top: 10, left: 29, bottom: 0, right: 0))
        
        addSubview(defaultWaletUISwitch)
        defaultWaletUISwitch.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,
                                    padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 12))
        
        addSubview(disableWalletUILabel)
        disableWalletUILabel.anchor(top: defaultWaletUISwitch.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, 
                                    padding: UIEdgeInsets(top: 4, left: 29, bottom: 0, right: 0))
        
        addSubview(disableWalletUISwitch)
        disableWalletUISwitch.anchor(top: defaultWaletUISwitch.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor,
                                    padding: UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 12))
        
        addSubview(accountStatementButton)
        accountStatementButton.anchor(top: disableWalletUILabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, 
                                    padding: UIEdgeInsets(top: 4, left: 29, bottom: 0, right: 0))
        
        addSubview(allWalletsButton)
        allWalletsButton.anchor(top: accountStatementButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, 
                                    padding: UIEdgeInsets(top: 4, left: 29, bottom: 0, right: 0))
                
    }
    

    
}

