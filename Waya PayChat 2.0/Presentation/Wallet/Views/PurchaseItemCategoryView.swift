//
//  PurchaseItemView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/11/21.
//

import UIKit

class PurchaseItemCategoryView: UIView {

    var purchaseImageView : UIImageView = {
        let imageV = UIImageView()     
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentScaleFactor = .leastNonzeroMagnitude
        imageV.clipsToBounds = true
        imageV.contentMode = .scaleAspectFit
        return imageV
    }()
    
    var headerLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Lato-Regular", size: 15)
        label.textColor = UIColor(named: "toolbar-color-secondary")
        label.text = "Utility Bills"
        label.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(purchaseImageView)
        addSubview(headerLabel)
        
        purchaseImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        purchaseImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: purchaseImageView.trailingAnchor, constant: 16).isActive = true
        
    }
    
}
