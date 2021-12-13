//
//  PostCommentViewCell.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/1/21.
//


class PostCommentViewCell: UITableViewCell {

    var fullNameLabel : UILabel!
    var usernameLabel : UILabel!
    var timeLabel : UILabel!
    var commentTextlabel : UILabel!
    
    var commentResp : CommentResponse!
    
    static let identifier = "PostCommentViewCell"
    
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
    
    var likeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.setTitle("  0", for: .normal)
        button.setImage(UIImage(named: "post-like-default"), for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        return button
    }()
    
    var buttonStack : UIStackView!
    var headerStack : UIStackView!

    let textCardView = UIView()
    var profileImageView : UIImageView!
    
    
    let dropDownButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(named: "drop-down-horizontal"), for: .normal)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder)) has not been implemented")
    }

    private func setUpView(){
        fullNameLabel = latoTextRegular(text: "AdewoleDadedjjjjj ONNNNNNNNNNN")
        usernameLabel = latoTextRegular(text: "@dayobanjo", textColor: UIColor(named: "tab-item_default-color") ?? .lightGray)
        commentTextlabel = latoTextRegular(text: "we strongly believe that social networking apps \n are primarily about being easy-to-navigate and \n engaging")
        commentTextlabel.textAlignment = .left
        
        timeLabel = latoTextRegular(text: "48 min", textColor: UIColor(named: "tab-item_default-color") ?? .lightGray)
        
        buttonStack = generateStackView()
        buttonStack.spacing = 24
        headerStack = generateStackView()
        profileImageView = generateProfileImageView()
        
        buttonStack.addArrangedSubview(likeButton)
        buttonStack.addArrangedSubview(commentButton)
        
        headerStack.addArrangedSubview(fullNameLabel)
        headerStack.addArrangedSubview(usernameLabel)
        headerStack.addArrangedSubview(timeLabel)
        
        textCardView.cornerWithWhiteBg(8)
        textCardView.backgroundColor = UIColor(named: "white-smoke")
        
    
        textCardView.addSubview(headerStack)
        headerStack.anchor(top: textCardView.topAnchor, leading: textCardView.leadingAnchor, bottom: nil, trailing: textCardView.trailingAnchor, 
                           padding: UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10))
        headerStack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        textCardView.addSubview(commentTextlabel)
        commentTextlabel.anchor(top: headerStack.bottomAnchor, leading: textCardView.leadingAnchor, bottom: nil, trailing: textCardView.trailingAnchor, 
                           padding: UIEdgeInsets(top: 6, left: 10, bottom: 0, right: 10))
        headerStack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        textCardView.addSubview(buttonStack)

        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0), size: CGSize(width: 42, height: 42))
        
        addSubview(textCardView)
        textCardView.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 0))
        
        buttonStack.anchor(top: commentTextlabel.bottomAnchor, leading: nil, bottom: textCardView.bottomAnchor, trailing: textCardView.trailingAnchor, padding: UIEdgeInsets(top: 6, left: 0, bottom: 20, right: 18))
        buttonStack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    func configureWithCommentResponse(commentResp : CommentResponse){
        self.commentResp = commentResp
        commentTextlabel.text = commentResp.comment
    }
}
