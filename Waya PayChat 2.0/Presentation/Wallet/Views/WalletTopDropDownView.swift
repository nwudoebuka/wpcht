//
//  WalletTopDropDownView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/11/21.
//


class WalletTopDropDownView: UIView {

    private var selecetedIndex = 0
    
    var paymentSettingButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 10, width: 210, height: 21))
        button.backgroundColor = UIColor(named: "item-select-color")
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitle("Payment Settings", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.textAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0)
        return button
    }()
    
    var manageWalletButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 36, width: 210, height: 21))
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitle("Manage wallet", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.textAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0)
        return button
    }()
    
    var manageCardButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 62, width: 210, height: 21))
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitle("Manage card", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0)
        return button
    }()
    
    var manageBankButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 86, width: 210, height: 21))
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitle("Manage bank account", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        addSubview(paymentSettingButton)
        addSubview(manageWalletButton)
        addSubview(manageCardButton)
        addSubview(manageBankButton)
    
    }
    
    func setSelectedIndex(_ index : Int){
        selecetedIndex = index
        paymentSettingButton.backgroundColor = selecetedIndex == 0 ? UIColor(named: "item-select-color") : .white
        paymentSettingButton.setTitleColor(selecetedIndex == 0 ? .white : .black, for: .normal) 
        
        manageWalletButton.backgroundColor = selecetedIndex == 1 ? UIColor(named: "item-select-color") : .white
        manageWalletButton.setTitleColor(selecetedIndex == 1 ? .white : .black, for: .normal) 
        
        manageCardButton.backgroundColor = selecetedIndex == 2 ? UIColor(named: "item-select-color") : .white
        manageCardButton.setTitleColor(selecetedIndex == 2 ? .white : .black, for: .normal) 
        
        manageBankButton.backgroundColor = selecetedIndex == 3 ? UIColor(named: "item-select-color") : .white
        manageBankButton.setTitleColor(selecetedIndex == 3 ? .white : .black, for: .normal) 
    }


}
