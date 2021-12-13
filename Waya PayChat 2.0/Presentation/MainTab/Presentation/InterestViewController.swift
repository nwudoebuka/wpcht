//
//  PagesViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/19/21.
//


class InterestViewController:  UIViewController {
    
    private let interestTableView : UITableView = {
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
        
    }
    
    private func setUpTableView(){
        interestTableView.dataSource = self
        interestTableView.delegate = self
        view.addSubview(interestTableView)
        interestTableView.backgroundColor = .white
        interestTableView.separatorStyle = .none
        interestTableView.separatorColor = .clear
        interestTableView.translatesAutoresizingMaskIntoConstraints = false
        interestTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive  = true
        interestTableView.backgroundColor = .clear
        interestTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        interestTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        interestTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        interestTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        interestTableView.sectionIndexColor = .white
    }


}


extension InterestViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  interestTableView.dequeueReusableCell(withIdentifier: CustomFollowTableViewCell.identifier) as! CustomFollowTableViewCell
        cell.configureCell()
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    
    
}

