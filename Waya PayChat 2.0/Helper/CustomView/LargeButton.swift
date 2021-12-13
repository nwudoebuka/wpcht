//
//  LargeButton.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 15/07/2021.
//

import UIKit
import Signals

final class LargeButton: UIView {
    
    let onTap = Signal<()>()
    lazy var title: UILabel = {
        return UI.text(string: nil, style: .bold)
    }()
    
    lazy var subtitle: UILabel = {
        return UI.text(string: nil)
    }()
    
    convenience init(title: String, subtitle: String?) {
        self.init(frame: .zero)
        self.title.text = title
        self.subtitle.text = subtitle
        self.configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
    
        layer.shadowRadius = 2
        layer.cornerRadius = 4
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        
        let icon = UIImageView(image: UIImage(named: "forward-icon-sm"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(icon)
        
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            icon.heightAnchor.constraint(equalToConstant: 13),
            icon.widthAnchor.constraint(equalToConstant: 9)
        ])
        
        if subtitle.text != nil  {
            self.addSubviews([title, subtitle])
            NSLayoutConstraint.activate([
                title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                title.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                subtitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
                subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3)
            ])
        } else {
            self.addSubview(title)
            NSLayoutConstraint.activate([
                title.centerYAnchor.constraint(equalTo: centerYAnchor),
                title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
            ])
        }
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    @objc func tapped() {
        self.onTap => ()
    }
}
