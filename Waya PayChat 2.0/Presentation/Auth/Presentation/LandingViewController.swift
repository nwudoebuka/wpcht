//
//  LandingViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//

final class LandingViewController : UIViewController, LandingView{
    
    var onLoginButtonTap: (() -> Void)?
    var onRegisterButtonTap: (() -> Void)?
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "logo")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var bodyImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "landing-img")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var headingLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.libreText22()
        return headerLabel_
    }()
    
    var bodyLabel : UILabel = {
        let subheaderLabel_ = UILabel()
        subheaderLabel_.text = "Discover, Connect and Transact \n with Wayapay Chat"
        subheaderLabel_.translatesAutoresizingMaskIntoConstraints = false
        subheaderLabel_.numberOfLines = 3
        subheaderLabel_.latoText16()
        subheaderLabel_.textAlignment = .center
        return subheaderLabel_
    }()
    
    var getStartedButton : UIButton = {
        let button  = UI.button(title: "Get Started", style: .primary)
        button.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var loginButton : UIButton = {
        let button  = UI.button(title: "Login", style: .secondary)
        button.addTarget(self, action: #selector(didTapLogIn), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewConstraint()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidAppear(animated)
    }

    private func setViewConstraint(){
        view.addSubview(headerImage)
        headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerImage.heightAnchor.constraint(equalToConstant: 56).isActive = true
        headerImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        view.addSubview(bodyImage)
        bodyImage.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 24).isActive = true
        bodyImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(bodyLabel)
        bodyLabel.topAnchor.constraint(equalTo: bodyImage.bottomAnchor, constant: 24).isActive = true
        bodyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(loginButton)
        view.addSubview(getStartedButton)

        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        getStartedButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -16).isActive = true
        getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        getStartedButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        getStartedButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc func didTapLogIn(){
        onLoginButtonTap?()
    }
    
    @objc func didTapRegister(){
        onRegisterButtonTap?()
    }
    
    
}
