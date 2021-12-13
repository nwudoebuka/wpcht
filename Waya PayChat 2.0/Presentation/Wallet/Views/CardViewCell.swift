//
//  CardViewCell.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/11/21.
//

protocol CardViewCellDelegate  {
    func clickToExpand(userWalletResponse : UserWalletResponse)
    func topUpWallet(userWalletResponse : UserWalletResponse)
}

class CardViewCell: UICollectionViewCell {

    static let identifier = "CardViewCell"
    var isDefault = true
    var cardDelegate : CardViewCellDelegate!
    var userWalletResponse : UserWalletResponse!
    
    let headerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 12)
        label.textColor = .white
        label.text = "Available Balance"
        return label
    }()
    
    var backgroundImage : UIImageView = {
        let imageV = UIImageView()
        let targetSize = CGSize(width: 105, height: 126)
        imageV.image = UIImage(named: "wallet-card-default")
        imageV.frame = CGRect(x: 0, y: 0, width: 306 , height: 132)  
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentScaleFactor = .leastNonzeroMagnitude
        imageV.clipsToBounds = true
        imageV.contentMode = .scaleAspectFit
        imageV.layer.cornerRadius = 8
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var balanceLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 24)
        label.textColor = .white
        label.text = "N130,000"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let topUpButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 12)
        button.setTitle("Top-up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let clickToExpandButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("CLICK TO EXPAND", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 12)
        button.layer.backgroundColor = UIColor.white.withAlphaComponent(0.3).cgColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 9
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
   
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func  initView(){
        addSubview(backgroundImage)
        backgroundImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        
        addSubview(balanceLabel)
        balanceLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 3).isActive = true
        balanceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22).isActive = true
        
        
        addSubview(topUpButton)
        topUpButton.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
        topUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        topUpButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        topUpButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
    
        addSubview(clickToExpandButton)
        clickToExpandButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        clickToExpandButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        clickToExpandButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        clickToExpandButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        clickToExpandButton.addTarget(self, action: #selector(didTapClickToExpand), for: .touchUpInside)
        topUpButton.addTarget(self, action: #selector(didTapTopUp), for: .touchUpInside)
    }
    
    func configureCard(_ userWalletResponse : UserWalletResponse){
        print("configuring wallet: \(userWalletResponse)")
        self.userWalletResponse = userWalletResponse
//
//        let regularAttr :  [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 12) ?? UIFont()
//
//        ]
//        let specialAttribute :  [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 24) ?? UIFont(),
//                                                                NSAttributedString.Key.foregroundColor:   UIColor.white
//        ]
//        String(userWalletResponse.balance)
//        let attrText = NSMutableAttributedString(string:  "N0")
//        attrText.addAttributes(regularAttr, range: NSRange(location: 0, length: 1))
//        attrText.addAttributes(specialAttribute, range: NSRange(location: 1, length: attrText.length - 1))
        balanceLabel.text = userWalletResponse.balance.formattedAmount?.currencySymbol
        if userWalletResponse.datumDefault == true {
            backgroundImage.image = UIImage(named: "wallet-card-virtual")
//            auth.data.accounts?.wallets?.filter({ $0.datumDefault == true}). = userWalletResponse.accountNo
            auth.updateLocalPrefs()
        } else {
            //distniguish the generated virtual wallet to other wallets 
            backgroundImage.image =  UIImage(named: "wallet-card-normal")
        }
    }
    
    @objc func didTapClickToExpand(){
        cardDelegate.clickToExpand(userWalletResponse: userWalletResponse)
    }
    
    @objc func didTapTopUp(){
        cardDelegate.topUpWallet(userWalletResponse: userWalletResponse)
    }
}

