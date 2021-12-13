//
//  FundWalletBottomSheet.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/6/21.
//


class FundWalletBottomSheet: UIView {

    var topLine = UIView()
    var titleLabel : UILabel!
    var bankCardButton : UIButton!
    var bankAccountButton : UIButton!
    var bankTransferButton : UIButton!
    var ussdButton : UIButton!
    
    var bankCardLine : UIView!
    var idLine : UIView!
    var scanLine : UIView!
    var phoneLine : UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        titleLabel = libreTextBold(text: "Transfer Funds", textSize: 16)
        bankCardButton = buttonWithImageRight(image: UIImage(named: "ic-bank-card-fund")!, text: "Bank Card")
        bankAccountButton = buttonWithImageRight(image: UIImage(named: "ic-bank-account-fund")!, text: "Bank  Account")
        bankTransferButton = buttonWithImageRight(image: UIImage(named: "ic-bank-transfer-fund")!, text: "Bank Transfer")
        ussdButton = buttonWithImageRight(image: UIImage(named: "ic-ussd-fund")!, text: "USSD")
       
        bankCardLine = generateLine()
        idLine = generateLine()
        scanLine = generateLine()
        phoneLine = generateLine()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 0))
        
        addSubview(bankCardButton)
        bankCardButton.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                                padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 0))
        
        
        addSubview(bankCardLine)
        bankCardLine.anchor(top: bankCardButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                         padding: UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: 1))
        
        addSubview(bankAccountButton)
        bankAccountButton.anchor(top: bankCardLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                           padding: UIEdgeInsets(top: 17, left: 24, bottom: 0, right: 0))
        
        addSubview(idLine)
        idLine.anchor(top: bankAccountButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                      padding: UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: 1))
        
        
        addSubview(bankTransferButton)
        bankTransferButton.anchor(top: idLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                         padding: UIEdgeInsets(top: 17, left: 24, bottom: 0, right: 0))
        
        addSubview(scanLine)
        scanLine.anchor(top: bankTransferButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                        padding: UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: 1))
        
        addSubview(ussdButton)
        ussdButton.anchor(top: scanLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                          padding: UIEdgeInsets(top: 17, left: 24, bottom: 0, right: 0))
    }
    
    func generateLine(color : UIColor = UIColor(named: "sliver-gray") ?? .gray) -> UIView {
        let line = UIView()
        line.backgroundColor =  color.withAlphaComponent(0.3)
        return line
    }
}
