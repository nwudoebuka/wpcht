//
//  QRViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/18/21.
//

protocol QRView : BaseView {
    
}
class QRViewController: UIViewController, QRView {

    var qRImageView = UIImageView(image: UIImage(named: "moment-placeholder"))
    var profileImageView = UIImageView(image: UIImage(named: "profile-placeholder"))
    var userFullName = ""
    
    var toolbar  : CustomToolbar = {
        let rightButton1 = UI.button(title: "", icon: UIImage(named: "drop-down-vertical"), style: .icon)
        let rightButton2 = UI.button(title: "", icon: UIImage(named: "scan-icon"), style: .icon)
        
        let toolbar = CustomToolbar(rightItems: [rightButton1, rightButton2])
        toolbar.titleLabel.text = "Scan to Pay"
//        toolbar.rightButton1.setImage(UIImage(named: "drop-down-vertical"), for: .normal)
//        toolbar.rightButton2.setImage(UIImage(named: "scan-icon"), for: .normal)
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
    
    var usernameLabel : UILabel = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        
    }
    
    var dropDownView  :  UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return view
    }()
    
    var stackView = UIStackView()

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
        
        guard let rightButton2 = toolbar.rightItems?.first as? UIButton else {
            return
        }
        rightButton2.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.frame.size = CGSize(width: 100, height: 100)
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: titleLine.bottomAnchor, constant: 35).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.circularImage()
        
        view.addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameLabel.text = "\(auth.data.profile?.firstName ?? "") \(auth.data.profile?.lastName ?? "")"
        
        
        view.addSubview(qrLabel)
        qrLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 15).isActive = true
        qrLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        qRImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qRImageView)
        qRImageView.topAnchor.constraint(equalTo: qrLabel.bottomAnchor, constant: 50).isActive = true
        qRImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        qRImageView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        qRImageView.heightAnchor.constraint(equalToConstant: view.frame.size.width - 100).isActive = true
        
        qRImageView.layer.cornerRadius = 4
        
        toolbar.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        guard let rightButton1 = toolbar.rightItems?.first as? UIButton else {
            return
        }
        rightButton1.addTarget(self, action: #selector(showDropDown), for: .touchUpInside)
        
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
//        saveImageToDevice(image: qRImageView.image , fileName: "\(String(describing: usernameLabel.text))_WayapayQRCode.png")
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
