//
//  LoginUpdateProfileViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/10/21.
//
import UIKit
import SwiftValidator

class LoginUpdateProfileViewController: UIViewController, LoginUpdateProfileView, UITextFieldDelegate, Alertable {    
    var onCancelTapped: (() -> Void)?
    var onUpdateComplete: (() -> Void)?
    var displayMode: ProfileUpdateDisplayMode = .login
    let validator = Validator()

    var profilePictureImage = UIImage()
    
    let userDefault = UserDefaults.standard
    
    var authViewModel: AuthViewModelImpl?
    var profileViewModel = ProfileViewModelImpl()
    var wayagramViewModel = WayagramViewModelImpl()
    
    let genderPickerData = ["MALE", "FEMALE"]
    
    lazy var cancelButton: UIButton = {
        return UI.button(title: "Cancel", style: .secondary)
    }()
    
    lazy var saveButton: UIButton = {
        return UI.button(title: "Save", style: .secondary)
    }()
    
    lazy var headingLabel: UILabel = {
        return UI.text(string: "Update Profile")
    }()
    
    var profileImage : UIImageView = {
        var imageV = UIImageView()
        imageV.frame.size = CGSize(width: 80, height: 80)
        let uiImage = UIImage(named: "profile-placeholder")
        imageV.image = uiImage
        imageV.circularImage()
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    lazy var updateProfileImageButton: UIButton = {
        let btn = UI.button(title: "Upload Profile Image", style: .small)
        btn.setTitleColor(UIColor(named: "dark-gray"), for: .normal)
        btn.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        return btn
    }()
    
    lazy var accountLabel: UILabel = {
        let account = auth.data.accounts?.virtualAccount?.accountNumber ?? "XXXXXXXXX"
        return UI.text(string: "Acct Number: \(account)")
    }()
   
    
    lazy var firstNameTextField: TextInput = {
        return UI.textField(placeholder: "First Name")
    }()
    
    lazy var midNameTextField: TextInput = {
        return UI.textField(placeholder: "Middle Name")
    }()
    
    
    lazy var surnameTextField: TextInput = {
        return UI.textField(placeholder: "Surname")
    }()
    
    lazy var datePickerTextField : TextInput = {
        return UI.textField(placeholder: "Date of Birth")
    }()
    
    lazy var datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    var genderPicker = UIPickerView()
    
    lazy var genderTextField: TextInput = {
        return UI.textField(placeholder: "Gender")
    }()
    
    lazy var emailTextField: TextInput = {
        return UI.textField(placeholder: "Email")
    }()
    
    
    lazy var phoneNumberTextField : TextInput = {
        return UI.textField(placeholder: "Phone Number")
    }()
    
    lazy var districtTextField : TextInput = {
        return UI.textField(placeholder: "District/State")
    }()
    
    lazy var cityTextField: TextInput = {
        return UI.textField(placeholder: "City")
    }()
    
    lazy var addressTextField : TextInput = {
        return UI.textField(placeholder: "Address")
    }()

    let contactLabel : UILabel = {
        return UI.text(string: "Contact Details", style: .bold)
    }()
    
    lazy var contentViewSize = CGSize(width: view.frame.width, height: view.frame.height + 100)
    
    lazy var  scrollView  : UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
//        scrollView.contentSize = contentViewSize
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var containerView  : UIView = {
        let view  = UIView()
        view.backgroundColor = .white
        view.frame.size = contentViewSize
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewContraints()
        createDatePicker()    
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        setUpGenderPickerView()
        self.firstNameTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.prefill()
    }
    
    
    private func setUpViewContraints(){
        view.addSubviews([ headingLabel, saveButton, cancelButton, scrollView])
        
        scrollView.addSubview(containerView)
        containerView.addSubviews([
            profileImage, updateProfileImageButton, accountLabel,
            firstNameTextField, midNameTextField, surnameTextField,
            datePickerTextField, genderTextField, contactLabel,
            emailTextField, phoneNumberTextField, districtTextField,
            cityTextField, addressTextField,
        ])
        
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 21),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headingLabel.heightAnchor.constraint(equalToConstant: 22),
            
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.centerYAnchor.constraint(equalTo: headingLabel.centerYAnchor),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            
            scrollView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 20),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: view.frame.size.height + 250),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            
            profileImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            profileImage.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 80),
            profileImage.widthAnchor.constraint(equalToConstant: 80),
            
            updateProfileImageButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 16),
            updateProfileImageButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            updateProfileImageButton.heightAnchor.constraint(equalToConstant: 24),
            
            accountLabel.topAnchor.constraint(equalTo: updateProfileImageButton.bottomAnchor, constant: 16),
            accountLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            firstNameTextField.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 27),
            firstNameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            firstNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            midNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 27),
            midNameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            midNameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            midNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            surnameTextField.topAnchor.constraint(equalTo: midNameTextField.bottomAnchor, constant: 27),
            surnameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            surnameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            surnameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            datePickerTextField.topAnchor.constraint(equalTo: surnameTextField.bottomAnchor, constant: 27),
            datePickerTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            datePickerTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            datePickerTextField.heightAnchor.constraint(equalToConstant: 40),
            
            genderTextField.topAnchor.constraint(equalTo: datePickerTextField.bottomAnchor, constant: 27),
            genderTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            genderTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            genderTextField.heightAnchor.constraint(equalToConstant: 40),
            
            contactLabel.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant: 27),
            contactLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            
            emailTextField.topAnchor.constraint(equalTo: contactLabel.bottomAnchor, constant: 27),
            emailTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            emailTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),
            
            phoneNumberTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 27),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40),
            
            districtTextField.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 27),
            districtTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            districtTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            districtTextField.heightAnchor.constraint(equalToConstant: 40),
            
            cityTextField.topAnchor.constraint(equalTo: districtTextField.bottomAnchor, constant: 27),
            cityTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            cityTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            cityTextField.heightAnchor.constraint(equalToConstant: 40),
            
            addressTextField.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 27),
            addressTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -30),
            addressTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 30),
            addressTextField.heightAnchor.constraint(equalToConstant: 40)
        ])

        firstNameTextField.input.delegate = self
        emailTextField.input.delegate = self
        districtTextField.input.delegate = self
        addressTextField.input.delegate = self
        phoneNumberTextField.input.delegate = self
        genderTextField.input.delegate = self
        midNameTextField.input.delegate = self
        surnameTextField.input.delegate = self
        addValidation()
        
        updateProfileImageButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
        
        profileImage.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        profileImage.addGestureRecognizer(tapGestureRecognizer)
        saveButton.addTarget(self, action: #selector(validateAndContinue), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        self.addSubscriptions()
        
        profileViewModel.profileUpdated.subscribe(with: self) { (status, error) in
            self.prefill()
        }
        LoadingView.show()
        profileViewModel.getUserProfileById(userId: String(auth.data.userId!)) { (_) in
        LoadingView.hide()
            auth.updateLocalPrefs()
        }
    }
    
    func addValidation() {
        validator.registerField(firstNameTextField, errorLabel: firstNameTextField.errorLabel, rules: [RequiredRule()])
        validator.registerField(emailTextField, errorLabel: emailTextField.errorLabel, rules: [RequiredRule(), EmailRule()])
        validator.registerField(districtTextField, errorLabel: districtTextField.errorLabel, rules: [RequiredRule()])
        validator.registerField(cityTextField, errorLabel: cityTextField.errorLabel, rules: [RequiredRule()])
        validator.registerField(addressTextField, errorLabel: addressTextField.errorLabel, rules: [RequiredRule()])
        validator.registerField(phoneNumberTextField, errorLabel: phoneNumberTextField.errorLabel, rules: [RequiredRule()])
        validator.registerField(genderTextField, errorLabel: genderTextField.errorLabel, rules: [RequiredRule()])
        validator.registerField(surnameTextField, errorLabel: surnameTextField.errorLabel, rules: [RequiredRule()])
    }
    
    private func prefill() {
        firstNameTextField.input.text = auth.data.profile?.firstName
        emailTextField.input.text = auth.data.profile?.email
        genderTextField.input.text = auth.data.profile?.gender?.uppercased()
        districtTextField.input.text = auth.data.profile?.state
        addressTextField.input.text = auth.data.profile?.address
        genderTextField.input.text = auth.data.profile?.gender
        phoneNumberTextField.input.text = auth.data.profile?.phoneNumber
        midNameTextField.input.text = auth.data.profile?.middleName
        surnameTextField.input.text = auth.data.profile?.lastName
    }
    
    private func addSubscriptions() {
        profileViewModel.profileUpdated.subscribe(with: self, callback: { (status, error) in
            LoadingView.hide()
            if status == true {
                DispatchQueue.main.async{
                    guard let profile = auth.data.profile, profile.isCompleted == true else {
                        self.prefill()
                        return
                    }
                    self.onUpdateComplete?()
                }
            } else {
                self.showAlert(message: error!)
            }

        }).onQueue(.main)
    }
    
    @objc private func didTapImageView(_ sender: UITapGestureRecognizer) {
        self.imagePicker.present(from: profileImage)
    }
    
    @objc func validateAndContinue() {
        validator.validate(self)
    }
    
    @objc func didTapCancel(){
        self.onCancelTapped?()
    }
    
    @objc func dismissDatePicker(){
        changeDateText()
        view.endEditing(true)
    }
     
    func createDatePicker (){
        datePicker.center = view.center
        datePicker.addTarget(self, action: #selector(changeDateText), for: .valueChanged)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissDatePicker))
        toolbar.setItems([doneBtn], animated: true)
        
        datePickerTextField.input.inputAccessoryView = toolbar
        datePickerTextField.input.inputView = datePicker
        datePicker.addTarget(self, action: #selector(changeDateText), for: .valueChanged)

    }

    @objc func  changeDateText(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePickerTextField.input.text = dateFormatter.string(from: datePicker.date)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func showImagePicker(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
   private  func uploadImage(){
        
        if let image = profilePictureImage.jpegData(compressionQuality: 0.3) {
            LoadingView.show()
            let repo = ProfileRepositoryImpl()
            
            repo.uploadProfileImage(data: image) { (result) in
                LoadingView.hide()
                switch result{
                    case .success(let result):
                        self.showAlert(message: "Image uploaded successfully")
                        self.profileImage.image = self.profilePictureImage
                        self.saveImageToLocal()
                    case .failure(.custom(let message)) :
                        print("failed to upload: \(message)")
                        self.showAlert(message: "An error ocuured, please try again")
                }
            }
        }
    }
    
    private func saveImageToLocal(){
    
        if let data = profilePictureImage.pngData() {
            // Create URL
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documents.appendingPathComponent("profileImageLocal.png")
            
            do {
                // Write to Disk
                try data.write(to: url)
                
                // Store URL in user Profile
                auth.data.profile?.profileImageLocal = url.absoluteString
                
            } catch {
                print("Unable to Write Data to Disk (\(error))")
            }
        }
    }
    
    func updateUserProfile(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
//
        let dateString = formatter.string(from: datePicker.date)
        let request: [String: Any]
        if auth.data.profile!.accountType == .personal {
            request = [
                "address": addressTextField.text,
                "dateOfBirth": dateString,
                "district": districtTextField.text,
                "email": auth.data.profile!.email,
                "firstName": firstNameTextField.text,
                "gender": genderTextField.text,
                "middleName": midNameTextField.text,
                "phoneNumber": auth.data.profile!.phoneNumber,
                "surname": surnameTextField.text
            ]
        } else {
            request = [
                "address": addressTextField.text,
                "businessType": auth.data.profile!.otherDetails!.businessType,
                "city": cityTextField.text,
                "dateOfBirth": dateString,
                "district": districtTextField.text,
                "email": emailTextField.text,
                "firstName": firstNameTextField.text,
                "gender": genderTextField.text,
                "middleName": midNameTextField.text,
                "officeAddress": addressTextField.text,
                "organisationEmail": emailTextField.text,
                "organisationName": auth.data.profile!.otherDetails!.organisationName,
                "organisationType": auth.data.profile!.otherDetails!.organisationType,
                "phoneNumber": phoneNumberTextField.text,
                "state": districtTextField.input.text!,
                "surname": surnameTextField.input.text!
            ]
        }
        LoadingView.show()
        profileViewModel.updateUserProfile(updateProfileRequest: request)
    }
}


extension LoginUpdateProfileViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if image != nil{
            self.profilePictureImage = image!
            uploadImage()
        }
    }
}

extension LoginUpdateProfileViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  genderPickerData.count

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.input.text = genderPickerData[row]
        genderTextField.resignFirstResponder()
    }
    
    func setUpGenderPickerView(){
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTextField.input.inputView = genderPicker 
    }
}

extension LoginUpdateProfileViewController: ValidationDelegate {
    func validationSuccessful() {
        updateUserProfile()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        var first_focused = false
        for (field, error) in errors {
            guard let field = field as? TextInput else {
                self.showAlert(message: error.errorMessage)
                return
            }
            if first_focused == false {
                field.becomeFirstResponder()
                first_focused = true
            }
            field.errorLabel.isHidden = false
            field.errorLabel.text = error.errorMessage
            if (first_focused == true)  { field.becomeFirstResponder() }
            first_focused = true
        }
        self.showAlert(message: "Incorrect details provided")
    }
}
