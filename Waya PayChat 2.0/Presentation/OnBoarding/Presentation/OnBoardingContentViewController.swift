//
//  OnBoardingContentViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//


class OnBoardingContentViewController: UIViewController {
    
    var logo  =  UIImage()
    var index = 0
    var imageFile = ""
    var heading = ""
    var subHeading = ""
    
    var contentImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    var headingLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.libreText22()
        return headerLabel_
    }()
    
    var subHeadingLabel : UILabel = {
        let subheaderLabel_ = UILabel()
        subheaderLabel_.translatesAutoresizingMaskIntoConstraints = false
        subheaderLabel_.numberOfLines = 3
        subheaderLabel_.latoText16()
        subheaderLabel_.textAlignment = .center
        return subheaderLabel_
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageView.image = logo
        initView()
    }
    
    func initView(){
        view.addSubview(contentImageView)
        view.addSubview(headingLabel)
        view.addSubview(subHeadingLabel)

        setUpImageViewContraint()
       setUpHeaderViewContraint()
        setUpSubHeaderViewContraint()
    }
    
    func setUpImageViewContraint(){
        contentImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        contentImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setUpHeaderViewContraint(){
        headingLabel.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 32).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setUpSubHeaderViewContraint(){
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 12).isActive = true
        subHeadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
}
