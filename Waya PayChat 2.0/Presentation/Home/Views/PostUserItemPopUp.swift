//
//  PostItemPopUp.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/23/21.
//


class PostUserItemPopUp:  UIView {
        
        private var selecetedIndex = 0
        
        var bookmarkButton : UIButton = {
            let button = UIButton()
            button.backgroundColor = .white
            button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
            button.setTitle("Bookmark", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        var shareButton : UIButton = {
            let button = UIButton()
            button.backgroundColor = .white
            button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
            button.setTitle("Share", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.contentHorizontalAlignment = .left
            button.titleLabel?.textAlignment = .left
           // button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 0)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        var copyButton : UIButton = {
            let button = UIButton()
            button.backgroundColor = .white
            button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
            button.setTitle("Copy Link", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .left
            button.contentHorizontalAlignment = .left
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        var editButton : UIButton = {
            let button = UIButton()
            button.backgroundColor = .white
            button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
            button.setTitle("Edit Post", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.textAlignment = .left
            button.contentHorizontalAlignment = .left
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
    var deletePostButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitle("DeletePost", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            initView()
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func initView(){
            addSubview(bookmarkButton)
            bookmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
            bookmarkButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            bookmarkButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
            
            addSubview(shareButton)
            shareButton.topAnchor.constraint(equalTo: bookmarkButton.bottomAnchor, constant: 26).isActive = true
            shareButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            shareButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
            
            addSubview(copyButton)
            copyButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor, constant: 26).isActive = true
            copyButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            copyButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
            
            addSubview(editButton)
            editButton.topAnchor.constraint(equalTo: copyButton.bottomAnchor, constant: 26).isActive = true
            editButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            editButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
            
            addSubview(deletePostButton)
            deletePostButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 26).isActive = true
            deletePostButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            deletePostButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        }
    }

