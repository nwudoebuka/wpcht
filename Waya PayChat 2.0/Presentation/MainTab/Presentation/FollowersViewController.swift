//
//  FollowersViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/19/21.
//


class FollowersViewController: UIViewController {

    var profileViewModel = ProfileViewModelImpl()
    
    var button = UIButton(frame: CGRect(x: 100, y: 10, width: 100, height: 50))
    
    let controlTab : CustomTabControl = {
        let tab = CustomTabControl()
        tab.itemsText = ["Follower", "Following"]
        return tab
    }()
    
    private let followersTableView : UITableView = {
        let table = UITableView()
        table.register(CustomFollowTableViewCell.self, forCellReuseIdentifier: CustomFollowTableViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.backgroundColor = .white
        table.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right:  0)
        table.rowHeight = 70
        return table
    }()
    
    var wayagramViewModel : WayagramViewModelImpl!
    var viewType = FollowerViewType.search
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
        if viewType == FollowerViewType.search{
            addDataSourceObserver()
        } else{
            getFollowers()
            getFollowing() 
        }
       
    }
    

    private func setUpTableView(){
        followersTableView.dataSource = self
        followersTableView.delegate = self
        view.addSubview(followersTableView)
        followersTableView.backgroundColor = .white
        followersTableView.separatorStyle = .none
        followersTableView.separatorColor = .clear
        followersTableView.translatesAutoresizingMaskIntoConstraints = false
        
        if viewType == FollowerViewType.search{
            followersTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive  = true
        } else{
            view.addSubview(controlTab)
            controlTab.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
            followersTableView.topAnchor.constraint(equalTo: controlTab.bottomAnchor).isActive  = true
            controlTab.addTarget(self, action: #selector(handleSegmentControl), for: .touchUpInside)
        }
        followersTableView.backgroundColor = .clear
        followersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        followersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        followersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        followersTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        followersTableView.sectionIndexColor = .white
        followersTableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        followersTableView.isUserInteractionEnabled = true
        
     
    }
    
    private func addDataSourceObserver(){
//        wayagramViewModel.wayagramSearchedUserProfile.observe(on: self) {[weak self] (profileResponse) in
//            if profileResponse != nil{
//                self?.followersTableView.reloadData()
//            }
//        }
        
        wayagramViewModel.wayagramSearchedUserProfiles.observe(on: self) {[weak self] (profileResponse) in
            self?.followersTableView.reloadData()
        }
    }
    
    func getFollowers(){
        profileViewModel.getFollowers(pageNumber: 1) { (result) in
            switch result{
                case .success(let response):
                    print("The result of followers \(String(describing: response))")
                case .failure(.custom(let message)):
                    print("The result of followers error \(message)")
            }
        }
    }
    
    func getFollowing(){
        profileViewModel.getFollowing(pageNumber: 1) { (result) in
            switch result{
                case .success(let response):
                    print("The result of followers \(String(describing: response))")
                case .failure(.custom(let message)):
                    print("The result of followers error \(message)")
            }
        }
    }
    
    func getFriends(){
        profileViewModel.getFriends(pageNumber: 1) { (result) in
            switch result{
                case .success(let response):
                    print("The result of followers \(String(describing: response))")
                case .failure(.custom(let message)):
                    print("The result of followers error \(message)")
            }
        }
    }
    
    @objc func handleSegmentControl(_ sender: AnyObject?){
        
        switch controlTab.selectedIndex {
            case 0:
                viewType = FollowerViewType.follower
                followersTableView.reloadData()
            case 1:
                viewType = FollowerViewType.following
                followersTableView.reloadData()
            default:
                break
        }
    }
}





extension FollowersViewController : UITableViewDelegate, UITableViewDataSource, CustomFollowTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewType {
            case .search:
                return wayagramViewModel.wayagramSearchedUserProfiles.value!.count
            case .follower:
                return profileViewModel.followers.count
            case .following:
                return profileViewModel.following.count
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  followersTableView.dequeueReusableCell(withIdentifier: CustomFollowTableViewCell.identifier) as! CustomFollowTableViewCell
        switch viewType {
            case .search:
                cell.configureCellForPeople(wayagramProfile: wayagramViewModel.wayagramSearchedUserProfiles.value![indexPath.row])  
                cell.wayagramProfile =   wayagramViewModel.wayagramSearchedUserProfiles.value![indexPath.row]
                cell.cellDelegate = self
            case .follower:
                cell.configureCellFollowing(folloItem: profileViewModel.followers[indexPath.row])
            case .following:
                cell.configureCellFollowing(folloItem: profileViewModel.following[indexPath.row])
        }
        cell.indexPath = indexPath    
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    
    func onFollowClick(indexPath : IndexPath, followUserRequest: FollowUserRequest) {
        LoadingView.show()
        profileViewModel.followUsers(followRequest: followUserRequest) {[weak self] (result) in
            switch result{
                case .success( _):
                    print("Successful following")
//                    (self?.followersTableView.cellForRow(at: indexPath) as? CustomFollowTableViewCell)?.forwardButton
                    (self?.followersTableView.cellForRow(at: indexPath) as? CustomFollowTableViewCell)?.forwardButton.setTitle("Following", for: .normal)
                    (self?.followersTableView.cellForRow(at: indexPath) as? CustomFollowTableViewCell)?.forwardButton.titleLabel?.textColor = .white
                    LoadingView.hide()
                case .failure(.custom(let message)):
                    print("The custom message \(message)")
                    LoadingView.hide()

            }
        }
    }
}


