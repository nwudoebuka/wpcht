//
//  ReceivePaymentBottomSheet.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/10/21.
//


class ReceivePaymentBottomSheet: UIView {

        
        var topLine = UIView()
        var titleLabel : UILabel!
        var receivePaymentButton : UIButton!
        var scanToReceivePaymentButton : UIButton!
        
        var bankCardLine : UIView!
        var idLine : UIView!
        
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
            
            titleLabel = libreTextBold(text: "Receive Payment", textSize: 16)
            receivePaymentButton = buttonWithImageRight(image: UIImage(named: "ic-bank-card-fund")!, text: "Request Payment")
            scanToReceivePaymentButton = buttonWithImageRight(image: UIImage(named: "ic-bank-account-fund")!, text: "Scan to Receive")
            
            bankCardLine = generateLine()
            idLine = generateLine()
        
            
            addSubview(titleLabel)
            titleLabel.anchor(top: topLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                              padding: UIEdgeInsets(top: 19, left: 0, bottom: 0, right: 0))
            
            addSubview(receivePaymentButton)
            receivePaymentButton.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                                  padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 0))
            
            
            addSubview(bankCardLine)
            bankCardLine.anchor(top: receivePaymentButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                                padding: UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: 1))
            
            addSubview(scanToReceivePaymentButton)
            scanToReceivePaymentButton.anchor(top: bankCardLine.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,
                                     padding: UIEdgeInsets(top: 17, left: 24, bottom: 0, right: 0))
            
            addSubview(idLine)
            idLine.anchor(top: scanToReceivePaymentButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor,
                          padding: UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0), size: CGSize(width: frame.width, height: 1))
            
            
            
            
        }
        
        func generateLine(color : UIColor = UIColor(named: "sliver-gray") ?? .gray) -> UIView {
            let line = UIView()
            line.backgroundColor =  color.withAlphaComponent(0.3)
            return line
        }
    }
