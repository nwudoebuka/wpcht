//
//  CardWithTwoHorizontalText.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/29/21.
//

import UIKit

class CardWithTwoHorizontalText: UIView {
    
    var headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Regular", size: 14)
        label.textColor = UIColor(named: "color-gray1")
        label.text = "Header"
        return label
    }()

    
    var subHeaderLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 14)
        label.textColor = UIColor(named: "toolbar-color-secondary")
        label.text = "SubHeader"
        return label
    }()
    
    let stackView : UIStackView = {
        let stackView  = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func  initView(){
        stackView.addArrangedSubview(headerLabel)
        stackView.addArrangedSubview(subHeaderLabel)
        
        addSubview(stackView)
        stackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 9, left: 13, bottom: 13, right: 9))
    }
    
    
    
}


