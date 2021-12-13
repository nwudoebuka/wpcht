//
//  TimeLineViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/19/21.
//


class TimeLineViewController: UIViewController, Alertable {

    var wayagramViewModel : WayagramViewModelImpl!
    private var transparentBackground : UIView!
    private var postItemDropDown : PostUserItemPopUp!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpPostCollectionViews()
        fetchUserPost()
    }
    

    private func setUpPostCollectionViews(){
        
        view.addSubview(postCollectionView)
        postCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        postCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        postCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        postCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        postCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.isScrollEnabled = true
    }
    
    func fetchUserPost(){
        let profileId = UserDefaults.standard.string(forKey: "ProfileId") ?? ""
        wayagramViewModel.getPostBySingleUser(profileId: profileId) { [weak self](result) in
            switch result{
                case .success(_):
                    self?.postCollectionView.reloadData()
                case .failure(.custom(let message)):
                    print("The message \(message)")
            }
        }
    }

}

extension TimeLineViewController :  UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return wayagramViewModel.userPostResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostCollectionViewCell.identifier, for: indexPath) as! PostCollectionViewCell
        cell.backgroundColor = .white
        cell.configureWithUserPost(postResponse: wayagramViewModel.userPostResponse[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 14)]
        let size = CGSize(width: view.frame.width - 34, height: 1000)
     
        let estimatedFrame = NSString(string: wayagramViewModel.userPostResponse[indexPath.row].description ).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        
        var otherHeight  : CGFloat = 158
        if let count = wayagramViewModel.userPostResponse[indexPath.row].postImages?.count, count > 0{
            otherHeight = 328
        }
        
        return CGSize(width: view.frame.width - 34, height: estimatedFrame.height + otherHeight)
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
//            
//            newVC.profileImageView.image = profileImage ?? UIImage()
//            newVC.editPost = wayagramViewModel.selectedPost.post
//            newVC.isUpdatePost = true
//            newVC.dataController = dataController
            dismissPostItemDropDownPopUp()
            self.present(newVC, animated: true)
        }
    }
    
    @objc func deletePostFromApi(){
        LoadingView.show()
        wayagramViewModel.deletePostRequest.post_id = wayagramViewModel.selectedPost.postResponse!.id
        dismissPostItemDropDownPopUp()
        wayagramViewModel.deletePost(deletePostRequest: wayagramViewModel.deletePostRequest) {[weak self] (result) in
            switch result{
                case .success( _):
                    if let indexPath = self?.wayagramViewModel.selectedPost.indexPath{
                        self?.postCollectionView.deleteItems(at: [indexPath])
                    }
                   LoadingView.hide()
                case .failure(.custom(let message)) :
                    print("Unable to delete post  \(message)")  
                    self?.showAlert(message: "Error Deleting ")
                    LoadingView.hide()
                    
                    
            }
        }
    }
    
    
}


extension TimeLineViewController : TimeLineCollectionViewCellDelegate{

    
    func showDropDown(postResponse: PostResponse, indexPath: IndexPath) {
            if self.transparentBackground == nil{
                self.transparentBackground = UIView(frame: UIScreen.main.bounds)
                self.transparentBackground.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
                let tap = UITapGestureRecognizer(target: self, action: #selector(dismissPostItemDropDownPopUp(_:)))
                tap.numberOfTapsRequired = 1
                self.transparentBackground.addGestureRecognizer(tap)
                self.transparentBackground.isUserInteractionEnabled = true
                UIApplication.shared.keyWindow!.addSubview(self.transparentBackground)
                postItemDropDown = PostUserItemPopUp()
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
                wayagramViewModel.selectedPost.profileId = postResponse.profile.id
                wayagramViewModel.selectedPost.postId = postResponse.id
                wayagramViewModel.selectedPost.postResponse = postResponse
                postItemDropDown.deletePostButton.addTarget(self, action: #selector(deletePostFromApi), for: .touchUpInside)
                //postItemDropDown.editButton.addTarget(self, action: #selector(updatePost), for: .touchUpInside)
                
                //PostItemPopUp
            }        
    }
    
    func likePost(postId: String, profileId: String, type: String, indexPath: IndexPath) {
        let likePostRequest = LikePostRequest(post_id: postId, profile_id: profileId, type: type)
        wayagramViewModel.likePost(likePostRequest: likePostRequest) { (result) in
            print("The like response is \(result)")
            if result{
                
            } else {
            }
        }
    }
 
    

}
