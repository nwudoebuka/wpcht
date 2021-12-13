//
//  PollView.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/25/21.
//

import UIKit

class PricePostView: UIView {

    var postPollImageView : PostImageView = {
        let imageV = PostImageView(newImages: [])
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 4
        return imageV
    }()
    
    var cancelImageView : UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "cancel-icon")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var addImageButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(named: "add-paid-post-icon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let removeButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitle("Remove Product", for: .normal)
        button.setTitleColor(UIColor(named: "flamigo-color"), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let bodyTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textColor = UIColor(named: "color-black")
        label.text = "Attach Price to Product"
        return label
    }()
    
    var priceTextField : UITextField = {
        let headerLabel_ = UITextField()
        headerLabel_.placeholder = "N 0.00"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textColor = UIColor(named: "toolbar-color-secondary")
        headerLabel_.font = UIFont(name: "Lato-Regular", size: 16)
        return headerLabel_
    }()
    
    
    let midLine : UIView = {
        let line = UIView()
        line.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.3)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let bottomLine : UIView = {
        let line = UIView()
        line.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.3)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func  initView(){
        
        addSubview(removeButton)
        removeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -14).isActive = true
        removeButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        removeButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        addSubview(bottomLine)
        bottomLine.bottomAnchor.constraint(equalTo: removeButton.topAnchor, constant: -12).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(priceTextField)
        priceTextField.topAnchor.constraint(equalTo: bottomLine.topAnchor, constant: -19).isActive = true
        priceTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        addSubview(bodyTitleLabel)
        bodyTitleLabel.topAnchor.constraint(equalTo: priceTextField.topAnchor, constant: -9).isActive = true
        bodyTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        addSubview(midLine)
        midLine.topAnchor.constraint(equalTo: bodyTitleLabel.topAnchor, constant: -13).isActive = true
        midLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        
        addSubview(postPollImageView)
        postPollImageView.topAnchor.constraint(equalTo: topAnchor, constant: 11).isActive = true
        postPollImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        postPollImageView.heightAnchor.constraint(equalToConstant: 126).isActive  = true
        postPollImageView.widthAnchor.constraint(equalToConstant: 190).isActive = true
        
        addSubview(addImageButton)
        addImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        addImageButton.centerXAnchor.constraint(equalTo: postPollImageView.centerXAnchor).isActive = true
        
    }
}
