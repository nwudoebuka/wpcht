//
//  HomeFollowingViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/19/21.

protocol HomeFollowingView : BaseView {
    var navBack : (() -> Void)? { get set }
    
}

class HomeFollowingViewController: UIViewController , HomeFollowingView, AccountFollowPagerDelegate {
    
    var navBack: (() -> Void)?

    var wayagramViewModel  = WayagramViewModelImpl()
    
    let controlTab : CustomTabControl = {
        let tab = CustomTabControl()
        tab.itemsText = ["People", "Interests", "Pages", "Groups"]
        return tab
    }()
    
    var searchBar : UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.frame.size.width = UIScreen.main.bounds.width - 16
        searchBar.tintColor = UIColor.white.withAlphaComponent(0.1)
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.layer.backgroundColor = UIColor.white.cgColor

        return searchBar
    }()
    
    lazy var titleTextField : TextInput = {
        let textField = UI.textField()
        return textField
    }()
    
    var pageViewController: AccountFollowingPageController!

    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = AccountFollowingPageController(wayagramViewModel: wayagramViewModel)
        initView()
        hideKeyboardWhenTappedAround()
        
    }
    
    
    
    @objc func handleSegmentControl(_ sender: AnyObject?){
    
        switch controlTab.selectedIndex {
            case 0:
                pageViewController.setCurrentController(index: 0)   
            case 1:
                pageViewController.setCurrentController(index: 1)   
            case 2:
                pageViewController.setCurrentController(index: 2)   
            case 3:
                pageViewController.setCurrentController(index: 3)   
            default:
                break
        }
        
    }
    
    private func initView(){
        title = "Following"
        navigationController?.navigationBar.tintColor = UIColor(named: "toolbar-color-secondary")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
              
        controlTab.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controlTab)
        controlTab.heightAnchor.constraint(equalToConstant: 50).isActive = true
        controlTab.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        controlTab.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        controlTab.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        controlTab.selectedIndex = 0
        controlTab.addTarget(self, action: #selector(handleSegmentControl), for: .valueChanged)
        
        
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        searchBar.frame.size.width = view.frame.size.width - 16
        searchBar.heightAnchor.constraint(equalToConstant: 30).isActive = true
        searchBar.topAnchor.constraint(equalTo: controlTab.bottomAnchor, constant: 8).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true        
        
        
        pageViewController.pagerDelegate = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        
        pageViewController.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 4).isActive = true
        pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        searchBar.tintColor = .white
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewControllerForSegmentedIndex(index:Int) -> UIViewController {
        var viewController:UIViewController?
        switch index {
            case 0:
                viewController = self.storyboard?.instantiateViewController(withIdentifier: "StoryboardIdForFirstController")
                break
            case 1:
                viewController = self.storyboard?.instantiateViewController(withIdentifier: "StoryboardIdForSecondController")
                break
            case 2:
                viewController = self.storyboard?.instantiateViewController(withIdentifier: "StoryboardIdForThirdController")
                break
            default:
                break
        }
        return viewController!
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        if currentIndex > -1 && currentIndex < 4{
            controlTab.selectedIndex = currentIndex   
        }
    }
    
    func searchUserByUsername(key : String){
        wayagramViewModel.getWayagramProfileByUsername(username: key) { [weak self](result) in
            switch result{
                case .success( let response):
                    if let response_ = response as? WayagramProfileResponse{
                        self?.wayagramViewModel.wayagramSearchedUserProfile.value = response_
                    }
                case .failure(.custom( let message)):    
                   print("The failed response \(message)")
                    
            }
        }
    }
    
    //search user by query using user wayagram profileId 
    func searchUserByQuery(key : String){
        let profileId = UserDefaults.standard.string(forKey: "ProfileId") ?? ""
        wayagramViewModel.getWayagramProfileByQuery(query: key, profileId: profileId) { [weak self](result) in
            switch result{
                case .success( let response):
                    if let response_ = response as? [WayagramProfileResponse]{
                        print("done loading the response")
                        self?.wayagramViewModel.wayagramSearchedUserProfiles.value = response_
                    }
                case .failure(.custom( let message)):    
                    print("The failed response \(message)")
                    
            }
        }
    }
}

extension HomeFollowingViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did begin..")
      
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("Search bar editing did end..")
        view.endEditing(true)
        resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //search(shouldShow: false)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search text is \(searchText)")
        if searchBar.text != nil{
            searchUserByQuery(key : searchBar.text!)
            //searchUserByUsername(key: searchBar.text!)
        }
    }
}

