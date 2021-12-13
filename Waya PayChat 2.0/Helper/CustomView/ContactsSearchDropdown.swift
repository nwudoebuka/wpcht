//
//  ContactsSearchDropdown.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 31/05/2021.
//

import Foundation
import UIKit
import Contacts

class ContactSearchDropdownCell: UITableViewCell {
    lazy var name: UILabel = {
        return UI.text(string: "Name")
    }()
    
    lazy var picture: UIImageView = {
        let view = UIImageView(image: nil)
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var contact: Contact! {
        didSet {
            self.name.text = self.contact.name ?? ""
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "contact")
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        self.picture.image = UIImage(named: "profile-placeholder")!
        
        self.addSubviews([picture, name])
        NSLayoutConstraint.activate([
            picture.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            picture.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 17),
            picture.heightAnchor.constraint(equalToConstant: 40),
            picture.widthAnchor.constraint(equalToConstant: 40),
            
            name.leadingAnchor.constraint(equalTo: picture.trailingAnchor, constant: 13),
            name.centerYAnchor.constraint(equalTo: picture.centerYAnchor),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17)
        ])
    }
}
