//
//  PostItemPopUp.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/6/21.
//

import UIKit

class PostItemPopUp: UIView {

    private var selecetedIndex = 0
    
    var bookmarkButton : UIButton!
    var reportButton : UIButton!
    var blockButton : UIButton!
    var followButton : UIButton!
    var muteButton: UIButton!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        bookmarkButton = generateButton(title: "Bookmark", textColor: .black)
        reportButton = generateButton(title: "Report Post", textColor: .black)
        blockButton = generateButton(title: "Block User", textColor: .black)
        followButton = generateButton(title: "Follow User", textColor: .black)
        muteButton = generateButton(title: "Mute User", textColor: .black)

        
        addSubview(bookmarkButton)
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        bookmarkButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        bookmarkButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        addSubview(reportButton)
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        reportButton.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor, constant: 26).isActive = true
        reportButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        reportButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        addSubview(blockButton)
        blockButton.translatesAutoresizingMaskIntoConstraints = false
        blockButton.topAnchor.constraint(equalTo: reportButton.bottomAnchor, constant: 26).isActive = true
        blockButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        blockButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        addSubview(followButton)
        followButton.translatesAutoresizingMaskIntoConstraints = false
        followButton.topAnchor.constraint(equalTo: blockButton.bottomAnchor, constant: 26).isActive = true
        followButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        followButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        addSubview(muteButton)
        muteButton.translatesAutoresizingMaskIntoConstraints = false
        muteButton.topAnchor.constraint(equalTo: followButton.bottomAnchor, constant: 26).isActive = true
        muteButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        muteButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
    }
    
    func generateItemButton(title: String)-> UIButton{
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

