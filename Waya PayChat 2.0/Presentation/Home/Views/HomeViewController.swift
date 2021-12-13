//
//  HomeViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/7/21.
//
import CoreData


final class HomeViewController: UIViewController, HomeView {
    
    //persited post from local storage
    var fetchedResultsController:NSFetchedResultsController<Post>!
        
    // closure for HomeFlowCoordinator 
    var onNavToogle: (() -> Void)?
    var showCreatePost: ((DataController) -> Void)?
    var showCreateMoment : (() -> Void)?
    var addItem = UIBarButtonItem()
    var profileImageNavItem = UIBarButtonItem()
    var showHomeFollowing : (() -> Void)?
    var showPostDetail: ((WayagramViewModelImpl) -> Void)?
    var showCommentView: ((WayagramViewModelImpl) -> Void)?
    var shouldShowLoading  = true
    
    
    var wayagramViewModel : WayagramViewModelImpl!
    var dataController:DataController!
    
    private var transparentBackground : UIView!
    private var postItemDropDown : PostItemPopUp!

    lazy var contentViewSize = CGSize(width: view.frame.width, 
                                      height: view.frame.height + 100)
    let userDefaults = UserDefaults.standard
    var profileImage  =  UIImage(named: "profile-placeholder")?.resized(to: CGSize(width: 24, height: 24))
    var transparentView : UIView!
    var createPopUpView : CreatePopUpView!
    
    
    var logoImageView : UIImageView = {
        let logoImage = UIImage.init(named: "profile-placeholder")
        let logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(x: 0, y: 0, width: 10 , height: 10)
        logoImageView.layer.masksToBounds = false
        logoImageView.layer.cornerRadius = logoImageView.frame.size.height/2
        logoImageView.clipsToBounds = true
        logoImageView.contentMode = .scaleAspectFit
        return logoImageView
    }()

        
    let momentTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textColor = UIColor(named: "color-black")
        label.text = "Moments"
        return label
    }()
    
    let postTitleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textColor = UIColor(named: "color-black")
        label.text = "Posts"
        return label
    }()
    
    var momentImage : UIImageView = {
        let imageV = UIImageView()
        let targetSize = CGSize(width: 105, height: 126)
        imageV.image = UIImage(named: "advert-wallet")
        imageV.frame = CGRect(x: 0, y: 0, width: 105 , height: 126)  
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.clipsToBounds = true
       // imageV.contentMode = .scaleAspectFit
        imageV.layer.cornerRadius = 4
        return imageV
    }()
    
    
    fileprivate let momentCollectionView : UICollectionView = {
       let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.minimumInteritemSpacing = 6
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(MomentCollectionViewCell.self, forCellWithReuseIdentifier: MomentCollectionViewCell.identifier)
        return collectionView
    }()
    
    fileprivate let postCollectionView : UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 6
        layout.minimumLineSpacing = 13
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "post-background")?.withAlphaComponent(0.3)
        collectionView.register(PostCollectionViewCell.self, forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        return collectionView
    }()
    
    var fab : UIButton = {
        var button = UIButton()
        return button
    }()
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Post> = Post.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //Since we're using big data we need to cache to enable colleciton view load faster
         
       // NSFetchedResultsController<Post>.deleteCache(withName: "posts")
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "posts")
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            if (try dataController.viewContext.count(for: fetchRequest) > 0){
                shouldShowLoading = false
            }
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

      
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProfileImage()
        setLeftItem()
        initNavView()
        setUpConstraint()
        setUpCollectionViews()
        setUpPostCollectionViews()
        setUpFab()
//        setupFetchedResultsController()
//        fetchFeedsForUser()
//        getAllMoments()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        restoreNavLine()
        setupFetchedResultsController()
        postCollectionView.reloadData()
        getUserMoment()
        
        
        //temporarily added to launch only Wayapay to be removed af 
        //showComingSoonView()
    }
    
   
    
    func initNavView(){
        navigationController?.setNavigationBarHidden(false, animated: false)
        title = "Wayagram"
        checkChangeNaviagtionStyle()
    
    
        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        addButton.setImage(UIImage.init(named: "account-plus"), for: .normal)
        addButton.addTarget(self, action: #selector(showAccountFollowerInfo), for: .touchUpInside)
        addButton.backgroundColor = .clear
        addItem = UIBarButtonItem.init(customView: addButton)
        navigationItem.rightBarButtonItem = addItem  
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back-arrow")

        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back-arrow")  
        restoreNavLine()
        

        
    }  
    
    private func fetchProfileImage()  {
        
        guard let profile = auth.data.profile, let profileImage = profile.profileImage, profileImage != "" else {
            return
        }
        
        guard let url = URL(string:  profileImage) else { return }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data) ?? UIImage(named: "profile-placeholder")
                self?.profileImage = image
                let menuBtn = UIButton(type: .custom)

                menuBtn.setBackgroundImage(self?.profileImage, for: .normal)
                menuBtn.addTarget(self, action: #selector(self?.showNavigation), for: .touchUpInside)
                menuBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                menuBtn.layer.cornerRadius = menuBtn.frame.width/2
                menuBtn.clipsToBounds = true

                let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                view.bounds = view.bounds.offsetBy(dx: 10, dy: 3)
                view.addSubview(menuBtn)
                //let backButton = UIBarButtonItem(customView: view)
                self?.profileImageNavItem = UIBarButtonItem(customView: view)

                self?.navigationItem.leftBarButtonItem = self?.profileImageNavItem
            }
        }
        task.resume()
        
    }

    private func setLeftItem(){
        let menuBtn = UIButton(type: .custom)
        
        menuBtn.setBackgroundImage(profileImage, for: .normal)
        menuBtn.addTarget(self, action: #selector(showNavigation), for: .touchUpInside)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuBtn.layer.cornerRadius = menuBtn.frame.width/2
        menuBtn.clipsToBounds = true
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.bounds = view.bounds.offsetBy(dx: 10, dy: 3)
        view.addSubview(menuBtn)
        //let backButton = UIBarButtonItem(customView: view)
        profileImageNavItem = UIBarButtonItem(customView: view)
        
        navigationItem.leftBarButtonItem = profileImageNavItem
    }
    
    
    private func setUpConstraint(){

        view.addSubview(momentTitleLabel)
        momentTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14).isActive = true
        momentTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  17).isActive = true
        momentTitleLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        view.addSubview(momentImage)
        momentImage.topAnchor.constraint(equalTo: momentTitleLabel.bottomAnchor, constant: 12).isActive = true
        momentImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  17).isActive = true
        momentImage.heightAnchor.constraint(equalToConstant: 126).isActive = true
        momentImage.widthAnchor.constraint(equalToConstant: 105).isActive = true
        
        view.addSubview(postTitleLabel)
        postTitleLabel.topAnchor.constraint(equalTo: momentImage.bottomAnchor, constant: 14).isActive = true
        postTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant:  17).isActive = true
    }
    
    private func setUpCollectionViews(){
        
        view.addSubview(momentCollectionView)
        momentCollectionView.topAnchor.constraint(equalTo: momentImage.topAnchor).isActive = true
        momentCollectionView.leadingAnchor.constraint(equalTo: momentImage.trailingAnchor, constant: 6).isActive = true
        momentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17).isActive = true
        momentCollectionView.heightAnchor.constraint(equalToConstant: 126).isActive = true
        momentCollectionView.delegate = self
        momentCollectionView.dataSource = self
    }
    
    private func setUpPostCollectionViews(){
        
        view.addSubview(postCollectionView)
        postCollectionView.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor).isActive = true
        postCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17).isActive = true
        postCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17).isActive = true
        postCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        postCollectionView.widthAnchor.constraint(equalToConstant: view.frame.width - 34).isActive = true
        postCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.isScrollEnabled = true
    }

    private func setUpFab(){
        fab.frame = CGRect(x: view.frame.width - 68 , y: view.frame.height - 78 - (tabBarController?.tabBar.frame.height ?? 0), width: 48, height: 48)
        fab.setImage(UIImage(named: "floating-button"), for: .normal)
        view.addSubview(fab)
        fab.bringSubviewToFront(view)
        fab.addTarget(self, action: #selector(showCreatePopUp), for: .touchUpInside)
    }
    
    
    @objc func showNavigation(){
        onNavToogle?()
    }

    @objc func didTapCreateMoment(){
        showCreateMoment?()
    }
    
    @objc func didTapCreatePost(){
        showCreatePost?(dataController)
    }
    
    @objc func showAccountFollowerInfo(){
        showHomeFollowing?()
    }
    
    @objc func showCreatePopUp(){
        if transparentView == nil{
            createPopUpView = CreatePopUpView()
            createPopUpView.layer.cornerRadius = 8
            createPopUpView.backgroundColor = .white
            createPopUpView.translatesAutoresizingMaskIntoConstraints = false
            self.transparentView = UIView(frame: UIScreen.main.bounds)
            self.transparentView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            let tap = UITapGestureRecognizer(target: self, action: #selector(removePopUp(_:)))
            tap.numberOfTapsRequired = 1
            self.transparentView.addGestureRecognizer(tap)
            self.transparentView.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.addSubview(self.transparentView)
            let createPostGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showPostMomentView))
            createPostGestureRecognizer.numberOfTapsRequired = 1
            //  self.opaqueView.addGestureRecognizer(gestureRecognizer)
            let createMomentGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showCreateMomentView))
            createMomentGestureRecognizer.numberOfTapsRequired = 1
            self.createPopUpView.isUserInteractionEnabled = true
            self.createPopUpView.momentView.addGestureRecognizer(createMomentGestureRecognizer)
            self.createPopUpView.postView.addGestureRecognizer(createPostGestureRecognizer)
            transparentView.addSubview(createPopUpView)
            createPopUpView.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor, constant: 14).isActive = true
            createPopUpView.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor, constant: -14).isActive = true
            createPopUpView.topAnchor.constraint(equalTo: transparentView.topAnchor, constant: 37).isActive = true
            createPopUpView.bottomAnchor.constraint(equalTo: fab.topAnchor, constant: -12).isActive = true
            UIApplication.shared.keyWindow!.bringSubviewToFront(self.transparentView)
    
            self.view.bringSubviewToFront(self.transparentView)
        }
    }
    
    @objc func removePopUp(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentView.alpha = 0
        }) {  done in
            if(self.transparentView != nil){
                self.transparentView.removeFromSuperview()
                self.transparentView = nil
                self.createPopUpView = nil
            }
        }
    }

    // navigate to CreateMomentView
    @objc func showCreateMomentView(){
        removePopUp()
        if let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateMomentViewController")  as? CreateMomentViewController{
            newVC.profilePictureImage = profileImage ?? UIImage()
            self.present(newVC, animated: true)
        }
    }
    
    @objc func showPostMomentView(){
        removePopUp()
        if let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController")  as? CreatePostViewController{
            newVC.profileImageView.image = profileImage ?? UIImage(named: "profile-placeholder")
            newVC.dataController = dataController
            self.present(newVC, animated: true)
        }
    }
    
    func fetchFeedsForUser(_ pageNumber : Int = 0){
        if (shouldShowLoading){
            LoadingView.show()
        }
        wayagramViewModel.getFeedForUser{ [weak self](result) in
            switch result{
                case .success(let response):
                    if let count = self?.wayagramViewModel.userFeedResponse.count, count > 0{
                        for i in 0...count-1{
                            self?.addPost(postResponse: (self?.wayagramViewModel.userFeedResponse[i])!)
                        }
                    }
                    //Do not use loading screen
                    if (self!.shouldShowLoading){
                        LoadingView.hide()
                        self?.shouldShowLoading = false
                    }

                    self?.postCollectionView.reloadData()
                case .failure(.custom(let message)):
                    print(message)
                   //Do not use loading screen 
                    if ((self!.shouldShowLoading) != nil){
                        LoadingView.hide()
                        self?.shouldShowLoading = false
                    }
            }
        }
    }
    
    @objc func deletePostFromApi(){
        LoadingView.show()
        wayagramViewModel.deletePostRequest.post_id = wayagramViewModel.selectedPost.postId
        dismissPostItemDropDownPopUp()
        wayagramViewModel.deletePost(deletePostRequest: wayagramViewModel.deletePostRequest) {[weak self] (result) in
            switch result{
                case .success(let response):
                    print("The post response")
                    if let indexPath = self?.wayagramViewModel.selectedPost.indexPath{
                        self?.deletePost(at: indexPath)
                    }
                    LoadingView.hide()
                case .failure(.custom(let message)) :
                    print("Unable to delete post  \(message)")  
                  //  self?.showAlert(message: "Error Deleting ")
                    LoadingView.hide()


            }
        }
    }
    
    
    // Get this current user moment
    func getUserMoment(){
        print("Getting user moment ")
        wayagramViewModel.getUserMoments { [weak self](result) in
            switch result{
                case .success( _):
                    print("Gotten user moment ")
                    self?.momentImage.image = self?.wayagramViewModel.momentBackGroundImage                        
                case .failure(.custom(let message)):
                    print("Wayagram All Moments \(message)")
            }

        }
    }
    
    
    //Get all user moments 
    func getAllMoments(){
        wayagramViewModel.getAllMoments {[weak self] (result) in
            switch result{
                case .success(let response):
                    if let response_ = response as? [MomentResponse]{
                        self?.wayagramViewModel.allMoments = response_
                        print("The wayagram all moments is given as \(self?.wayagramViewModel.allMoments)")
                    }
                    self?.momentCollectionView.reloadData()
                case .failure(.custom(let message)):
                    print("Wayagram All Moments \(message)")
            }
        }
    }
    
    //Save/Bookmark a post 
    func savePostResponse(){
        // To do make api calls to save a post 
    }
    
    func addPost(postResponse: PostResponse) {
        let post = Post(context: dataController.viewContext)
        post.id = postResponse.id
        post.createdAt = postResponse.createdAt
//        post.fullName = "\(postResponse.profile.user.firstName) \(postResponse.profile.user.surname)"
        post.username = postResponse.profile.username
        post.groupId = postResponse.groupID
        post.commentCount = Int16(postResponse.commentCount)
        post.likesCount = Int16(postResponse.likesCount)
        post.postDescription = postResponse.description
        post.isPostDeleted = postResponse.isDeleted
        post.hasLiked = postResponse.isLiked
        post.type = postResponse.type
        post.profileId = postResponse.profile.id
        if let count = postResponse.images?.count , count > 0{
            post.hasImage = true
            if let imgCount =  postResponse.postImages?.count , imgCount > 0{
                post.postImage = postResponse.postImages?[0].jpegData(compressionQuality: 0.5)
            }
        } else{
            post.hasImage = false
        }
        if let img = postResponse.uiImage?.jpegData(compressionQuality: 0.5){
            post.creatorImage = img
        }
        
        let fetchRequest:NSFetchRequest<Post> = Post.fetchRequest()
        
        do{
            if (try dataController.viewContext.count(for: fetchRequest) > 500){
                // to do delete all elements if it greateer than 5000
                print("fetxh indexPath \(try dataController.viewContext.count(for: fetchRequest))")
            }
            
        } catch{
            
        }
        
                
        try? dataController.viewContext.save()
    }
    
    // Deletes the `Post` at the specified index path
    func deletePost(at indexPath: IndexPath) {
        
        let postToDelete = fetchedResultsController.object(at: indexPath)
        dataController.viewContext.delete(postToDelete)
        try? dataController.viewContext.save()
    }
    

    
    func likePost(postId: String, profileId: String, type: String, indexPath: IndexPath) {
        LoadingView.show()
        let likePostRequest = LikePostRequest(post_id: postId, profile_id: profileId, type: type)
        wayagramViewModel.likePost(likePostRequest: likePostRequest) {[weak self] (result) in
            print("The like response is \(result)")

            if result{
                self?.fetchedResultsController.object(at: indexPath).hasLiked = true
                self?.fetchedResultsController.object(at: indexPath).likesCount += 1
                
                do{
                    
                      try  self?.dataController.viewContext.save()
                        
                    
                } catch{
                    print(error)
                }
                LoadingView.hide()

//                let cell = self?.postCollectionView.cellForItem(at: indexPath)  as? PostCollectionViewCell
//                cell?.likeButton.setImage(UIImage(named: "like-fill-icon"), for: .normal)
//                var likeCount  = self?.fetchedResultsController.object(at: indexPath).likesCount ?? 0
//                likeCount += 1
//                print("The like count is \(likeCount)")
//                cell?.likeButton.setTitle(String(likeCount), for: .normal)

                //cell?.likeButton.setTitle(String(self?.fetchedResultsController.object(at: indexPath).likesCount ?? 0 + 1), for: .normal)
            } else {
                LoadingView.hide()
            }
        }
    }
    
    //MARK: TODO:- Refactor this
    func repost(post: Post, indexPath: IndexPath) {
        LoadingView.show()
        wayagramViewModel.getPostById(postId: post.id!) {[weak self] (result) in
            switch result{
                case .success(let response):
                    if let response_ = response as? PostResponse{
                        print("Fetching post by id success \(response_) ")
                        self?.wayagramViewModel.createPostRequestWithImages.amount = 0
                        self?.wayagramViewModel.createPostRequestWithImages.description = response_.description
                        self?.wayagramViewModel.createPostRequestWithImages.parent_id = post.id
                        if post.hasImage && post.postImage != nil {
                            if let image = UIImage(data: post.postImage!){
                                self?.wayagramViewModel.createPostRequestWithImages.images.append(image) 
                            }
                        }
                        self?.wayagramViewModel.createPostRequestWithImages.profile_id = UserDefaults.standard.string(forKey: "ProfileId") ?? ""
                        self?.wayagramViewModel.createPostRequestWithImages.group_id = response_.groupID
                        self?.wayagramViewModel.createPostRequestWithImages.page_id = response_.pageID
                        self?.wayagramViewModel.createPostRequestWithImages.type = response_.type
                        self?.wayagramViewModel.createPostRequestWithImages.isPoll = response_.isPoll
                       // self?.wayagramViewModel.createPostRequestWithImages.isPaid = response_.is
                        //self?.wayagramViewModel.createPostRequestWithImages.forceTerms =
                        self?.wayagramViewModel.createPostWithImages(createPostRequest: (self?.wayagramViewModel.createPostRequestWithImages)!) {[weak self] (result) in
                            
                            switch result{
                                case .success(let response):
                                    if let response_ = response as? CreatePostResponse{
                                        self?.wayagramViewModel.getPostById(postId: response_.id) {[weak self] (result) in
                                            switch result{
                                                case .success(let response):
                                                    if var response_  = response as? PostResponse{
                                                        if response_.profile.user.profileImage != nil && response_.profile.user.profileImage != "" {
                                                            ImageLoader.loadImageData(urlString: response_.profile.user.profileImage! ){
                                                                (result) in
                                                                response_.uiImage = result 
                                                                if let count = response_.images?.count, count > 0{
                                                                    ImageLoader.loadImageData(urlString: response_.images![0].imageURL) { (result) in
                                                                        let image = result ?? UIImage(named: "advert-wallet")
                                                                        if let image_ = image{
                                                                            response_.postImages?.append(image_) 
                                                                        }
                                                                    }
                                                                }
                                                              
                                                            }
                                                        } 
                                                        else{
                                                            if let count = response_.images?.count, count > 0{
                                                                ImageLoader.loadImageData(urlString: response_.images![0].imageURL) { (result) in
                                                                    let image = result ?? UIImage(named: "advert-wallet")
                                                                    if let image_ = image{
                                                                        response_.postImages?.append(image_) 
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        self?.addPost(postResponse: response_)
                                                        self?.postCollectionView.reloadData()
                                                        LoadingView.hide()
                                                    } else{
                                                        LoadingView.hide()
                                                    }
                                                case .failure(.custom(let message)):
                                                    print("Message of getting single Post \(message)")
                                                    LoadingView.hide()
                                            }
                                        }
                                        // addPost(postResponse: response_.id)
                                    }else{
                                        LoadingView.hide()
                                        self?.dismiss(animated: true, completion: nil)
                                    }
                                    
                                case .failure(.custom(let message)):
                                    print(message)
                                    LoadingView.hide()
                                    
                            }
                        }
                    }
                case .failure(.custom(let message)):
                    print("Fetching post by id falied \(message)")
                    LoadingView.hide()
            }
        }
    }
    
    
    @objc func dismissPostItemDropDownPopUp(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentBackground.alpha = 0
        }) {  done in
            self.transparentBackground.removeFromSuperview()
            self.transparentBackground = nil
        }
    }
    
    @objc func updatePost(){
        if let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostViewController")  as? CreatePostViewController{
            
            newVC.profileImageView.image = profileImage ?? UIImage()
            newVC.editPost = wayagramViewModel.selectedPost.post
            newVC.isUpdatePost = true
            newVC.dataController = dataController
            dismissPostItemDropDownPopUp()
            self.present(newVC, animated: true)
        }
    }
        
}



extension HomeViewController :   UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1 
//        //return fetchedResultsController.sections?.count ?? 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == momentCollectionView{
            print("Moment count \(wayagramViewModel.allMoments.count)")
            return wayagramViewModel.allMoments.count
        } else if collectionView == postCollectionView{
            return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == momentCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MomentCollectionViewCell.identifier, for: indexPath) as! MomentCollectionViewCell
            print("The index path row \(indexPath.row) and section \(indexPath.section) and self \(indexPath)")
            cell.configureMoment(moment: wayagramViewModel.allMoments[indexPath.row])
            return cell
            
        } else{
            let post = fetchedResultsController.object(at: indexPath)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
            cell.indexPath = indexPath
            cell.postCellDelegate = self
            cell.configureWithPost(post: post)
            cell.backgroundColor = .white
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == postCollectionView{
            print("was selected")
            let post = fetchedResultsController.object(at: indexPath)
            wayagramViewModel.selectedPost.indexPath = indexPath
            wayagramViewModel.selectedPost.post = post
            wayagramViewModel.selectedPost.profileId = post.profileId!
            wayagramViewModel.selectedPost.position = indexPath.row
            showPostDetail?(wayagramViewModel)
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == momentCollectionView{
            return CGSize(width: 105, height:  126)
        }
        
        else if collectionView == postCollectionView {
            print("Here")
        
            let attributes = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 14)]
            let size = CGSize(width: view.frame.width - 34, height: 1000)
            let post = fetchedResultsController.object(at: indexPath)
            let estimatedFrame = NSString(string: post.postDescription ?? "").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            
            var otherHeight  : CGFloat = 158
            if post.hasImage{
                otherHeight = 328
            }
                        
            return CGSize(width: view.frame.width - 34, height: estimatedFrame.height + otherHeight)
            
        }
        print("This diddn't work ")
        return CGSize(width: view.frame.width, height: 200)

    }

}


extension HomeViewController:NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                postCollectionView.insertItems(at: [newIndexPath!])
                break
            case .delete:
                if let indexPath = newIndexPath{
                    postCollectionView.deleteItems(at: [indexPath])  
                }
                break
            case .update:
                postCollectionView.reloadItems(at: [newIndexPath!])
            case .move:
                postCollectionView.moveItem(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
            case .insert: postCollectionView.insertSections(indexSet)
            case .delete: postCollectionView.deleteSections(indexSet)
            case .update, .move:
                fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        postCollectionView.reloadData()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        postCollectionView.reloadData()
    }
    
}


extension HomeViewController : PostCollectionViewCellDelegate{
    func showDropDown(post: Post, indexPath : IndexPath) {
        if self.transparentBackground == nil{
            self.transparentBackground = UIView(frame: UIScreen.main.bounds)
            self.transparentBackground.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPostItemDropDownPopUp(_:)))
            tap.numberOfTapsRequired = 1
            self.transparentBackground.addGestureRecognizer(tap)
            self.transparentBackground.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.addSubview(self.transparentBackground)
            postItemDropDown = PostItemPopUp()
            postItemDropDown.backgroundColor = .white
            postItemDropDown.layer.cornerRadius = 24
            postItemDropDown.translatesAutoresizingMaskIntoConstraints = false
            transparentBackground.addSubview(postItemDropDown)
            postItemDropDown.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            postItemDropDown.trailingAnchor.constraint(equalTo: transparentBackground.trailingAnchor, constant: -17).isActive = true
            postItemDropDown.heightAnchor.constraint(equalToConstant: 240).isActive = true
            postItemDropDown.widthAnchor.constraint(equalToConstant: 210).isActive = true
            postItemDropDown.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.bringSubviewToFront(self.transparentBackground)
            self.view.bringSubviewToFront(self.transparentBackground)
            wayagramViewModel.selectedPost.position = indexPath.row
            wayagramViewModel.selectedPost.indexPath = indexPath
            wayagramViewModel.selectedPost.profileId = post.profileId!
            wayagramViewModel.selectedPost.postId = post.id!
            wayagramViewModel.selectedPost.post = post
            //postItemDropDown.deletePostButton.addTarget(self, action: #selector(deletePostFromApi), for: .touchUpInside)
            //postItemDropDown.editButton.addTarget(self, action: #selector(updatePost), for: .touchUpInside)
            
        }
    }   
}
