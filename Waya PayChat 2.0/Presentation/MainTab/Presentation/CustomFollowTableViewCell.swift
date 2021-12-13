//
//  CustomFollowTableViewTableViewCell.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/19/21.
//
protocol CustomFollowTableViewCellDelegate {
    func onFollowClick(indexPath : IndexPath, followUserRequest: FollowUserRequest)
}

class CustomFollowTableViewCell: UITableViewCell {

    static let identifier = "CustomFollowTableViewCell"
    var buttonWidthContraint : NSLayoutConstraint!
    
    var  wayagramProfile: WayagramProfileResponse?
    var cellDelegate : CustomFollowTableViewCellDelegate!
    var indexPath : IndexPath!
    
    let lineView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "color-gray1")?.withAlphaComponent(0.2)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let itemImageView : UIImageView = {
        let imageView =  UIImageView()
        let w : CGFloat = 40
        imageView.frame.size.height = w
        imageView.frame.size.width = w
        imageView.image = UIImage(named: "test")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let button =  UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "#Food"
        label.textColor = UIColor(named: "color-black")
        label.font = UIFont(name: "Lato-Bold", size: 14)
        return label
    }()
    
    let valueLabel : UILabel = {
        let label = UILabel()
        label.text = "2000 Conversation"
        label.textColor = UIColor(named: "color-gray1")
        label.font = UIFont(name: "Lato-Regular", size: 14)
        return label
    }()
    
    let forwardButton : UIButton = {
        let button = UIButton()
        button.transparentButton()
        button.layer.borderColor = UIColor(named: "color-primary")?.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let numberStack = UIStackView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
        // Configure the view for the selected state
    }
    
    private func setUpView(){
        
        numberStack.translatesAutoresizingMaskIntoConstraints = false
        
        numberStack.axis = .vertical
        numberStack.distribution = .fillEqually
        
        numberStack.addArrangedSubview(titleLabel)
        numberStack.addArrangedSubview(valueLabel)
        
        addSubview(itemImageView)
        contentView.addSubview(forwardButton)
        addSubview(numberStack)
        
        itemImageView.frame.size = CGSize(width: 40, height: 40)
        itemImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        itemImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        itemImageView.circularImage()
        
     
        
        //buttonWidthContraint = forwardButton.widthAnchor.constraint(equalToConstant: 70)
       // buttonWidthContraint.isActive = true
        forwardButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        forwardButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        forwardButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        forwardButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true

        numberStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        numberStack.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 14).isActive = true
        numberStack.trailingAnchor.constraint(equalTo: forwardButton.leadingAnchor, constant: -16).isActive = true
        
        addSubview(lineView)
        lineView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lineView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFollowButton(_:)))
        tapGestureRecognizer.numberOfTouchesRequired = 1
        forwardButton.addGestureRecognizer(tapGestureRecognizer)
     
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))
        itemImageView.addGestureRecognizer(tapGestureRecognizer2)

    }
    
    func configureCell(){
        titleLabel.text = "#Food"
        valueLabel.text = "700 Conversations"
        forwardButton.setTitle("Follow", for: .normal)
        
    }
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        print("did tap view", sender)
    }
    
    
    func configureCellFollowing(folloItem : FollowerViewModelItem ){
        titleLabel.text =  folloItem.headerLabel
        valueLabel.text =  folloItem.subHeaderLabel
        forwardButton.setTitle("Follow", for: .normal)
        
    }
    
    @objc func didTapFollowButton(_ sender : UITapGestureRecognizer){
        print("Follower was tap")
        if wayagramProfile != nil{
            let userId = String(UserDefaults.standard.integer(forKey: "UserId"))
            cellDelegate.onFollowClick(indexPath: indexPath, followUserRequest: FollowUserRequest(user_id:userId , username: (wayagramProfile?.username)!))
        }
    }
    
    func configureCellForPeople(wayagramProfile: WayagramProfileResponse){
//        titleLabel.text = "\(wayagramProfile.user.firstName) \(wayagramProfile.user.surname)"
        valueLabel.text = "\(wayagramProfile.username)"
        forwardButton.setTitle("Follow", for: .normal)
        if wayagramProfile.user.profileImage != nil || wayagramProfile.user.profileImage != ""{
            ImageLoader.loadImageData(urlString: wayagramProfile.user.profileImage!) {[weak self] (result) in
                if let image = result{
                    self?.itemImageView.image = image
                } else{
                    self?.itemImageView.image = UIImage(named: "profile-placeholder") 
                }
            }
        }
        if wayagramProfile.connection!.followsYou {
//            forwardButton.
            forwardButton.setTitle("Following", for: .normal)
            forwardButton.titleLabel?.textColor = .white
        }
    }
    
    
    
    
}
