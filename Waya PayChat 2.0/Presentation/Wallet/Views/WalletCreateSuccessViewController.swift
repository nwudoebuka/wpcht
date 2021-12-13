//
//  WalletCreateSuccessViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/12/21.
//

import UIKit

class SuccessViewController: UIViewController {
    
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "lock2")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var bodyLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Keep your account safe with a 4 digit pin"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textColor = UIColor(named: "color-gray1")
        headerLabel_.textAlignment = .center
        headerLabel_.numberOfLines = 5
        headerLabel_.font = UIFont(name: "Lato-Regular", size: 16)
        return headerLabel_
    }()
    
    var headerText : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Wallet Creation \n  Successful"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textAlignment = .center
        headerLabel_.textColor = UIColor(named: "toolbar-color-secondary")
        headerLabel_.font = UIFont(name: "LibreBaskerville-Regular", size: 22)
        return headerLabel_
    }()
    
    let continueButton : UIButton = {
        let button = UIButton()
        button.customPrimaryButton()
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(headerImage)
        headerImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(headerText)
        headerText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerText.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 48).isActive = true
        
        view.addSubview(bodyLabel)
        bodyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 12).isActive = true
        
        view.addSubview(continueButton)
        continueButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 48).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    

}
