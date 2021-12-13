//
//  UserPagesViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/19/21.
//


class UserPagesViewController:  UIViewController {
    
    private let userPagesTableView : UITableView = {
        let table = UITableView()
        table.register(CustomFollowTableViewCell.self, forCellReuseIdentifier: CustomFollowTableViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.backgroundColor = .white
        table.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right:  0)
        table.rowHeight = 70
        return table
    }()
    
    var wayagramViewModel  = WayagramViewModelImpl()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        fetchAllpages()
    }

    private func setUpTableView(){
        userPagesTableView.dataSource = self
        userPagesTableView.delegate = self
        view.addSubview(userPagesTableView)
        userPagesTableView.backgroundColor = .white
        userPagesTableView.separatorStyle = .none
        userPagesTableView.separatorColor = .clear
        userPagesTableView.translatesAutoresizingMaskIntoConstraints = false
        userPagesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive  = true
        userPagesTableView.backgroundColor = .clear
        userPagesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        userPagesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        userPagesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        userPagesTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        userPagesTableView.sectionIndexColor = .white
    }
    
    private func fetchAllpages(){
        wayagramViewModel.getAllUserPage {[weak self] (result) in
            switch result{
                case .success(let response):
                    print("The result of all pages \(String(describing: response))")
                    self?.userPagesTableView.reloadData()
                case .failure(.custom(let message)):
                    print("The result of all pages \(message)")

            }
        }
    }

}


extension UserPagesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wayagramViewModel.userPages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  userPagesTableView.dequeueReusableCell(withIdentifier: CustomFollowTableViewCell.identifier) as! CustomFollowTableViewCell
        //cell.configureCell()
        configurePageTable(tableViewCell: cell, index: indexPath.row)
        cell.selectionStyle = .none
        cell.forwardButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return cell
    }
    
    @objc func didTapButton(){
        print("Tap")
        view.backgroundColor = .red
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    
    func configurePageTable(tableViewCell : CustomFollowTableViewCell, index: Int){
        tableViewCell.titleLabel.text = wayagramViewModel.userPages[index].title
        tableViewCell.valueLabel.text = wayagramViewModel.userPages[index].description
        tableViewCell.forwardButton.setTitle("Follow", for: .normal)
    }
    
}
