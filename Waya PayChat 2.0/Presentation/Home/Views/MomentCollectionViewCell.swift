//
//  MomentCollectionViewCell.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/9/21.
//


class MomentCollectionViewCell: UICollectionViewCell {

    static let identifier = "MomentCollectionViewCell"
    
    var momentImage : UIImageView = {
        let imageV = UIImageView()
        let targetSize = CGSize(width: 105, height: 126)
        imageV.image = UIImage(named: "moment-placeholder")
        imageV.frame = CGRect(x: 0, y: 0, width: 105 , height: 126)  
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.clipsToBounds = true
        imageV.layer.cornerRadius = 4
        return imageV
    }()
    
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 12)
        label.textColor = .white
        label.text = "Username"
        return label
    }()
    
    let momentLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 12)
        label.textColor = .white
        label.backgroundColor = UIColor(named: "primary-color")
        label.text = ""
        label.textAlignment = .center
        label.clipsToBounds = true
        label.layer.cornerRadius = 4
        return label
    }()
    
    var profileImage : UIImageView = {
        let imageV = UIImageView()
        let targetSize = CGSize(width: 24, height: 24)
        imageV.image = UIImage(named: "profile-placeholder")
        imageV.frame = CGRect(x: 0, y: 0, width: 24 , height: 24)  
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.circularImage()
        return imageV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initView(){
        
        addSubview(momentImage)
        momentImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        momentImage.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        momentImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        momentImage.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(momentLabel)
        momentLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        momentLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        momentLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        momentLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        addSubview(profileImage)
        profileImage.bottomAnchor.constraint(equalTo: momentImage.bottomAnchor,constant:  -10).isActive = true
        profileImage.leadingAnchor.constraint(equalTo: momentImage.leadingAnchor, constant: 6).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 24).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        profileImage.bringSubviewToFront(momentImage)
        
        addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: profileImage.topAnchor).isActive = true
        userNameLabel.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 6).isActive = true
    }
    
    
    func configureMoment(moment: MomentResponse){
        print("The moment type \(moment.type)")
        profileImage.image = moment.userAvatarImage
        userNameLabel.text = moment.userName
        if moment.type == "text"{
            momentLabel.text = moment.content
        } else{
            momentImage.image = moment.userMomentIamge
        }
    }
    
    
}
