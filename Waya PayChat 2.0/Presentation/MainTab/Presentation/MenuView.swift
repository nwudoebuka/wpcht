//
//  MenuView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/8/21.
//

import UIKit

class MenuView: UIView {

    var profileImage : UIImageView = {
        let imageV = UIImageView()
        let targetSize = CGSize(width: 36, height: 36)
        imageV.image = UIImage(named: "profile-placeholder")?.resizeImage(targetSize: targetSize)
        imageV.frame = CGRect(x: 0, y: 0, width: 36 , height: 36)  
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.contentScaleFactor = .leastNonzeroMagnitude
        imageV.clipsToBounds = true
        imageV.contentMode = .scaleAspectFit
        imageV.circularImage()
        return imageV
    }()
    
    let fullName : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 16)
        label.textColor = UIColor(named: "dark-gray")
        label.text = "Your Fullname"
        return label
    }()
    
    let followersLabel : UILabel = {
        let label = UILabel()
        //let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 14))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 12)
        label.textColor = UIColor(named: "color-gray1")
        label.text = "0  Followers"
        return label
    }()
    
    let followingLabel : UILabel = {
        let label = UILabel()
        //let label = UILabel.init(frame: CGRect(x: 106, y: 0, width: 100, height: 14))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 12)
        label.textColor = UIColor(named: "color-gray1")
        label.text = "0  Followers"
        return label
    }()
    
    let accountLabel : UILabel = {
        let label = UILabel()
       // label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textColor = UIColor(named: "toolbar-color-primary")
        label.text = "Account Numbers"
        return label
    }()
    
    lazy var accountNumberLabel: UILabel = {
        let number = auth.data.accounts?.virtualAccount?.accountNumber ?? ""
        let bank = auth.data.accounts?.virtualAccount?.bankName ?? ""
        let string = String(format: "%@ | %@", number, bank)
        return UI.text(string: string, style: .bold)
    }()
    
    let earnButton : UIButton = {
        let button = UIButton()
        //button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        let attrText = NSMutableAttributedString(string: "Earn with Waya Paychat")
        button.setAttributedTitle(attrText, for: .normal)
        return button
    }()
    
    let inviteCodeButton : UIButton = {
        let button = UIButton()
        //button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        let attrText = NSMutableAttributedString(string: "Invite Code")
        button.setAttributedTitle(attrText, for: .normal)
        return button
    }()
    
    lazy var referelCodeText: UILabel = {
        return UI.text(string: auth.data.profile!.referalCode ?? "", style: .bold)
    }()
    
    let dividerTopLine : UIView = {
        let line = UIView()
        line.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.8)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let profileButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("  My Profile", for: .normal)
        button.setImage(UIImage(named: "menu-icon-account"), for: .normal)
        button.setLeftImageAlignment()
        return button
    }()
    
    let boomarkPostButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("  Bookmarked Posts", for: .normal)
        button.setImage(UIImage(named: "menu-icon-add-bookmark"), for: .normal)
        button.setLeftImageAlignment()
        return button
    }()
    
    let createGroupButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("  Create Group and Page", for: .normal)
        button.setImage(UIImage(named: "menu-icon-group"), for: .normal)
        button.setLeftImageAlignment()
        return button
    }()
    
    let qRButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("  QR Code", for: .normal)
        button.setImage(UIImage(named: "menu-icon-scan"), for: .normal)
        button.setLeftImageAlignment()
        return button
    }()
    
    let interestButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle(" Interests", for: .normal)
        button.setImage(UIImage(named: "menu-icon-interest"), for: .normal)
        button.setLeftImageAlignment()
        return button
    }()
    
    let settingButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("  Settings", for: .normal)
        button.setImage(UIImage(named: "menu-icon-settings"), for: .normal)
        button.setLeftImageAlignment()
        return button
    }()
    
    let dividerBottomLine : UIView = {
        let line = UIView()
        line.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.3)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    let faqButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("FAQ", for: .normal)
     
        return button
    }()
    let termsButton : UIButton = {
        let button = UIButton()
        //button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("Terms and conditions", for: .normal)
      
        return button
    }()
    
    let privacyPolicyButton : UIButton = {
        let button = UIButton()
        //button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("Privacy Policy", for: .normal)
        return button
    }()
    
    let logOutButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("LOG OUT", for: .normal)
        return button
    }()
    
    var followViewContainer = UIView()
    var profileInfoContainer = UIView()
    var profileHeaderViewContainer = UIView()
    var topHeaderView = UIStackView()
    var middleSectionStack = UIStackView()
    var bottomSectionStack = UIStackView()
    
    var profileInfoView : UIView = {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: 200, height: 100)) 
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        let fullNameText = String(format: "%@ %@", auth.data.profile!.firstName, auth.data.profile!.lastName!)
        fullName.text = fullNameText
        
        if let profile = auth.data.wayagramProfile {
            if let avatar = profile.avatar {
                ImageLoader.loadImageData(urlString: avatar) { (result) in
                    let image = result ?? UIImage(named: "profile-placeholder")
                    self.profileImage.image = image
                }
            }
            
            followersLabel.text = String("\(profile.followers) Followers")
            followingLabel.text = String("\(profile.following) Following")
        } else {
            
        }
        
        // stack for followers
        followViewContainer.addSubview(followersLabel)
        followViewContainer.addSubview(followingLabel)
        followersLabel.leadingAnchor.constraint(equalTo: followViewContainer.leadingAnchor).isActive = true
        followersLabel.centerYAnchor.constraint(equalTo: followViewContainer.centerYAnchor).isActive = true
        followingLabel.leadingAnchor.constraint(equalTo: followersLabel.trailingAnchor, constant: 10).isActive = true
        followingLabel.centerYAnchor.constraint(equalTo: followViewContainer.centerYAnchor).isActive = true
        
        profileInfoContainer.addSubview(fullName)
        profileInfoContainer.addSubview(followViewContainer)
        followViewContainer.translatesAutoresizingMaskIntoConstraints = false
        profileInfoContainer.translatesAutoresizingMaskIntoConstraints = false
        fullName.topAnchor.constraint(equalTo: profileInfoContainer.topAnchor).isActive = true
        fullName.leadingAnchor.constraint(equalTo: profileInfoContainer.leadingAnchor).isActive = true
        followViewContainer.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 10).isActive = true
        followViewContainer.leadingAnchor.constraint(equalTo: profileInfoContainer.leadingAnchor).isActive = true
        
        profileHeaderViewContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(profileHeaderViewContainer)
        profileHeaderViewContainer.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        profileHeaderViewContainer.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        
 
        profileHeaderViewContainer.addSubview(profileImage)
        profileHeaderViewContainer.addSubview(profileInfoContainer)
        profileImage.leadingAnchor.constraint(equalTo: profileHeaderViewContainer.leadingAnchor, constant: 18).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 36).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 36).isActive = true

        profileInfoContainer.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10).isActive = true
        profileInfoContainer.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        profileImage.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true

        
        topHeaderView.axis = .vertical
        topHeaderView.spacing = 8
        topHeaderView.alignment = .leading
        topHeaderView.addArrangedSubview(accountLabel)
        topHeaderView.addArrangedSubview(accountNumberLabel)
        topHeaderView.addArrangedSubview(earnButton)
        topHeaderView.addArrangedSubview(inviteCodeButton)
        topHeaderView.addArrangedSubview(referelCodeText)
        
        topHeaderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topHeaderView)
        topHeaderView.topAnchor.constraint(equalTo: profileHeaderViewContainer.bottomAnchor, constant: 64).isActive = true
        topHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 18).isActive = true
        topHeaderView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(dividerTopLine)
        dividerTopLine.topAnchor.constraint(equalTo: topHeaderView.bottomAnchor, constant: 10).isActive = true
        dividerTopLine.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        dividerTopLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        middleSectionStack.axis = .vertical
        middleSectionStack.spacing = 16
        middleSectionStack.alignment = .leading
        middleSectionStack.addArrangedSubview(profileButton)
        middleSectionStack.addArrangedSubview(boomarkPostButton)
        middleSectionStack.addArrangedSubview(createGroupButton)
        middleSectionStack.addArrangedSubview(qRButton)
        middleSectionStack.addArrangedSubview(interestButton)
        middleSectionStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(middleSectionStack)
        middleSectionStack.topAnchor.constraint(equalTo: dividerTopLine.bottomAnchor, constant: 20).isActive = true
        middleSectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28).isActive = true
      //  middleSectionStack.addArrangedSubview(settingButton)
    
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(settingButton)
        settingButton.topAnchor.constraint(equalTo: middleSectionStack.bottomAnchor, constant: 16).isActive = true
        settingButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28).isActive = true
       // settingButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
  
//        logOutButton.bottomAnchor.constraint(equalTo: settingButton.topAnchor).isActive = true
//        logOutButton.trailingAnchor.constraint(equalTo: logoutViewContainer.trailingAnchor, constant: -10).isActive = true
        
        addSubview(logOutButton)
        logOutButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        logOutButton.topAnchor.constraint(equalTo: middleSectionStack.bottomAnchor, constant: 16).isActive = true
        
        addSubview(dividerBottomLine)
        dividerBottomLine.topAnchor.constraint(equalTo: settingButton.bottomAnchor, constant: 40).isActive = true
        dividerBottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerBottomLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        
        bottomSectionStack.axis = .vertical
        bottomSectionStack.alignment = .leading
        addSubview(bottomSectionStack)
        bottomSectionStack.translatesAutoresizingMaskIntoConstraints = false
        bottomSectionStack.topAnchor.constraint(equalTo: dividerBottomLine.bottomAnchor, constant: 20).isActive = true
        bottomSectionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18).isActive = true
        
        bottomSectionStack.addArrangedSubview(faqButton)
        bottomSectionStack.addArrangedSubview(privacyPolicyButton)
        bottomSectionStack.addArrangedSubview(termsButton)
    }
    

}
