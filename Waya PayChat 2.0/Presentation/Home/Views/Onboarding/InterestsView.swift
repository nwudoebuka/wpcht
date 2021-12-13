//
//  InterestsView.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 26/08/2021.
//

import Foundation
import Signals

final class InterestsView: UIView, WayagramSetupView {

    var continueBtn = UI.button(title: "Continue")
    
    lazy var toolbar  : CustomToolbar = {
        continueBtn.titleLabel?.font = UIFont(name: "Lato-Regular", size: 12)?.withWeight(.medium)
        let toolbar = CustomToolbar(rightItems: [continueBtn], leftItems: nil)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    lazy var titleLabel: UILabel = {
        return UI.text(string: "Select interest", style: .bold)
    }()
    
    var categoryView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.register(InterestViewCell.self, forCellWithReuseIdentifier: InterestViewCell.identifier)
        return view
    }()
    
    lazy var surpriseButton: UIButton = {
        let btn = UI.button(title: "Surprise me")
        btn.setImage(UIImage(named: "icons/surprise_icon")!, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        btn.backgroundColor = .white
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10);
        btn.layer.cornerRadius = 5
        btn.layer.shadowColor = UIColor(hex: "#606170").cgColor
        btn.layer.shadowOpacity = 0.5
        btn.layer.shadowOffset = .zero
        btn.layer.shadowRadius = 5
        btn.layer.shouldRasterize = true
        btn.layer.rasterizationScale = UIScreen.main.scale
        btn.clipsToBounds = false
        return btn
    }()
    
    var interests: [UserInterest] = [UserInterest]()
    var selected: [UserInterest] = [UserInterest]()
    var onContinue: Signal<()> = Signal<()>()
    let onSelect = Signal<(UserInterest)>()
    var onBack: (() -> Void)?
    var onError: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubviews([toolbar, titleLabel, categoryView, surpriseButton])
        
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toolbar.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        titleLabel.anchor(top: toolbar.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0))
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        categoryView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: surpriseButton.topAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 27, left: 0, bottom: 14, right: 0))
        
        surpriseButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 00, bottom: 37, right: 0))
        surpriseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        surpriseButton.widthAnchor.constraint(equalToConstant: 187).isActive = true
        surpriseButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        categoryView.delegate = self
        categoryView.dataSource = self
        categoryView.allowsSelection = true
        categoryView.allowsMultipleSelection = true
        categoryView.reloadData()
        
        surpriseButton.onTouchUpInside.subscribe(with: self) {
            self.fillRandom()
        }.onQueue(.main)
        
        toolbar.backButton.onTouchUpInside.subscribe(with: self) {
            self.onBack?()
        }
        
        continueBtn.isUserInteractionEnabled = true
        continueBtn.onTouchUpInside.subscribe(with: self) {
            self.onContinue => ()
        }
    }
    
    @objc func dismissView() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        self.categoryView.reloadData()
    }
    
    private func fillRandom() {
        if selected.count != 0 {
            self.selected.forEach { (interest) in
                if let index = self.interests.firstIndex(where: { $0.id == interest.id }) {
                    let indexPath = IndexPath(row: index, section: 0)
                    categoryView.deselectItem(at: indexPath, animated: true)
                    categoryView.delegate?.collectionView?(categoryView, didDeselectItemAt: indexPath)
                }
            }
            self.selected.removeAll()
        }
        
        var total = 0
        for _ in 1...5 {
            if total == 5 {
                break
            }
            let item = interests.randomElement()
            let index = self.interests.firstIndex { (cur) -> Bool in
                return cur.id == item!.id
                }!
            let indexPath = IndexPath(row: index, section: 0)
            categoryView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
            categoryView.delegate?.collectionView?(categoryView, didSelectItemAt: indexPath)
            total += 1
        }
    }
}

extension InterestsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestViewCell.identifier, for: indexPath) as? InterestViewCell else {
            return UICollectionViewCell()
        }
        cell.isUserInteractionEnabled = true
        let blueView = UIView(frame: bounds)
        blueView.layer.cornerRadius = 14
        blueView.backgroundColor = UIColor(hex: "#FF6634").withAlphaComponent(0.7)
        cell.selectedBackgroundView = blueView
        cell.label.text = self.interests[indexPath.row].title?.capitalized
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let this = self.interests[indexPath.row]
        self.onSelect => this
        self.selected.append(this)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let this = self.interests[indexPath.row]
        guard let index = self.selected.firstIndex(where: { $0.id == this.id }) else {
            return
        }
        self.selected.remove(at: index)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 10, left: 24, bottom: 10, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  70
        let collectionViewSize = UIScreen.main.bounds.width - padding

        return CGSize(width: CGFloat(collectionViewSize * 0.5), height: CGFloat(collectionViewSize * 0.5))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14.0
    }
}

final class InterestViewCell: UICollectionViewCell {
    static let identifier = "InterestViewCell"
    
    lazy var label: UILabel = {
        let txt = UI.text(string: "", style: .bold)
        txt.textAlignment = .center
        txt.numberOfLines = 0
        return txt
    }()
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .white
        self.layer.cornerRadius = 14
        self.layer.shadowColor = UIColor(hex: "#606170").cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 6
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        self.clipsToBounds = false
        
        self.addSubview(label)
        label.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
