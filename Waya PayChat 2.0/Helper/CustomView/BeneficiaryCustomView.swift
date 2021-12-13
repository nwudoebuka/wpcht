//
//  BeneficiaryCustomView.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/7/21.
//

class BeneficiaryCustomView: UIView {
    
    var leftTitleLabel : UILabel!
    var leftValueLabel : UILabel!
    var rightTitleLabel : UILabel!
    var rightValueLabel : UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func  initView(){
        leftTitleLabel = latoTextRegular(text: "Beneficiary", textSize: 14, textColor: UIColor(named: "color-gray1")!)
        rightTitleLabel = latoTextRegular(text: "Amount", textSize: 14, textColor: UIColor(named: "color-gray1")!)
        leftValueLabel = latoTextRegular(text: "Beneficiary", textSize: 16, textColor: UIColor(named: "color-accent")!)
        leftValueLabel.numberOfLines = 0
        leftValueLabel.textAlignment = .left
        rightValueLabel = latoTextRegular(text: "Amount", textSize: 16, textColor: UIColor(named: "color-accent")!)
        
        addSubviews([leftTitleLabel, rightTitleLabel, leftValueLabel, rightValueLabel])
        
        leftTitleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, 
                              padding: UIEdgeInsets(top: 10, left: 22, bottom: 0, right: 0))
        rightTitleLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, 
                              padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 22))
        leftValueLabel.anchor(top: leftTitleLabel.bottomAnchor, leading: leftTitleLabel.leadingAnchor, bottom: nil, trailing: rightValueLabel.leadingAnchor,
                              padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 20))
        rightValueLabel.anchor(top: rightTitleLabel.bottomAnchor, leading: rightTitleLabel.leadingAnchor, bottom: nil, trailing: rightTitleLabel.trailingAnchor, padding: UIEdgeInsets(top: 8, left: -10, bottom: 0, right: 0))
        rightValueLabel.textAlignment = .right
    }
}
