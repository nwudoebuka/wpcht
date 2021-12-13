//
//  PostCollectionViewCell.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/9/21.
//

protocol PostCellDelegate  {
    func likePost(postId: String, profileId : String, type: String, indexPath: IndexPath)

}
protocol PostCollectionViewCellDelegate  : PostCellDelegate{
    func showDropDown(post: Post, indexPath: IndexPath)
    func repost(post: Post, indexPath: IndexPath)
}

protocol  TimeLineCollectionViewCellDelegate : PostCellDelegate {
    func showDropDown(postResponse: PostResponse, indexPath: IndexPath)
}


/* User feed and user timeline postCell
 **/
class PostCollectionViewCell: UICollectionViewCell {
   
    static let identifier = "PostCollectionViewCell"

    var postCellDelegate : PostCollectionViewCellDelegate!
    var timeLineCellDelegate : TimeLineCollectionViewCellDelegate!
    var postImageHeightConstraint : NSLayoutConstraint!
    var post : Post?
    var postResponse : PostResponse!
    var indexPath : IndexPath!
    var isTimeLine = false  //determine whether it user feed or user time line 
    
    var profileImage : UIImageView = {
        let imageV = UIImageView()
        let targetSize = CGSize(width: 42, height: 42)
        imageV.image = UIImage(named: "advert-wallet")
        imageV.frame = CGRect(x: 0, y: 0, width: 42 , height: 42)  
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.circularImage()
        return imageV
    }()
    
    let fullNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Bold", size: 14)
        label.textColor = UIColor(named: "color-black")
        label.text = "User FullName"
        return label
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 14)
        label.textColor = UIColor(named: "toolbar-color-primary")
        label.text = "Username"
        return label
    }()
    
    let timeLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 13)
        label.textColor = UIColor(named: "toolbar-color-primary")
        label.text = "2h"
        return label
    }()
    
    
    let dropDownButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(named: "drop-down-horizontal"), for: .normal)
        return button
    }()
    
    let headerView = UIView()
    
    let dividerTopLine : UIView = {
        let line = UIView()
        line.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.8)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    let commentButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("  0", for: .normal)
        button.setImage(UIImage(named: "comment-icon"), for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    let likeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("  0", for: .normal)
        button.setImage(UIImage(named: "post-like-default"), for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    let repostButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setBackgroundImage(UIImage(named: "repost-icon"), for: .normal)
        return button
    }()
    
    let shareButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setBackgroundImage(UIImage(named: "post-share"), for: .normal)
     
        return button
    }()
    
    let postLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 14)
        label.textColor = UIColor(named: "toolbar-color-primary")
        label.numberOfLines = 0
        label.text = "we strongly believe that social networking apps are primarily about being easy-to-navigate and engaging"
        return label
    }()
    
    let postView  : UIView = {
       let view  = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
       return view 
    }()
    
    var postImage : UIImageView = {
        let imageV = UIImageView()
        imageV.image = UIImage(named: "advert-wallet")
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 10
        imageV.contentMode = .top
        return imageV
    }()
    
    var bottomContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(){
        headerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerView)
        headerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        headerView.addSubview(profileImage)
        profileImage.centerYAnchor.constraint(equalTo: headerView.centerYAnchor ,constant: 8).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 42).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 42).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        
        headerView.addSubview(fullNameLabel)
        fullNameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        fullNameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 11).isActive = true
        fullNameLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        
        headerView.addSubview(dropDownButton)
        dropDownButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        dropDownButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true 
        dropDownButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        headerView.addSubview(timeLabel)
        timeLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        //timeLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 10).isActive = true 
        timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: dropDownButton.leadingAnchor, constant: -30).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        headerView.addSubview(userNameLabel)
        userNameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor, constant: 11).isActive = true 
        userNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: timeLabel.leadingAnchor, constant: -10).isActive = true
        userNameLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        addSubview(dividerTopLine)
        dividerTopLine.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8).isActive = true
        dividerTopLine.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        dividerTopLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(bottomContainer)
        bottomContainer.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bottomContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        bottomContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bottomContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        
        bottomContainer.addSubview(commentButton)
        commentButton.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        commentButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        bottomContainer.addSubview(likeButton)
        likeButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 32).isActive = true
        likeButton.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        
        bottomContainer.addSubview(repostButton)
        repostButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 32).isActive = true
        repostButton.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        
        bottomContainer.addSubview(shareButton)
        shareButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        shareButton.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
        
        
        addSubview(postView)
        postView.topAnchor.constraint(equalTo: dividerTopLine.bottomAnchor, constant: 10).isActive = true
        postView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        postView.bottomAnchor.constraint(equalTo: bottomContainer.topAnchor, constant: -5).isActive = true
        
        postView.addSubview(postLabel)
        postLabel.topAnchor.constraint(equalTo: postView.topAnchor).isActive = true
        postLabel.widthAnchor.constraint(equalTo: postView.widthAnchor).isActive = true
        
        postView.addSubview(postImage)
        postImage.topAnchor.constraint(equalTo: postLabel.bottomAnchor, constant: 5).isActive = true
        postImage.widthAnchor.constraint(equalTo: postView.widthAnchor).isActive = true
        postImageHeightConstraint = postImage.heightAnchor.constraint(equalToConstant: 0)
        postImageHeightConstraint.isActive = true
             
        likeButton.addTarget(self, action: #selector(didClickLikePost), for: .touchUpInside)
        dropDownButton.addTarget(self, action: #selector(didClickDropDown), for: .touchUpInside)
        repostButton.addTarget(self, action: #selector(didTapRepost), for: .touchUpInside)
    }
    
    
    func configureWithPost(post: Post){
        print("The image view in a ")
        //profileImage.image = post.creatorImage
        self.post = post
        fullNameLabel.text = post.fullName
        if  post.username  != nil{
            userNameLabel.text = "@" + post.username!
        }
        if post.postDescription != nil{
            postLabel.text = post.postDescription!
        }
        if post.hasLiked == true{
            likeButton.setImage(UIImage(named: "like-fill-icon"), for: .normal)
            
        } else{
            likeButton.setImage(UIImage(named: "post-like-default"), for: .normal)

        }
        likeButton.setTitle("  \(String(post.likesCount))", for: .normal)
        commentButton.setTitle("   \(String(post.commentCount))", for: .normal)
        postImage.isHidden = true
        if post.hasImage{
            postImageHeightConstraint.isActive = false
            postImageHeightConstraint = postImage.heightAnchor.constraint(equalToConstant: 170)
            postImageHeightConstraint.isActive = true
            postImage.isHidden = false
            if let data = post.postImage{
                if let image  = UIImage(data: data){
                    postImage.image = image
                }   
            }
            
        }
        
        if let creatorImageData = post.creatorImage{
            if let avatar = UIImage(data: creatorImageData){
                profileImage.image = avatar
            }
        }
       
    }
    
    func configureWithUserPost(postResponse: PostResponse){
        self.postResponse = postResponse
//        fullNameLabel.text = "\(postResponse.profile.user.firstName) \(postResponse.profile.user.surname)"
        userNameLabel.text = "@ \(postResponse.profile.username)"
        postLabel.text = postResponse.description
        if postResponse.isLiked{
            likeButton.setImage(UIImage(named: "like-fill-icon"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "post-like-default"), for: .normal)
        }
        likeButton.setTitle("  \(String(postResponse.likesCount))", for: .normal)
        commentButton.setTitle("  \(String(postResponse.commentCount))", for: .normal)
        profileImage.image = postResponse.uiImage
        if let count = postResponse.postImages?.count, count > 0{
            postImageHeightConstraint.isActive = false
            postImageHeightConstraint = postImage.heightAnchor.constraint(equalToConstant: 170)
            postImageHeightConstraint.isActive = true
            postImage.isHidden = false
            postImage.image = postResponse.postImages![0]
        }
    }
    
    
    @objc func didClickLikePost(){
        likeButton.setImage(UIImage(named: "like-fill-icon"), for: .normal)
        postCellDelegate.likePost(postId: post!.id ?? "", profileId: post!.profileId ?? "", type: post!.type ?? "",  indexPath: indexPath)

    }
    
    @objc func didClickDropDown(){
        if isTimeLine {
            timeLineCellDelegate.showDropDown(postResponse: postResponse, indexPath: indexPath)
        }
        else if post != nil {
            postCellDelegate.showDropDown(post: post!, indexPath: indexPath) 
        }
        
    }
    
    @objc func didTapRepost(){
        postCellDelegate.repost(post: post! , indexPath: indexPath)
    }

}
