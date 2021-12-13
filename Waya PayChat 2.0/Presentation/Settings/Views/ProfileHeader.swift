//
//  ProfileHeader.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 16/07/2021.
//

import Foundation

struct ProfileHeader {
    
    static func new() -> UIView {
        
        let _view = UIView()
        _view.translatesAutoresizingMaskIntoConstraints = false
        _view.clipsToBounds = true
        
        let profileImage = UIImageView(image: UIImage(named: "ic_profile"))
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        let tierView = UIView()
        let tierText = "T1: Upgrade your account to do larger transactions"
        var tierLabel = UI.text(string: "")
//        tierLabel.textAl
        
        
        
        
        _view.addSubviews([profileImage])
        
        NSLayoutConstraint.activate([
            profileImage.centerXAnchor.constraint(equalTo: _view.centerXAnchor),
            profileImage.topAnchor.constraint(equalTo: _view.topAnchor, constant: 19),
            profileImage.heightAnchor.constraint(equalToConstant: 80),
            profileImage.widthAnchor.constraint(equalToConstant: 80),
        ])
        return _view
    }
}
