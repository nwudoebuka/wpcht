//
//  InviteCodeViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/18/21.
//

import UIKit

class InviteCodeViewController: UIViewController {

    var qRImageView = UIImageView(image: UIImage(named: "moment-placeholder"))
    
    var toolbar  : CustomToolbar = {
        let right1 = UI.button(title: "", icon: UIImage(named: "drop-down-vertical"), style: .icon)
        let right2 = UI.button(title: "", icon: UIImage(named: "scan-icon"), style: .icon)
        
        let toolbar = CustomToolbar(rightItems: [right1, right2], leftItems: nil)
//        toolbar.backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
        toolbar.titleLabel.text = "Invite a Friend"
//        toolbar.rightButton1.setImage(, for: .normal)
//        toolbar.rightButton2.setImage(, for: .normal)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    var selectBankDropDownButton : UIButton = {
        let button  = UIButton()
        button.setTitle("Select Bank", for: .normal)
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceRightToLeft       
        button.backgroundColor = .clear
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left;
        button.setImage(UIImage(named: "drop-down-arrow"), for: .normal)
        return button
    }()
    
    let titleLine : UIView = {
        let line = UIView()
        line.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.3)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 24)
        label.textColor = UIColor(named: "color-accent")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var qrLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textColor = UIColor(named: "dark-gray")
        label.text = "Waya QR Code"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let  downloadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let shareButton : UIButton = {
        let button = UIButton()
        button.setTitle("Share", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    var dropDownView  :  UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return view
    }()
    
    var usernameFullName = ""
    
    var stackView = UIStackView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
    }
    
    
    func setUpView() {
        
        view.addSubview(toolbar)
        toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(titleLine)
        titleLine.topAnchor.constraint(equalTo: toolbar.bottomAnchor).isActive = true
        titleLine.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        titleLine.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        titleLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        titleLine.layer.shadowColor = UIColor.black.cgColor
        titleLine.layer.shadowOpacity = 1
        titleLine.layer.shadowOffset = .zero
        titleLine.layer.shadowRadius = 10  
        
        guard let right2 = toolbar.rightItems!.last as? UIButton else {
            return
        }
        right2.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        
        view.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 15).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // usernameLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        titleLabel.text = "Invite a Friend "
        
        view.addSubview(qrLabel)
        qrLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15).isActive = true
        qrLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //qrLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        qRImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qRImageView)
        qRImageView.topAnchor.constraint(equalTo: qrLabel.bottomAnchor, constant: 50).isActive = true
        qRImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qRImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        qRImageView.heightAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        
        qRImageView.layer.cornerRadius = 4
        
        guard let right1 = toolbar.rightItems?.first as? UIButton else {
            return
        }
        
        toolbar.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside) // this could be a signal subscription
        right1.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        
        view.addSubview(dropDownView)
        dropDownView.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -10).isActive = true
        dropDownView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        dropDownView.widthAnchor.constraint(equalToConstant: 260).isActive = true
        dropDownView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(downloadButton)
        stackView.addArrangedSubview(shareButton)
        stackView.addArrangedSubview(cancelButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: dropDownView.centerYAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: dropDownView.leadingAnchor, constant: 28).isActive = true
        
        downloadButton.addTarget(self, action: #selector(downloadQRCode), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareQRCode), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(hideDropDown), for: .touchUpInside)
        
        dropDownView.isHidden = true
        usernameFullName = "\(UserDefaults.standard.string(forKey: "FirstName") ?? "") \(UserDefaults.standard.string(forKey: "Surname") ?? "")"
    }
    
    @objc func showDropDown(){
        dropDownView.isHidden = false   
    }
    
    @objc func didTapBackButton(){
        dismiss(animated: false, completion: nil)
    }
    
    @objc func hideDropDown(){
        dropDownView.isHidden = true
    }
    
    @objc func downloadQRCode(){
        //saveImageToAppMemory(image: qRImageView.image , fileName: "\(usernameFullName)_WayapayQRCode.png")
        hideDropDown()
        guard let image = qRImageView.image else { return }
        writeToPhotoAlbum(image: image)

    }
    
    @objc func shareQRCode(){
        hideDropDown()
        let items = [qRImageView.image]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        present(ac, animated: true)
    }
    

}
