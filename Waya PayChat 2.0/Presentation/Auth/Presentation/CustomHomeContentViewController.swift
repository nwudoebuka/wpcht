//
//  CustomHomePageViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/5/21.
//

import UIKit

class CustomHomeContentViewController: UIViewController {
    
    var logo  =  UIImage()
    //Mark Properties
    var index = 0
    var imageFile = ""
    var heading = ""
    var subHeading = ""
    
    var titleLabel : UILabel = {
        let subheaderLabel_ = UILabel()
        subheaderLabel_.translatesAutoresizingMaskIntoConstraints = false
        subheaderLabel_.text = "Customize your homepage"
        subheaderLabel_.font = UIFont(name: "LibreBaskerville-Regular", size: 16)
        subheaderLabel_.textColor = UIColor(named: "toolbar-color-secondary")
        subheaderLabel_.textAlignment = .center
        return subheaderLabel_
    }()
    
    var contentImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    var headingLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.latoText16()
        headerLabel_.textColor = UIColor(named: "color-accent")
        return headerLabel_
    }()
    
    var subHeadingLabel : UILabel = {
        let subheaderLabel_ = UILabel()
        subheaderLabel_.translatesAutoresizingMaskIntoConstraints = false
        subheaderLabel_.numberOfLines = 3
        subheaderLabel_.latoText16()
        subheaderLabel_.textColor = UIColor(named: "color-gray1")
        subheaderLabel_.textAlignment = .center
        return subheaderLabel_
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        
    }
    

    func initView(){
        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageView.image = logo
        
        view.addSubview(titleLabel)
        view.addSubview(contentImageView)
        view.addSubview(headingLabel)
        view.addSubview(subHeadingLabel)
        
        setUpViewContraint()
    }
    
    func setUpViewContraint(){
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        contentImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60).isActive = true
        contentImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        headingLabel.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 21).isActive = true
        headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        subHeadingLabel.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 12).isActive = true
        subHeadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    

}
