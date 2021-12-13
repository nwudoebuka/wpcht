//
//  CreatePopUpView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/14/21.
//

import UIKit

class CreatePopUpView: UIView {

    var headerLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Create"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textColor = UIColor(named: "dark-gray")
        headerLabel_.textAlignment = .center
        headerLabel_.numberOfLines = 0
        headerLabel_.font = UIFont(name: "Lato-Regular", size: 24)
        return headerLabel_
    }()
    
    var postIconImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "create-post-icon")
        imageV.image = uiImage
        imageV.backgroundColor = UIColor(named: "alice-blue")
        imageV.contentMode = .center
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var postLabel : UILabel = {
        let label = UILabel()
        label.text = "Post"
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "dark-gray")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    var postMessageLabel : UILabel = {
        let label = UILabel()
        label.text = "Share a post or write what is on your mind"
       // label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "color-gray1")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 13)
        return label
    }()
    
    
    var postView = UIView()
    
    var postStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var momentIconImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "create-moment-icon")
        imageV.image = uiImage
        imageV.backgroundColor = UIColor(named: "alice-blue")
        imageV.contentMode = .center
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var momentLabel : UILabel = {
        let label = UILabel()
        label.text = "Moment"
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "dark-gray")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    var momentMessageLabel : UILabel = {
        let label = UILabel()
        label.text = "Share a photo or write something"
        // label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "color-gray1")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 13)
        return label
    }()
    
    
    var momentView = UIView()
    
    var momentStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var pageIconImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "create-page-icon")
        imageV.image = uiImage
        imageV.backgroundColor = UIColor(named: "alice-blue")
        imageV.contentMode = .center
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var pageLabel : UILabel = {
        let label = UILabel()
        label.text = "Page"
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "dark-gray")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    var pageMessageLabel : UILabel = {
        let label = UILabel()
        label.text = "Create a page for your business or fans"
        label.textColor = UIColor(named: "color-gray1")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 13)
        return label
    }()
    
    
    var pageView = UIView()
    
    var pageStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var groupIconImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "create-group-icon")
        imageV.image = uiImage
        imageV.backgroundColor = UIColor(named: "alice-blue")
        imageV.contentMode = .center
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var groupLabel : UILabel = {
        let label = UILabel()
        label.text = "Group"
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "dark-gray")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    var groupMessageLabel : UILabel = {
        let label = UILabel()
        label.text = "Create a private or public group of interests"
        label.textColor = UIColor(named: "color-gray1")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 13)
        return label
    }()
    
    
    var groupView = UIView()
    
    var groupStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var eventIconImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "create-event-icon")
        imageV.image = uiImage
        imageV.backgroundColor = UIColor(named: "alice-blue")
        imageV.contentMode = .center
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var eventLabel : UILabel = {
        let label = UILabel()
        label.text = "Event"
        label.textColor = UIColor(named: "dark-gray")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    var eventMessageLabel : UILabel = {
        let label = UILabel()
        label.text = "Bring people together with public or \n private events"
        label.textColor = UIColor(named: "color-gray1")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 13)
        return label
    }()
    
    
    var eventView = UIView()
    
    var eventStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var donationIconImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "create-auction-icon")
        imageV.image = uiImage
        imageV.backgroundColor = UIColor(named: "alice-blue")
        imageV.contentMode = .center
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var donationLabel : UILabel = {
        let label = UILabel()
        label.text = "Donation"
        label.textColor = UIColor(named: "dark-gray")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    var donationMessageLabel : UILabel = {
        let label = UILabel()
        label.text = "donation items privately or publicly"
        label.textColor = UIColor(named: "color-gray1")
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Regular", size: 13)
        return label
    }()
    
    
    var donationView = UIView()
    
    var donationStack : UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var line = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
                
        postStack.addArrangedSubview(postLabel)
        postStack.addArrangedSubview(postMessageLabel)
        
        postView.addSubview(postIconImage)
        postIconImage.leadingAnchor.constraint(equalTo: postView.leadingAnchor).isActive = true
        postIconImage.centerYAnchor.constraint(equalTo: postView.centerYAnchor).isActive = true
        postIconImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        postIconImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        postIconImage.frame.size = CGSize(width: 44, height: 44)
        postIconImage.circularImage()

        postView.addSubview(postStack)

        postStack.leadingAnchor.constraint(equalTo: postIconImage.trailingAnchor, constant: 15).isActive = true
        postStack.centerYAnchor.constraint(equalTo: postView.centerYAnchor).isActive = true
        postStack.trailingAnchor.constraint(equalTo: postView.trailingAnchor).isActive = true
        
        postView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(postView)
        postView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30).isActive = true
        postView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        postView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 22).isActive = true
        postView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        momentView.addSubview(momentIconImage)
        
        momentStack.addArrangedSubview(momentLabel)
        momentStack.addArrangedSubview(momentMessageLabel)
        
        momentView.addSubview(momentIconImage)
        momentIconImage.leadingAnchor.constraint(equalTo: momentView.leadingAnchor).isActive = true
        momentIconImage.centerYAnchor.constraint(equalTo: momentView.centerYAnchor).isActive = true
        momentIconImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        momentIconImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        momentIconImage.frame.size = CGSize(width: 44, height: 44)
        momentIconImage.circularImage()
        
        momentView.addSubview(momentStack)
        
        momentStack.leadingAnchor.constraint(equalTo: momentIconImage.trailingAnchor, constant: 15).isActive = true
        momentStack.centerYAnchor.constraint(equalTo: momentView.centerYAnchor).isActive = true
        momentStack.trailingAnchor.constraint(equalTo: momentView.trailingAnchor).isActive = true
        
        momentView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(momentView)
        momentView.topAnchor.constraint(equalTo: postView.bottomAnchor, constant: 8).isActive = true
        momentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        momentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 22).isActive = true
        momentView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        pageStack.addArrangedSubview(pageLabel)
        pageStack.addArrangedSubview(pageMessageLabel)
        
        pageView.addSubview(pageIconImage)
        pageIconImage.leadingAnchor.constraint(equalTo: pageView.leadingAnchor).isActive = true
        pageIconImage.centerYAnchor.constraint(equalTo: pageView.centerYAnchor).isActive = true
        pageIconImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        pageIconImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        pageIconImage.frame.size = CGSize(width: 44, height: 44)
        pageIconImage.circularImage()
        
        pageView.addSubview(pageStack)
        
        pageStack.leadingAnchor.constraint(equalTo: pageIconImage.trailingAnchor, constant: 15).isActive = true
        pageStack.centerYAnchor.constraint(equalTo: pageView.centerYAnchor).isActive = true
        pageStack.trailingAnchor.constraint(equalTo: pageView.trailingAnchor).isActive = true
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(pageView)
        pageView.topAnchor.constraint(equalTo: momentView.bottomAnchor, constant: 8).isActive = true
        pageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        pageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 22).isActive = true
        pageView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(named: "light-gray")
        addSubview(line)
        line.topAnchor.constraint(equalTo: pageView.bottomAnchor, constant: 16).isActive = true
        line.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        groupStack.addArrangedSubview(groupLabel)
        groupStack.addArrangedSubview(groupMessageLabel)
        
        groupView.addSubview(groupIconImage)
        groupIconImage.leadingAnchor.constraint(equalTo: groupView.leadingAnchor).isActive = true
        groupIconImage.centerYAnchor.constraint(equalTo: groupView.centerYAnchor).isActive = true
        groupIconImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        groupIconImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        groupIconImage.frame.size = CGSize(width: 44, height: 44)
        groupIconImage.circularImage()
        
        groupView.addSubview(groupStack)
        
        groupStack.leadingAnchor.constraint(equalTo: groupIconImage.trailingAnchor, constant: 15).isActive = true
        groupStack.centerYAnchor.constraint(equalTo: groupView.centerYAnchor).isActive = true
        groupStack.trailingAnchor.constraint(equalTo: groupView.trailingAnchor).isActive = true
        
        groupView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(groupView)
        groupView.topAnchor.constraint(equalTo: line.bottomAnchor, constant: 24).isActive = true
        groupView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        groupView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 22).isActive = true
        groupView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        eventStack.addArrangedSubview(eventLabel)
        eventStack.addArrangedSubview(eventMessageLabel)
        
        eventView.addSubview(eventIconImage)
        eventIconImage.leadingAnchor.constraint(equalTo: eventView.leadingAnchor).isActive = true
        eventIconImage.centerYAnchor.constraint(equalTo: eventView.centerYAnchor).isActive = true
        eventIconImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        eventIconImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        eventIconImage.frame.size = CGSize(width: 44, height: 44)
        eventIconImage.circularImage()
        
        eventView.addSubview(eventStack)
        
        eventStack.leadingAnchor.constraint(equalTo: eventIconImage.trailingAnchor, constant: 15).isActive = true
        eventStack.centerYAnchor.constraint(equalTo: eventView.centerYAnchor).isActive = true
        eventStack.trailingAnchor.constraint(equalTo: eventView.trailingAnchor).isActive = true
        
        eventView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(eventView)
        eventView.topAnchor.constraint(equalTo: groupView.bottomAnchor, constant: 16).isActive = true
        eventView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        eventView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 22).isActive = true
        eventView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        donationStack.addArrangedSubview(donationLabel)
        donationStack.addArrangedSubview(donationMessageLabel)
        
        donationView.addSubview(donationIconImage)
        donationIconImage.leadingAnchor.constraint(equalTo: donationView.leadingAnchor).isActive = true
        donationIconImage.centerYAnchor.constraint(equalTo: donationView.centerYAnchor).isActive = true
        donationIconImage.heightAnchor.constraint(equalToConstant: 44).isActive = true
        donationIconImage.widthAnchor.constraint(equalToConstant: 44).isActive = true
        donationIconImage.frame.size = CGSize(width: 44, height: 44)
        donationIconImage.circularImage()
        
        donationView.addSubview(donationStack)
        
        donationStack.leadingAnchor.constraint(equalTo: donationIconImage.trailingAnchor, constant: 15).isActive = true
        donationStack.centerYAnchor.constraint(equalTo: donationView.centerYAnchor).isActive = true
        donationStack.trailingAnchor.constraint(equalTo: donationView.trailingAnchor).isActive = true
        
        donationView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(donationView)
        donationView.topAnchor.constraint(equalTo: eventView.bottomAnchor, constant: 16).isActive = true
        donationView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        donationView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 22).isActive = true
        donationView.heightAnchor.constraint(equalToConstant: 44).isActive = true

        postView.isUserInteractionEnabled = true
        postView.tag = 1
        momentView.isUserInteractionEnabled = true
        momentView.tag = 2
    }

}
