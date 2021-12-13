//
//  VerifyPinViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/9/21.
//

import CoreLocation
import UIKit

class VerifyPinViewController: UIViewController , VerifyPinView, OTPDelegate, Alertable, CLLocationManagerDelegate{
    
    var onPinSuccessful: ((String?) -> Void)?
    var forgotPin : ((() -> Void))? 
    var firstAppear = true
    
    let authViewModel = AuthViewModelImpl()
    var locationManager: CLLocationManager?
    let locale = Locale.current
    var ipAddress = ""
    var device = ""
    var loginHistoryRequest : LoginRequestHistory!
    
    //geoCoder
    let geoCoder = CLGeocoder()
    var placeMark : CLPlacemark?
    
    var headerText : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Welcome back"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textAlignment = .center
        headerLabel_.textColor = UIColor(named: "toolbar-color-secondary")
        headerLabel_.font = UIFont(name: "LibreBaskerville-Regular", size: 22)
        return headerLabel_
    }()

    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "profile-placeholder")
        imageV.image = uiImage
        imageV.frame.size = CGSize(width: 160, height: 160)
        imageV.translatesAutoresizingMaskIntoConstraints = false
        imageV.circularImage()
        return imageV
    }()
    
    
    var bodyLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Enter your secure PIN"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textColor = UIColor(named: "color-gray1")
        headerLabel_.textAlignment = .center
        headerLabel_.numberOfLines = 5
        headerLabel_.font = UIFont(name: "Lato-Regular", size: 16)
        return headerLabel_
    }()
    
    
    var otpStackView : PinStackView = {
        var otpStack = PinStackView(frame: .zero, fields: 4)
        otpStack.translatesAutoresizingMaskIntoConstraints = false
        return otpStack
    }()
    
    let otpContainerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view 
    }()
    
    lazy var continueButton : UIButton = {
        let button = UI.button(title: "Sign in")
        return button
    }()
    
    var forgotPasswordButton : UIButton = {
        let button  = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Forgot PIN?", for: .normal)
        button.setTitleColor(UIColor(named: "color-primary"), for: .normal)
        button.backgroundColor = .none
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 14)
        button.isEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpViewContraints()
        gestureHandler()
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print("The uuid is \(uuid)")
        }
        
        ipAddress = getUserIPAddress()
        device = UIDevice.modelName
        
        print("the ipAddress   \(ipAddress) and \(device)")
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        // Get the current location permissions
        let status = CLLocationManager.authorizationStatus()
        
        // Handle each case of location permissions
        switch status {
            case .authorizedAlways:
            // Handle case
                break
            case .authorizedWhenInUse:
            // Handle case
//                geoCoder.reverseGeocodeLocation((locationManager?.location)!) { [weak self](placeMarks, error) in
//                    if error == nil, let placeMarks = placeMarks, !placeMarks.isEmpty{
//                        self?.placeMark = placeMarks.last
//                        if self?.placeMark != nil{
//                            self?.getAddress(from: (self?.placeMark)!)
//                        }
//                    }
//                }
                break
            
            case .denied:
            // Handle case
                locationManager?.requestWhenInUseAuthorization()
                break
            case .notDetermined:
            // Handle case
                locationManager?.requestWhenInUseAuthorization()
                break
            case .restricted:
            // Handle case, show prompt to take user to settings
                break
            @unknown default:
                break
        }
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways  || status == .authorizedWhenInUse{
            
            guard let location =  manager.location else { return  }
            geoCoder.reverseGeocodeLocation(location) { [weak self](placeMarks, error) in
                if error == nil, let placeMarks = placeMarks, !placeMarks.isEmpty{
                    self?.placeMark = placeMarks.last
                    if self?.placeMark != nil{
                        self?.getAddress(from: (self?.placeMark)!)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        geoCoder.reverseGeocodeLocation(location) { [weak self](placeMarks, error) in
            if error == nil, let placeMarks = placeMarks, !placeMarks.isEmpty{
                self?.placeMark = placeMarks.last
                if self?.placeMark != nil{
                    self?.getAddress(from: (self?.placeMark)!)
                }
            }
        }
    }
    
    func getAddress(from placeMark : CLPlacemark){
        let city = placeMark.locality ?? placeMark.thoroughfare ?? placeMark.subThoroughfare ??  "" 
        let province = placeMark.administrativeArea ?? ""
        let country = placeMark.country ?? ""
        let userId = String(auth.data.userId!)
        loginHistoryRequest = LoginRequestHistory(city: city, country: country, device: device, id: 0, ip: ipAddress, province: province, userId: userId)
        print("The login History is \(loginHistoryRequest)")
    }
    
    private func setUpViewContraints(){
        let firstName = auth.data.profile?.firstName ?? ""
        view.addSubview(headerText)
        headerText.text = "Welcome Back \(firstName)"
        headerText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        headerText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(headerImage)
        headerImage.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 60).isActive = true
        headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true 
        headerImage.heightAnchor.constraint(equalToConstant: 160).isActive = true
        headerImage.widthAnchor.constraint(equalToConstant: 160).isActive = true
 
        
        view.addSubview(bodyLabel)
        bodyLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 24).isActive = true
        bodyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        view.addSubview(otpStackView)
        otpStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        otpStackView.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 32).isActive = true
        
        view.addSubview(continueButton)
        continueButton.topAnchor.constraint(equalTo: otpStackView.bottomAnchor, constant: 62).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        continueButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
    
        view.addSubview(forgotPasswordButton)
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 40).isActive = true
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPin), for: .touchUpInside)
        forgotPasswordButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        
    }
    
    private func gestureHandler(){
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPin), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)

    }
    
    @objc func didTapForgotPin(){
        self.showForgotView()
    }

    func didChangeValidity(isValid: Bool) {}
    
    @objc func didTapSignIn(){
        let otp = otpStackView.getOTP()
        if otp != "" {
            LoadingView.show()
            authViewModel.pinVerified.subscribe(with: self) { [weak self] (verified, error) in
                LoadingView.hide()
                if verified == true {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    let last_login = dateFormatter.string(from: Date())
                    auth.data.last_active = last_login
                    auth.data.loggedIn = true
                    auth.toggleLock(status: .walletUnlocked)
                    self?.onPinSuccessful?(otp)
                } else {
                    DispatchQueue.main.async {
                        self?.showAlert(title: "Pin Failed", message: error!)
                    }
                }
            }
            authViewModel.validateUserPin(pin: otp)
        } else {
            showAlert(title: "Error!", message: "Please enter a valid PIN")
        }
    }
    
    func saveUserLoginHistory(loginHistoryRequest: LoginRequestHistory){
        authViewModel.saveLogInHistory(loginHistoryRequest: loginHistoryRequest) {[weak self] (result) in
            switch result{
                case .success(let response):
                    print("response\(String(describing: response))")
                    self?.onPinSuccessful?(nil)
                case .failure(.custom( _)):
                    break
//                    self?.onPinSuccessful?()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        if(firstAppear){
            view.endEditing(true)
            firstAppear = false
        }
    }
    
    func showForgotView() {
        let forgotView: ForgotView = ForgotDetailView(true) //ForgotDetailView(frame: UIScreen.main.bounds)
        forgotView.mode = .pin(true)
        forgotView.onBack = {
            forgotView.removeFromSuperview()
        }
        
        forgotView.onError = { [weak self] (error) in
            self?.showAlert(message: error)
        }
        
        forgotView.onContinue?.subscribe(with: self, callback: { [weak self] (channel, emailOrPhone) in
            DispatchQueue.main.async {
                forgotView.removeFromSuperview()
                self?.resetPin(pin: "", channel: channel)
            }
        })
        
        self.view.addSubview(forgotView)
        self.view.bringSubviewToFront(forgotView)
        forgotView.isUserInteractionEnabled = true
    }
    
    func resetPin(pin: String, channel: ForgotOTPChannel) {
        let view = CreatePinViewController()
        view.otpChannel = channel
        view.mode = .reset
        view.oldPin = pin
        view.pinSetSuccess = { (first_login) in
            auth.logout()
            DispatchQueue.main.async {
                view.dismiss(animated: true) {
                    self.dismiss(animated: true, completion: nil)
                    self.forgotPin?()
                }
            }
        }
//        view.
        self.present(view, animated: true, completion: nil)
    }
}
