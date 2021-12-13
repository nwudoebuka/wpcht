//
//  ProfileViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/18/21.
//

/**
 User Profile where it shows the user timeline, Follow (who they follow and who followed them),
 Groups and pages they are involve in 
 */

class ProfileViewController: UIViewController, ProfilePagerDelegate, Alertable,ProfileView {
    var navToFollowing: (() -> Void)?
     var backGroundImageView = UIImageView(image: UIImage(named: "moment-placeholder"))
    var profileImageView = UIImageView(image: UIImage(named: "profile-placeholder"))
    
    static var collapsingViewHeightContraint : NSLayoutConstraint!
    static var headerViewMaxHeight: CGFloat = 340
    static let headerViewMinHeight: CGFloat = 0
    
    var wayagramViewModel : WayagramViewModelImpl!
    var profilePageViewController: ProfilePageViewController!
    
    let userDefault = UserDefaults.standard
    
    //previous offset flow for collapsing Toolbar it will be access in other view controller 
    static  var previousOffsetState : CGFloat = 0

    let pagerTitleView : CustomTabControl = {
        let tab = CustomTabControl()
        tab.itemsText = ["Timeline", "likes", "Groups", "Pages"]
        return tab
    }()
    
    var toolbar  : CustomToolbar = {
        let toolbar = CustomToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    var editProfileButton : UIButton = {
        let button  = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.transparentButton()
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Bold", size: 11)
        return button
    }()
    
    
    var usernameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textColor = UIColor(named: "color-accent")
        label.text = "@username"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var fullNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 16)
        label.textColor = UIColor(named: "dark-gray")
        label.text = "Your name"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var descriptionNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 12)
        label.textColor = UIColor(named: "toolbar-color-secondary")
        label.text = "Bio: "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    var followerLabel : CustomProfileLabel = {
        let label = CustomProfileLabel()
        label.valueLabel.text = "0"
        label.titleLabel.text = "followers"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var followingLabel : CustomProfileLabel = {
        let label = CustomProfileLabel()
        label.valueLabel.text = "0"
        label.titleLabel.text = "following"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var postsLabel : CustomProfileLabel = {
        let label = CustomProfileLabel()
        label.valueLabel.text = "0"
        label.titleLabel.text = "post"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var collapsingHeaderView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
       return view 
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePageViewController  = ProfilePageViewController(wayagramViewModel: wayagramViewModel)
        setUpView()
        
    }
    
    
    func setUpView() {
        
        view.addSubview(toolbar)
        toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let fullName = String(format: "%@ %@", auth.data.profile!.firstName, auth.data.profile!.lastName!)
        toolbar.titleLabel.text = fullName
        fullNameLabel.text = fullName
        if let username = auth.data.wayagramProfile?.username {
            usernameLabel.text = "@\(username)"
        }
        toolbar.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        collapsingHeaderView.addSubview(backGroundImageView)
        backGroundImageView.leadingAnchor.constraint(equalTo: collapsingHeaderView.leadingAnchor).isActive = true
        backGroundImageView.trailingAnchor.constraint(equalTo: collapsingHeaderView.trailingAnchor).isActive = true
        backGroundImageView.topAnchor.constraint(equalTo: collapsingHeaderView.topAnchor).isActive = true
        backGroundImageView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.frame.size = CGSize(width: 80, height: 80)
        collapsingHeaderView.addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: collapsingHeaderView.leadingAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: backGroundImageView.topAnchor, constant: 90).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.circularImage()
        
        collapsingHeaderView.addSubview(editProfileButton)
        editProfileButton.topAnchor.constraint(equalTo: backGroundImageView.bottomAnchor,
                                               constant: 15).isActive = true
        editProfileButton.trailingAnchor.constraint(equalTo: collapsingHeaderView.trailingAnchor, 
                                                    constant: -16).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        editProfileButton.titleLabel?.font = UIFont(name: "Lato-Light", size: 11)
        
        collapsingHeaderView.addSubview(fullNameLabel)
        fullNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                               constant: 16).isActive = true
        fullNameLabel.leadingAnchor.constraint(equalTo: collapsingHeaderView.leadingAnchor, 
                                                    constant: 16).isActive = true
        
        collapsingHeaderView.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor,
                                           constant: 4).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: collapsingHeaderView.leadingAnchor, 
                                               constant: 16).isActive = true
        
        collapsingHeaderView.addSubview(descriptionNameLabel)
        descriptionNameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor,
                                           constant: 14).isActive = true
        descriptionNameLabel.leadingAnchor.constraint(equalTo: collapsingHeaderView.leadingAnchor, 
                                               constant: 16).isActive = true
        
        descriptionNameLabel.trailingAnchor.constraint(equalTo: collapsingHeaderView.trailingAnchor, 
                                                      constant: -28).isActive = true
        descriptionNameLabel.heightAnchor.constraint(equalToConstant: 42).isActive = true
        
        collapsingHeaderView.addSubview(followerLabel)
        let tapFollowing = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.tapFollowing))
        followerLabel.isUserInteractionEnabled = true
        followerLabel.addGestureRecognizer(tapFollowing)
        followerLabel.topAnchor.constraint(equalTo: descriptionNameLabel.bottomAnchor,
                                                  constant: 16).isActive = true
        followerLabel.leadingAnchor.constraint(equalTo: collapsingHeaderView.leadingAnchor, 
                                                      constant: 16).isActive = true
        followerLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true 
        
        collapsingHeaderView.addSubview(followingLabel)
        followingLabel.topAnchor.constraint(equalTo: descriptionNameLabel.bottomAnchor,
                                           constant: 16).isActive = true
        followingLabel.leadingAnchor.constraint(equalTo: followerLabel.trailingAnchor, 
                                               constant: 16).isActive = true
        followingLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true 

        
        collapsingHeaderView.addSubview(postsLabel)
        postsLabel.topAnchor.constraint(equalTo: descriptionNameLabel.bottomAnchor,
                                            constant: 16).isActive = true
        postsLabel.leadingAnchor.constraint(equalTo: followingLabel.trailingAnchor, 
                                                constant: 16).isActive = true 
        postsLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true 
        

        view.addSubview(collapsingHeaderView)
        collapsingHeaderView.topAnchor.constraint(equalTo: toolbar.bottomAnchor).isActive = true
        collapsingHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collapsingHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        ProfileViewController.collapsingViewHeightContraint = collapsingHeaderView.heightAnchor.constraint(equalToConstant: ProfileViewController.headerViewMaxHeight)
        ProfileViewController.collapsingViewHeightContraint.isActive = true
        

        pagerTitleView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pagerTitleView)
        pagerTitleView.topAnchor.constraint(equalTo: collapsingHeaderView.bottomAnchor).isActive = true
        pagerTitleView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pagerTitleView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pagerTitleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        pagerTitleView.selectedIndex = 0
        
        profilePageViewController.pagerDelegate = self
        profilePageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profilePageViewController.view)
        
        profilePageViewController.view.topAnchor.constraint(equalTo: pagerTitleView.bottomAnchor, constant: 0).isActive = true
        profilePageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profilePageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        profilePageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        editProfileButton.addTarget(self, action: #selector(showEditProfile), for: .touchUpInside)
        
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        backGroundImageView.clipsToBounds = true
        backGroundImageView.contentMode = .top
        
        pagerTitleView.addTarget(self, action: #selector(handleSegmentControl), for: .valueChanged)
        updateView()
    }
    @objc
       func tapFollowing(sender:UITapGestureRecognizer) {
           print("tap following working")
        let numberOfFollowers = auth.data.wayagramProfile?.following
        auth.data.wayagramProfile?.followers
       let vc = FollowingViewController()
        vc.numberOfFollowers = numberOfFollowers!
        
        vc.modalPresentationStyle  = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
       }
    @objc func handleSegmentControl(_ sender: AnyObject?){
        
        switch pagerTitleView.selectedIndex {
            case 0:
                profilePageViewController.setCurrentController(index: 0)   
            case 1:
                profilePageViewController.setCurrentController(index: 1)   
            case 2:
                profilePageViewController.setCurrentController(index: 2)   
            case 3:
                profilePageViewController.setCurrentController(index: 3)   
            default:
                break
        }
    }
    
    @objc func didTapBackButton(){
        dismiss(animated: false, completion: nil)
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        pagerTitleView.selectedIndex = currentIndex
    }
    
    @objc func showEditProfile(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController")  as? EditProfileViewController{
            vc.modalPresentationStyle = .fullScreen 
            vc.wayagramViewModel = wayagramViewModel
            vc.profileImageView.image = profileImageView.image
            vc.backGroundImageView.image = backGroundImageView.image
            self.present(vc, animated: true)
        } 
    }
    
    private func updateView() {
        guard let profile = auth.data.wayagramProfile else {
            return
        }
        followerLabel.valueLabel.text = String(profile.followers)
        followingLabel.valueLabel.text = String(profile.following)
        postsLabel.valueLabel.text = String(profile.postCount)
        usernameLabel.text = "@\(profile.username)"
        
        if let coverImage = profile.coverImage {
            ImageLoader.loadImageData(urlString: coverImage) { (result) in
                let image = result ?? UIImage(named: "advert-wallet")
                self.backGroundImageView.image = image
            }
        }
        
        if let avatar = profile.avatar {
            ImageLoader.loadImageData(urlString: avatar) { (result) in
                let image = result ?? UIImage(named: "profile-placeholder")
                self.profileImageView.image = image
            }
        }
    }
    
}


extension TimeLineViewController: UIScrollViewDelegate {
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //When scrollView content offset is greater than threshold (340) set the height to 0
        if scrollView.contentOffset.y  > 340{
            ProfileViewController.collapsingViewHeightContraint.constant  = 0
        }
        let offsetDiff = ProfileViewController.previousOffsetState - scrollView.contentOffset.y
        ProfileViewController.previousOffsetState = scrollView.contentOffset.y
        let newHeight = ProfileViewController.collapsingViewHeightContraint.constant + offsetDiff
        ProfileViewController.collapsingViewHeightContraint.constant = newHeight
    }

}
extension GroupViewController : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}
