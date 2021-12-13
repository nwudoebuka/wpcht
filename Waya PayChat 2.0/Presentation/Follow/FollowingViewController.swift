//
//  FollowingViewController.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 06/09/2021.
//

import UIKit

class FollowingViewController: UIViewController {
    var numberOfFollowers = 0
    var toolbar  : CustomToolbar = {
        let toolbar = CustomToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    private let followingTableView : UITableView = {
         let followingTableView = UITableView()
        followingTableView.register(FollowTableViewCell.self, forCellReuseIdentifier: FollowTableViewCell.identifier)
       
        followingTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        followingTableView.backgroundColor = .white
         return followingTableView
     }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    func setUpUI(){
        view.backgroundColor = .white
        view.addSubview(toolbar)
        toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toolbar.titleLabel.text = "Following(\(numberOfFollowers))"
        toolbar.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        followingTableView.delegate = self
        followingTableView.dataSource = self
        followingTableView.reloadData()
        
        view.addSubview(followingTableView)
        followingTableView.anchor(top: toolbar.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: UIEdgeInsets(top: 8, left: 20, bottom: 20, right:20))
    }
    
    @objc func didTapBackButton(){
        dismiss(animated: false, completion: nil)
    }

}

extension FollowingViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("number of following is \(numberOfFollowers)")
        return numberOfFollowers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("seen cell")
        let cellFollowing = followingTableView.dequeueReusableCell(withIdentifier: FollowTableViewCell.identifier) as! FollowTableViewCell
        cellFollowing.selectionStyle = .none
        cellFollowing.configure()
        return cellFollowing
    }
    
    
}
