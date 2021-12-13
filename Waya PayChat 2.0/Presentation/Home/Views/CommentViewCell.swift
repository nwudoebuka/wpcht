//
//  CommentViewCell.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/5/21.
//

class CommentViewCell: UITableViewCell {
    
    var fullNameLabel : UILabel!
    var usernameLabel : UILabel!
    var timeLabel : UILabel!
    var commentTextlabel : UILabel!
    
    static let identifier = "CommentViewCell"
    
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
    var nameStack: UIStackView!
    
    let textCardView = UIView()
    var profileImageView : UIImageView!
    
    
    let dropDownButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(named: "drop-down-horizontal"), for: .normal)
        return button
    }()
    
    let dividerLine : UIView = {
        let line = UIView()
        line.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.8)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        nameStack = generateStackView(axis: .vertical)
        fullNameLabel = latoTextRegular(text: "AdewoleDadedjjjjj ONNNNNNNNNNN")
        usernameLabel = latoTextRegular(text: "@dayobanjo", textColor: UIColor(named: "tab-item_default-color") ?? .lightGray)
        commentTextlabel = latoTextRegular(text: "we strongly believe that social networking apps \n are primarily about being easy-to-navigate and \n engaging")
        commentTextlabel.textAlignment = .left
        
        timeLabel = latoTextRegular(text: "48 min", textColor: UIColor(named: "tab-item_default-color") ?? .lightGray)
        
        buttonStack = generateStackView()
        headerStack = generateStackView()
        profileImageView = generateProfileImageView()
        
        buttonStack.addArrangedSubview(likeButton)
        buttonStack.addArrangedSubview(commentButton)
        buttonStack.addArrangedSubview(timeLabel)
        
        nameStack.addArrangedSubview(fullNameLabel)
        nameStack.addArrangedSubview(usernameLabel)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 0),
                                size: CGSize(width: 40, height: 40))
        
        addSubview(dropDownButton)
        dropDownButton.anchor(top: profileImageView.bottomAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 14))
        
        addSubview(nameStack)
        nameStack.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: dropDownButton.leadingAnchor, padding: UIEdgeInsets(top: 16, left: 14, bottom: 0, right: 14))
        
        addSubview(dividerLine)
        dividerLine.anchor(top: profileImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 13, left: 26, bottom: 0, right: 0))
        dividerLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        addSubview(commentTextlabel)
        commentTextlabel.anchor(top: profileImageView.bottomAnchor, leading: dividerLine.trailingAnchor, bottom: nil, trailing: trailingAnchor, 
                                padding: UIEdgeInsets(top: 13, left: 26, bottom: 0, right: 19))
        
        addSubview(buttonStack)
        buttonStack.anchor(top: buttonStack.bottomAnchor, leading: dividerLine.trailingAnchor, bottom: nil, trailing: trailingAnchor, 
                           padding: UIEdgeInsets(top: 13, left: 26, bottom: 0, right: 19))
        
    }

}
