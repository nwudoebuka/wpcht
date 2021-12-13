//
//  AccountSetupViewCell.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 17/06/2021.
//
import UIKit
import Signals

class AccountSetupViewCell: UICollectionViewCell {
    
    static let identifier = "AccountSetupCell"
    
    lazy var icon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    lazy var title: UILabel = {
        let txt = UI.text(string: "")
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    var setup: RequiredSetup!
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         initView()
    }
     
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func initView() {
        self.addSubviews([icon, title])
        self.layer.cornerRadius = 2
        self.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 11.5),
            icon.heightAnchor.constraint(equalToConstant: 12),
            icon.widthAnchor.constraint(equalToConstant: 16),
            
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7)
        ])
    }
}
