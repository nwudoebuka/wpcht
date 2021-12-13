//
//  ForgotPasswordViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/6/21.
//

protocol ForgotPasswordView : BaseView{
    var onBackButtonTap : (() -> Void)? {get set}
    var goToResetPassword: ((_ otp: String) -> Void)?{ get set}
}


class ForgotPasswordViewController: UIViewController, ForgotPasswordView {    
    var onBackButtonTap: (() -> Void)?
    var goToResetPassword: ((_ otp: String) -> Void)?
    
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "forgot-password-icon")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    var viewType = 0
    
    //to do inject viewmodel all round 
    var authViewModel = AuthViewModelImpl()
    var otpPin = ""
    
    var headerText  : UILabel!
    var subHeaderText : UILabel!
    var customTextField:  TextInput!
    
    var  nextButton : UIButton = {
        let button = UI.button(title: "Next")
        return button
    }()

    var toolbar  : CustomToolbar = {
        let toolbar = CustomToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.titleLabel.text = ""
        return toolbar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func setUpViews(){
        customTextField =  UI.textField()
        headerText = libreTextBold22(text: "Forgot Password")
        headerText.textAlignment = .center
        subHeaderText = latoGrayText16(text: "Please enter your details, we will send you \n a verification code to reset your password")
        
        view.addSubview(toolbar)
        toolbar.backgroundColor = .white
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        toolbar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        view.addSubview(headerImage)
        headerImage.anchor(top: toolbar.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 51, left: 0, bottom: 0, right: 0))
        headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerImage.sizeAnchor(height: nil, width: nil, heightConstant: 160, widthConstant: 160)
        
        view.addSubview(headerText)
        headerText.anchor(top: headerImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0))
        headerText.centerInSuperview()
        
        view.addSubview(subHeaderText)
        subHeaderText.anchor(top: headerText.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 32, bottom: 0, right: 32))
        
        view.addSubview(customTextField)
        customTextField.input.placeholder = "Email"
        customTextField.anchor(top: subHeaderText.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 12, left: 32, bottom: 0, right: 32))
        customTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(nextButton)
        nextButton.anchor(top: customTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 48, left: 32, bottom: 0, right: 32))
        nextButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        toolbar.backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        customTextField.input.keyboardType = .alphabet

    }
    
    @objc func dismissView(){
        onBackButtonTap?()
    }
    
    @objc func didTapNextButton(){
        if viewType == 0{
            getForgotPassword()
        } else {
            otpPin = customTextField.input.text ?? ""
            goToResetPassword?(otpPin)
        }
    }
    
    private func getForgotPassword(){
//        LoadingView.show()
//        authViewModel.forgotPasswordRequest = customTextField.input.text ?? ""
//        authViewModel.getForgotPassword(email: authViewModel.forgotPasswordRequest) {
//            [weak self](result) in
//            switch result{
//                case .success(let response):
//                    print("The response is \(response)")
//                    LoadingView.hide()
//                    self?.authViewModel.changeForgotPasswordRequest.email = (self?.authViewModel.forgotPasswordRequest)!
//                    auth.data.profile?.email = (self?.authViewModel.changeForgotPasswordRequest.email)!
////                    UserDefaults.standard.setValue(, forKey: "Email")
//                    self?.resetViewToEnterOtpCode()
//                    self?.viewType = 1
//                case .failure(.custom(let message)):
//                    print("message \(message)")
//                    LoadingView.hide()
//            }
//        }
    }
    

    
    private func resetViewToEnterOtpCode(){
        headerText.text = "Enter OTP Code"
        subHeaderText.text = "We have sent a verification code for you \n to reset your password"
        customTextField.input.text  = ""
        customTextField.input.placeholder = "Enter OTP Code"
        customTextField.input.keyboardType = .numberPad
    }

}
