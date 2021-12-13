//
//  EditProfileViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/27/21.
//

import UIKit

class EditProfileViewController: UIViewController, SettingsView, Alertable {
    var onBack: ((Bool) -> Void)?
    var optionSelected: ((SettingsView?) -> Void)?
    var present: ((UIViewController) -> Void)?
    let updateProfileViewmodel = ProfileViewModelImpl()
    var wayagramViewModel : WayagramViewModelImpl!
    
    var toolbar  : CustomToolbar = {
        let saveBtn = UI.button(title: "Save", style: .secondary, state: .active)
        let toolbar = CustomToolbar(rightItems: [saveBtn], leftItems: nil)
//        toolbar.rightI.isHidden = false
//        toolbar.rightButton1.setTitle("Save", for: .normal)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    var imagePicker: ImagePicker!
    var isCoverImage = false
    
    var headerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view 
    }()

    var backGroundImageView = UIImageView(image: UIImage(named: "moment-placeholder"))
    var profileImageView = UIImageView(image: UIImage(named: "profile-placeholder"))
    
    var userNameLabel : UILabel = {
       let label = UILabel() 
        label.font = UIFont(name: "Lato-Bold", size: 16) 
        label.text = "Username"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    let usernameTextField : UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Lato-Regular", size: 16)
        textField.textColor = UIColor(named: "toolbar-color-primary")
        textField.tag = 1
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "sliver-gray")?.withAlphaComponent(0.2).cgColor
        return textField
    }()
    
    var bioNameLabel : UILabel = {
        let label = UILabel() 
        label.font = UIFont(name: "Lato-Bold", size: 16) 
        label.text = "Bio"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bioTextField : TextInput = {
        let textField = UI.textField()
        textField.tag = 1
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "sliver-gray")?.withAlphaComponent(0.2).cgColor
        textField.input.textAlignment = .left
        return textField
    }()
    
    var coverImagePicker : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "camera_icon_white"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
       return button 
    }()
    
    var profileImagePicker : UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "camera_icon_white"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button 
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)

    }
    
    private func setUpViews(){
        
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        
        view.addSubview(toolbar)
        toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        toolbar.titleLabel.text = "\(UserDefaults.standard.string(forKey: "FirstName") ?? "First Name") \(UserDefaults.standard.string(forKey: "Surname") ?? "Last Name")"
        
        toolbar.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.saveInfo(_:)))
        toolbar.rightItems![0].addGestureRecognizer(tap)
        guard let rightButton1 = toolbar.rightItems?.first as? UIButton else {
            return
        }
        rightButton1.addTarget(self, action: #selector(saveInfo), for: .touchUpInside)
        
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(backGroundImageView)
        backGroundImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
        backGroundImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
        backGroundImageView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        backGroundImageView.heightAnchor.constraint(equalToConstant: 124).isActive = true
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.frame.size = CGSize(width: 80, height: 80)
        headerView.addSubview(profileImageView)
        profileImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        profileImageView.topAnchor.constraint(equalTo: backGroundImageView.topAnchor, constant: 90).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        profileImageView.circularImage()

        headerView.addSubview(profileImagePicker)
        profileImagePicker.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        profileImagePicker.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true

        headerView.addSubview(coverImagePicker)
        coverImagePicker.centerYAnchor.constraint(equalTo: backGroundImageView.centerYAnchor).isActive = true
        coverImagePicker.centerXAnchor.constraint(equalTo: backGroundImageView.centerXAnchor).isActive = true
    
        view.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        view.addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 22).isActive = true
        userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        view.addSubview(usernameTextField)
        usernameTextField.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true 
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(bioNameLabel)
        bioNameLabel.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30).isActive = true
        bioNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        
        view.addSubview(bioTextField)
        bioTextField.topAnchor.constraint(equalTo: bioNameLabel.bottomAnchor, constant: 8).isActive = true
        bioTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        bioTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true 
        bioTextField.heightAnchor.constraint(equalToConstant: 126).isActive = true
       
        
//        if let username = UserDefaults.standard.string(forKey: "Username"){
//            usernameTextField.text = username
//        }
//
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissKeyBoard))
        toolbar.setItems([doneBtn], animated: true)
        
//        bioTextField.inputAccessoryView = toolbar
        usernameTextField.inputAccessoryView = toolbar
        
        coverImagePicker.tag = 1
        profileImagePicker.tag = 2
        coverImagePicker.addTarget(self, action: #selector(didTapImageView(_:)), for: .touchUpInside)
        profileImagePicker.addTarget(self, action: #selector(didTapImageView(_:)), for: .touchUpInside)

        backGroundImageView.clipsToBounds = true
        backGroundImageView.contentMode = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func didTapBackButton(){
        dismiss(animated: false, completion: nil)
    }
    
    @objc func saveInfo(_ sender: UITapGestureRecognizer){
        print("clicked save user")
        if usernameTextField.text.isEmpty || bioTextField.text.isEmpty{
            self.showAlert(message: "Fields are Empty")
            return
        }
        LoadingView.show()
        updateProfileViewmodel.profileUpdated.subscribe(with: self) { (status, error) in
            self.showAlert(message: "Profile updated successfully")
            LoadingView.hide()
        }
        let request = [
            "user_id":auth.data.userId,
            "username":usernameTextField.text as! String
        
        ] as [String : Any]
        updateProfileViewmodel.updateUserProfile(updateProfileRequest: request)
        print("current user is \(auth.data.profile?.username)")
        //let userId = UserDefaults.standard.string(forKey: "ProfileId") ?? ""

//        let userId = String(UserDefaults.standard.integer(forKey: "UserId") )
//        if usernameTextField.input.text != nil || usernameTextField.input.text != ""{
//            let updateWayagramProfile  = UpdateWayagramProfile(avatar: profileImageView.image!, coverImage: backGroundImageView.image!, user_id: userId, username: usernameTextField.input.text, notPublic: false)
//            print("The updateWayagramProfile \(updateWayagramProfile)")
//            LoadingView.show()
//            wayagramViewModel.updateWayagramProfile(updateWayagramProfile: updateWayagramProfile) {[weak self] (result) in
//                switch result{
//                    case .success(let response):
//                        print("The update reponse of editing wayagram profile \(String(describing: response))")
//                        //UserDefaults.standard.setValue("Avatar", forKey: "")
//                        //UserDefaults.standard.setValue("CoverImage", forKey: "")
//                        UserDefaults.standard.setValue(self?.usernameTextField.input.text!, forKey: "Username")
//                       
//
//                        LoadingView.hide()
//
//                    case .failure(.custom(let message)):
//                        print("The message \(message)")
//                        LoadingView.hide()
//                        self?.showAlert(message: message)
//                }
//                
//            }
//        }
        
    }
    
    @objc private func didTapImageView(_ sender: UIButton) {
        if sender.tag == 1{
            isCoverImage = true
        } else if sender.tag == 2{
            isCoverImage = false
        }
        self.imagePicker.present(from: headerView)
    }
    
    
    @objc func dismissKeyBoard(){
        view.endEditing(true)
    }
}

extension EditProfileViewController :ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil{
            if isCoverImage{
                self.backGroundImageView.image = image!
            } else{
                self.profileImageView.image = image!
            }
        } 
        
    }
}
