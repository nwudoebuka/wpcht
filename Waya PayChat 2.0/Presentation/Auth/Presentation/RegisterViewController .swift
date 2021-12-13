//
//  RegisterViewController .swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//
import SafariServices
import SwiftValidator

final class RegisterViewController: UIViewController, RegisterView, SFSafariViewControllerDelegate, Alertable {
    
    var authViewModel = AuthViewModelImpl()
    var onNextButtonTap: ((AuthViewModelImpl) -> Void)?
    var onBackButtonPressed : (() -> Void )?
    
    var privacyPolicyLink = "https://www.wayapaychat.com/privacy-page"
    var termsAndConditionLink = "https://www.wayapaychat.com/terms-of-use"

    let accountTypes = ["Corporate account", "Personal account"]    
    lazy var backButton : UIButton = {
        let button = UI.button(title: nil, icon: UIImage(named: "back-arrow"), style: .icon)
        return button
    }()

    lazy var personalAccountView : PersonalAccountView = {
       let view = PersonalAccountView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var coorporateAccountView : CooporateAccountView = {
        let view = CooporateAccountView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ownerDetailsView: CorporateAccountDetailsView = {
        let view = CorporateAccountDetailsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var headingLabel : UILabel = {
        let headerLabel_ = UILabel()
        headerLabel_.text = "Register"
        headerLabel_.translatesAutoresizingMaskIntoConstraints = false
        headerLabel_.textColor = UIColor(named: "toolbar-color-secondary")
        headerLabel_.font = UIFont(name: "LibreBaskerville-Regular", size: 18)
        return headerLabel_
    }()
    
    lazy var accountTypeSegmentedControl : UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: accountTypes)
        segmentedControl.layer.cornerRadius = 9
        segmentedControl.layer.masksToBounds = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = Colors.darkerBlue
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(handleSegmentControl), for: .valueChanged)
        segmentedControl.superview?.backgroundColor = Colors.lighterBlue
        
        return segmentedControl
    }()
    
    var headerImage : UIImageView = {
        var imageV = UIImageView()
        let uiImage = UIImage(named: "logo")
        imageV.image = uiImage
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    let scrollView: UIScrollView = {
        let v = UIScrollView()
        if v.contentOffset.x != 0 {
            v.contentOffset.x = 0
        }
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var termsLabel : UILabel = {
        let label = UILabel()
        let regularAttr :  [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 12) ?? UIFont(),
         NSAttributedString.Key.foregroundColor:   UIColor(named: "toolbar-color-primary") ?? UIColor.orange,
        ]
        let linkAttributes :  [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 12) ?? UIFont(),
            NSAttributedString.Key.foregroundColor:   UIColor(named: "color-primary") ?? UIColor.orange,
            NSAttributedString.Key.underlineStyle: 1
        ]
        let attrText = NSMutableAttributedString(string: "By signing up, you agree with the terms and conditions")
        attrText.addAttributes(linkAttributes, range: NSRange(location: 34, length: 20))
        attrText.addAttributes(regularAttr, range: NSRange(location: 0, length: 33))
        label.attributedText = attrText
        
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var policyLabel : UILabel = {
        let label = UILabel()
        let regularAttr :  [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 12) ?? UIFont(),
         NSAttributedString.Key.foregroundColor:   UIColor(named: "toolbar-color-primary") ?? UIColor.orange,
        ]
        let linkAttributes :  [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 12) ?? UIFont(),

         NSAttributedString.Key.foregroundColor:   UIColor(named: "color-primary") ?? UIColor.orange,
         NSAttributedString.Key.underlineStyle: 1
        ]
        let attrText = NSMutableAttributedString(string: "and privacy policy")
        attrText.addAttributes(linkAttributes, range: NSRange(location: 4, length: 14))
        attrText.addAttributes(regularAttr, range: NSRange(location: 0, length: 3))
        label.attributedText = attrText
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3        
        label.textAlignment = .center
        return label
    }()
    
    lazy var nextButton : UIButton = {
        let button  = UI.button(title: "Next", state: .inactive)
        return button
    }()
    
    var privacyPolicyView : UIView = {
        let view = UIView()
        return view
    }()
    
    var selected: AccountType = .corporate
    var showingDetailForm: Bool = false
    var loading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewConstraint()
        hideKeyboardWhenTappedAround()
        gestureHandler()
        //hidesBottomBarWhenPushed = true
        
        observePersonalAccountTextFields()
        observeCoorporateAccountTextFields()
        observeOwnerDetailsTextFields()
        loadBusinessTypes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    private func setViewConstraint(){
        view.addSubviews([
            headerImage, backButton, headingLabel, accountTypeSegmentedControl,
            policyLabel, termsLabel, nextButton, scrollView,
        ])
        
        NSLayoutConstraint.activate([
            headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            headerImage.heightAnchor.constraint(equalToConstant: 36),
            headerImage.widthAnchor.constraint(equalToConstant: 86),
            
            backButton.centerYAnchor.constraint(equalTo: headerImage.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            
            headingLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: 28),
            headingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            accountTypeSegmentedControl.widthAnchor.constraint(equalToConstant: view.frame.width - 60),
            accountTypeSegmentedControl.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 24),
            accountTypeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            accountTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            policyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            policyLabel.heightAnchor.constraint(equalToConstant: 28),
            policyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            termsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            termsLabel.heightAnchor.constraint(equalToConstant: 28),
            termsLabel.bottomAnchor.constraint(equalTo: policyLabel.topAnchor),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
            nextButton.widthAnchor.constraint(equalToConstant: view.frame.width - 60 ),
            nextButton.bottomAnchor.constraint(equalTo: termsLabel.topAnchor, constant: -24),
            
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.topAnchor.constraint(equalTo: accountTypeSegmentedControl.topAnchor, constant: 30),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16),
        ])
        
        // add personalAccountView to the scroll view
        scrollView.addSubviews([personalAccountView, coorporateAccountView, ownerDetailsView])
        
        NSLayoutConstraint.activate([
            personalAccountView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            personalAccountView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            personalAccountView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            personalAccountView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 50),
            personalAccountView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            coorporateAccountView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            coorporateAccountView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            coorporateAccountView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            coorporateAccountView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 50),
            coorporateAccountView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            ownerDetailsView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            ownerDetailsView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            ownerDetailsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            ownerDetailsView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, constant: 50),
            ownerDetailsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        ])
        showCorporateAccount()
        nextButton.isEnabled = false
        prefill()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func gestureHandler(){
        termsLabel.isUserInteractionEnabled = true
        termsLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTermsAndConditon(gesture:))))

        policyLabel.isUserInteractionEnabled = true
        policyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPrivacyPolicy(gesture:))))
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private func submit() {
        var request: CreateAccountRequest!
        
        switch selected {
        case .personal:
            let phone = personalAccountView.phoneNumberTextField.input.text!.formatPhoneNumber()
            let form_data = PersonalSignup(
                email: personalAccountView.emailTextField.input.text!,
                firstName: personalAccountView.firstNameTextField.input.text!,
                password: "",
                phoneNumber: phone,
                referenceCode: "",
                surname: personalAccountView.surnameTextField.input.text!
            )
            request = CreateAccountRequest(type: .personal, data: form_data.dictionary!)
        case .corporate:
            let orgPhone = coorporateAccountView.orgPhoneNumber.input.text!.formatPhoneNumber()
            let form_data = CorporateSignup(
                businessType: coorporateAccountView.businessTypeTextField.input.text!,
                email: coorporateAccountView.orgEmailAddress.input.text!,
                firstName: ownerDetailsView.firstNameTextField.input.text!,
                officeAddress: ownerDetailsView.officeAddressTextField.input.text!,
                orgEmail: coorporateAccountView.orgEmailAddress.input.text!,
                orgName: coorporateAccountView.organizationNameTextField.input.text!,
                orgPhone: orgPhone,
                orgType: coorporateAccountView.organizationTypeTextField.input.text!,
                password: "",
                phoneNumber: orgPhone,
                referenceCode: coorporateAccountView.aggregatorCode.input.text ?? "",
                city: ownerDetailsView.cityTextField.input.text!,
                state: ownerDetailsView.stateTextField.input.text!,
                surname: ownerDetailsView.surnameTextField.input.text!
            )
            request = CreateAccountRequest(type: .corporate, data: form_data.dictionary!)
        }
        authViewModel.createAccountRequest = request
        onNextButtonTap?(authViewModel)
    }
    
    // prefill the form if you are being redirected from login/register
    private func prefill() {
        if let req = self.authViewModel.createAccountRequest {
            switch req.type {
            case .corporate:
                guard let data = req.data as? CorporateSignup  else {
                    return
                }
                coorporateAccountView.organizationNameTextField.input.text = data.orgName
                coorporateAccountView.orgEmailAddress.input.text = data.orgEmail
                coorporateAccountView.businessTypeTextField.input.text = data.orgType
                coorporateAccountView.organizationNameTextField.input.text = data.orgName
            case .personal:
                guard let data = req.data as? PersonalSignup else {
                    return
                }
                personalAccountView.firstNameTextField.input.text = data.firstName
                personalAccountView.emailTextField.input.text = data.email
                personalAccountView.surnameTextField.input.text = data.surname
                personalAccountView.phoneNumberTextField.input.text = data.phoneNumber
            }
        }
    }
    
    private func showPersonalAccount(){
        self.selected = .personal
        coorporateAccountView.isHidden = true
        personalAccountView.isHidden = false
        ownerDetailsView.isHidden = true
        activateButtonForpersonalAccount(nil)
    }
    
    private func showCorporateAccount(){
        self.selected = .corporate
        self.showingDetailForm = false
        UIView.animate(withDuration: 0.3) {
            self.personalAccountView.isHidden = true
            self.coorporateAccountView.isHidden = false
            self.ownerDetailsView.isHidden = true
            self.activateButtonForCorporateAccount(nil)
        }
    }
    
    private func showCorporateOwnerFormView() {
        self.showingDetailForm = true
        UIView.animate(withDuration: 0.3) {
            self.coorporateAccountView.isHidden = true
            self.personalAccountView.isHidden = true
            self.ownerDetailsView.isHidden = false
            self.activateButtonForDetailsView()
        }
    }
    
    func loadBusinessTypes() {
        guard self.loading == false else {
            return
        }
        self.loading = true
        self.authViewModel.loadBusinessTypes { [weak self] (result) in
            switch result {
            case .success(let types):
                if let businesses = types as? [BusinessType] {
                    DispatchQueue.main.async {
                        self?.coorporateAccountView.businessTypes = businesses
                        self?.coorporateAccountView.businessType.reloadAllComponents()
                    }
                }
                self?.loading = false
            case .failure(_):
                break
            }
        }
    }

    @objc func openPrivacyPolicy(gesture: UITapGestureRecognizer){
        
        let range  = NSRange(location: 34, length: 20)
        let tapLocation = gesture.location(in: termsLabel)
        let tapIndex = termsLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
                
        if tapIndex > range.location  && tapIndex < range.location + range.length{
            let urlString = "https://www.wayapaychat.com/privacy-page"
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                vc.delegate = self
                present(vc, animated: true)
            }
        }
    }    
    
    @objc func openTermsAndConditon(gesture: UITapGestureRecognizer) {
        let range  = NSRange(location: 34, length: 20)
        let tapLocation = gesture.location(in: termsLabel)
        let tapIndex = termsLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        
        if tapIndex > range.location  && tapIndex < range.location + range.length{
            let urlString = "https://www.wayapaychat.com/terms-of-use"
            if let url = URL(string: urlString) {
                let vc = SFSafariViewController(url: url)
                vc.delegate = self
                present(vc, animated: true)
            }
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidAppear(animated)
    }
    
    @objc func handleSegmentControl(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
            case 0:
                showCorporateAccount()
            case 1:
                showPersonalAccount()
            default:
                showCorporateAccount()
        }
    }
    
    private func observePersonalAccountTextFields(){
        personalAccountView.firstNameTextField.input.addTarget(self, action: #selector(activateButtonForpersonalAccount), for: .editingChanged)
        personalAccountView.surnameTextField.input.addTarget(self, action: #selector(activateButtonForpersonalAccount), for: .editingChanged)
        personalAccountView.emailTextField.input.addTarget(self, action: #selector(activateButtonForpersonalAccount), for: .editingChanged)
        personalAccountView.referralTextField.input.addTarget(self, action: #selector(activateButtonForpersonalAccount), for: .editingChanged)
        personalAccountView.phoneNumberTextField.input.addTarget(self, action: #selector(activateButtonForpersonalAccount), for: .editingChanged)
        personalAccountView.phoneNumberTextField.input.addTarget(self, action: #selector(activateButtonForpersonalAccount), for: .editingDidEnd)
        personalAccountView.phoneNumberTextField.input.addTarget(self, action: #selector(activateButtonForpersonalAccount), for: .editingChanged)
    }
    
    private func observeCoorporateAccountTextFields(){
        coorporateAccountView.organizationNameTextField.input.addTarget(self, action: #selector(activateButtonForCorporateAccount), for: .editingChanged)
        coorporateAccountView.organizationTypeTextField.input.addTarget(self, action: #selector(activateButtonForCorporateAccount), for: .editingChanged)
        coorporateAccountView.organizationNameTextField.input.addTarget(self, action: #selector(activateButtonForCorporateAccount), for: .editingChanged)
        coorporateAccountView.businessTypeTextField.input.addTarget(self, action: #selector(activateButtonForCorporateAccount(_:)), for: .editingChanged)
        coorporateAccountView.orgPhoneNumber.input.addTarget(self, action: #selector(activateButtonForCorporateAccount(_:)), for: .editingChanged)
    }
    
    private func observeOwnerDetailsTextFields() {
        ownerDetailsView.surnameTextField.input.addTarget(self, action: #selector(activateButtonForDetailsView), for: .editingChanged)
        ownerDetailsView.firstNameTextField.input.addTarget(self, action: #selector(activateButtonForDetailsView), for: .editingChanged)
        ownerDetailsView.stateTextField.input.addTarget(self, action: #selector(activateButtonForDetailsView), for: .editingChanged)
        ownerDetailsView.cityTextField.input.addTarget(self, action: #selector(activateButtonForDetailsView), for: .editingChanged)
        ownerDetailsView.officeAddressTextField.input.addTarget(self, action: #selector(activateButtonForDetailsView), for: .editingChanged)
    }

    @objc func activateButtonForpersonalAccount(_ sender: UITextField?){
        
        if personalAccountView.firstNameTextField.input.text != nil && personalAccountView.firstNameTextField.input.text != ""
            && personalAccountView.surnameTextField.input.text != nil && personalAccountView.surnameTextField.input.text != ""
            && personalAccountView.emailTextField.input.text != nil && personalAccountView.emailTextField.input.text != ""
            && personalAccountView.phoneNumberTextField.input.text != nil && personalAccountView.phoneNumberTextField.input.text != ""{
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.3
        }
    }
    
    
    
    @objc func activateButtonForCorporateAccount(_ sender: UITextField?){
        
        if coorporateAccountView.orgPhoneNumber.input.text != nil && coorporateAccountView.orgPhoneNumber.input.text != ""
            && coorporateAccountView.organizationNameTextField.input.text != nil && coorporateAccountView.organizationNameTextField.input.text != ""
            && coorporateAccountView.businessTypeTextField.input.text != nil && coorporateAccountView.businessTypeTextField.input.text != ""
            && coorporateAccountView.orgEmailAddress.input.text != nil && coorporateAccountView.orgEmailAddress.input.text != ""{
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.3
        }
    }
    
    @objc func activateButtonForDetailsView() {
        if ownerDetailsView.surnameTextField.input.text != nil && ownerDetailsView.surnameTextField.input.text != "" && ownerDetailsView.firstNameTextField.input.text != nil && ownerDetailsView.firstNameTextField.input.text != "" && ownerDetailsView.stateTextField.input.text != nil && ownerDetailsView.stateTextField.input.text != "" && ownerDetailsView.cityTextField.input.text != nil && ownerDetailsView.cityTextField.input.text != "" && ownerDetailsView.officeAddressTextField.input.text != nil && ownerDetailsView.officeAddressTextField.input.text != "" {
            nextButton.isEnabled = true
            nextButton.alpha = 1.0
        } else{
            nextButton.isEnabled = false
            nextButton.alpha = 0.3
        }
    }
    
    @objc func didTapBackButton (){
        if selected == .corporate && showingDetailForm == true {
            showCorporateAccount()
        } else {
            onBackButtonPressed?()
        }
    }
    
    @objc func didTapNextButton(){
        switch selected {
        case .personal:
            personalAccountView.validator.validate(self)
        case .corporate:
            if showingDetailForm {
                ownerDetailsView.validator.validate(self)
            } else {
                coorporateAccountView.validator.validate(self)
            }
        }
    }
}


extension RegisterViewController: ValidationDelegate {
    func validationSuccessful() {
        if selected == .corporate && !self.showingDetailForm {
            showCorporateOwnerFormView()
        } else {
            self.submit()
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (_, error) in errors {
            self.showAlert(message: error.errorMessage)
            break
        }
    }
}
