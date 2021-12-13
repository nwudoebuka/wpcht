//
//  GroupViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/19/21.
//


class GroupViewController:  UIViewController {
    
    private let groupTableView : UITableView = {
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
        groupTableView.dataSource = self
        groupTableView.delegate = self
        view.addSubview(groupTableView)
        groupTableView.backgroundColor = .white
        groupTableView.separatorStyle = .none
        groupTableView.separatorColor = .clear
        groupTableView.translatesAutoresizingMaskIntoConstraints = false
        groupTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive  = true
        groupTableView.backgroundColor = .clear
        groupTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        groupTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        groupTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        groupTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        groupTableView.sectionIndexColor = .white
    }
    
    private func fetchAllpages(){
        wayagramViewModel.getAllGroup(pageNumber: "1") {[weak self] (result) in
            switch result{
                case .success(let response):
                    print("The result of all pages \(String(describing: response))")
                    self?.groupTableView.reloadData()
                case .failure(.custom(let message)):
                    print("The result of all pages \(message)")
                    
            }
        }
    }

}



extension GroupViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wayagramViewModel.groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  groupTableView.dequeueReusableCell(withIdentifier: CustomFollowTableViewCell.identifier) as! CustomFollowTableViewCell
        configurePageTable(tableViewCell: cell, index: indexPath.row)        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    
    func configurePageTable(tableViewCell : CustomFollowTableViewCell, index: Int){
        tableViewCell.titleLabel.text = wayagramViewModel.groups[index].name
        tableViewCell.valueLabel.text = wayagramViewModel.groups[index].description
        tableViewCell.forwardButton.setTitle("Follow", for: .normal)
    }
    
}
