//
//  RecommendationsView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 27/08/2021.
//

import Foundation
import Signals

class RecommendationsView: UIView, WayagramSetupView {
    var onError: ((String) -> Void)?
    var onBack: (() -> Void)?
    let onFollow = Signal<(SuggestFriendProfiles, Bool)>()
    let onFinish = Signal<()>()
    
    var suggested: [SuggestFriendProfiles] = [SuggestFriendProfiles]()
    
    var titleLabel = UI.text(string: "Recommended for You", style: .bold)
    
    lazy var descriptionText: UILabel = {
        let label = UI.text(string: "Here are some people, pages and groups\nto follow based on your interest", color: .gray)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    
    lazy var recommended: UITableView = {
        let view = UITableView()
        view.register(RecommendedCell.self, forCellReuseIdentifier: RecommendedCell.identifier)
        return view
    }()
    
    lazy var finishBtn: UIButton = {
        return UI.button(title: "Finish")
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubviews([titleLabel, descriptionText, recommended, finishBtn])
        
        titleLabel.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 53, left: 0, bottom: 0, right: 0))
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        descriptionText.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: finishBtn.topAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 14, left: 46, bottom: 0, right: 46))
        
        recommended.anchor(top: descriptionText.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 56, left: 0, bottom: 56, right: 0))
//        recommended.heightAnchor.constraint(equalToConstant: 230).isActive = true
        
        finishBtn.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 25, bottom: 36, right: 25))
        finishBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        recommended.delegate = self
        recommended.dataSource = self
        
        finishBtn.onTouchUpInside.subscribe(with: self) {
            self.onFinish => ()
        }
    }
    
}

extension RecommendationsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggested.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedCell.identifier, for: indexPath) as? RecommendedCell else{
            return UITableViewCell()
        }
        let profile = suggested[indexPath.row]
        cell.name.text = profile.displayName
        cell.location.text = "@\(profile.username)"
        cell.followBtn.onTouchUpInside.subscribe(with: self) {
            cell.following = !cell.following
            cell.followBtn.backgroundColor = (cell.following == true) ? Colors.orange : .white
            cell.followBtn.setTitleColor((cell.following == true) ? .white : Colors.orange, for: .normal)
            self.onFollow => (profile, cell.following)
        }
        
        cell.profileImage.image = UIImage(named: "ic_profile")
        
        if let avatar = profile.avatar {
            ImageLoader.loadImageData(urlString: avatar) { (result) in
                if let image = result{
                    cell.profileImage.image = image
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
}

class RecommendedCell: UITableViewCell {
    
    static let identifier = "RecommendedCell"
    var following: Bool = false
    lazy var profileImage: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var name: UILabel = {
        let txt = UI.text(string: "", style: .bold, color: .none)
        txt.numberOfLines = 0
        return txt
    }()
    lazy var location: UILabel = {
        let view = UI.text(string: "", style: .normal, color: .gray)
        return view
    }()
    
    var followBtn: UIButton = {
        let btn = UI.button(title: "Follow", icon: nil, style: .secondary, state: .active)
        btn.layer.borderWidth = 1.3
        btn.layer.borderColor = Colors.orange.cgColor
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubviews([name, location, profileImage, followBtn])
        
        profileImage.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0))
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        name.anchor(top: profileImage.topAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: followBtn.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 21, bottom: 0, right: 10))
        
        location.anchor(top: name.bottomAnchor, leading: profileImage.trailingAnchor, bottom: nil, trailing: name.trailingAnchor, padding: UIEdgeInsets(top: 2, left: 21, bottom: 0, right: 0))
        
        followBtn.anchor(top: nil, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 22))
        followBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        followBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        followBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
