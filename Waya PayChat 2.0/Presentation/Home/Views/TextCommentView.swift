//
//  TextCommentView.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/5/21.
//


class TextCommentView: UIView{
    
    var profileImageView : UIImageView!
    
    var commentTextField : UITextField = {
       let textField = TextField()
        textField.backgroundColor = UIColor(named: "white-smoke") ?? .lightGray
        textField.frame.size.height = 40
        textField.layer.cornerRadius = 18
        textField.placeholder = "Type your comment"
        textField.clipsToBounds = true
        return textField
    }()
    
    let sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor(named: "dark-gray"), for:  .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Bold", size: 16)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        profileImageView = generateProfileImageView()
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, 
                                padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0), size: CGSize(width: 40, height: 40))
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor
                            , padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16), size: CGSize(width: 40, height: 40))
        
        addSubview(commentTextField)
        commentTextField.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: sendButton.leadingAnchor
                               , padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        commentTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    }
}
