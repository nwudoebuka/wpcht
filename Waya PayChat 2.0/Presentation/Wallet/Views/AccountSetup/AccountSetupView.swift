//
//  AccountSetupView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 17/06/2021.
//

import Foundation
import Signals

class AccountSetupView: UIView {
    
    lazy var setupLabel: UILabel = {
        let txt = UI.text(string: "Setup your account")
        txt.font = UIFont(name: "Lato-Regular", size: 18)
        txt.textColor = Colors.darkerBlue
        return txt
    }()
    
    lazy var items: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        let items = UICollectionView(frame: .zero, collectionViewLayout: layout)
        items.register(AccountSetupViewCell.self, forCellWithReuseIdentifier: AccountSetupViewCell.identifier)
        items.translatesAutoresizingMaskIntoConstraints = false
        items.isUserInteractionEnabled = true
        return items
    }()
    
    private var verifications: [RequiredSetup]!
    
    let onSelect = Signal<(RequiredSetup)>()
    let toggle = Signal<(Bool)>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        self.verifications = RequiredSetup.allCases.compactMap { (setup) -> RequiredSetup? in
            return (setup.verified == false) ? setup : nil
        }
        self.addSubviews([setupLabel, items])
        items.delegate = self
        items.dataSource = self
        items.backgroundColor = UIColor(hex: "#f9f9fa")
        
        NSLayoutConstraint.activate([
            setupLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            setupLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 18),
            
            items.topAnchor.constraint(equalTo: setupLabel.bottomAnchor, constant: 8),
            items.leftAnchor.constraint(equalTo: leftAnchor),
            items.rightAnchor.constraint(equalTo: rightAnchor),
            items.heightAnchor.constraint(equalToConstant: 68),
        ])
    }
    
    public func reload() {
        self.items.reloadData()
        if self.verifications.count > 0 {
            self.toggle => (true)
        } else {
            self.toggle => (false)
        }
    }
}

extension AccountSetupView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.verifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AccountSetupViewCell.identifier, for: indexPath) as? AccountSetupViewCell else {
            return UICollectionViewCell()
        }
        cell.setup = verifications[indexPath.row]
        cell.title.text = verifications[indexPath.row].title
        cell.icon.image = verifications[indexPath.row].icon
        cell.contentView.isUserInteractionEnabled = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onSelect => (verifications[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: 100, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return UIEdgeInsets(top: 8, left: 18, bottom: 8, right: 18)
    }
}

