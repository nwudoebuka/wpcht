//
//  CustomProfileLabel.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/19/21.
//

import UIKit

class CustomProfileLabel: UIView {

    var valueLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Bold", size: 14)
        label.textColor = .black
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Light", size: 14)
        label.textColor = UIColor(named: "color-gray1")
        label.text = "Follower"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
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
        
        addSubview(valueLabel)
        valueLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        valueLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        valueLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: valueLabel.trailingAnchor, constant: 4).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true

    }
    
        

}
