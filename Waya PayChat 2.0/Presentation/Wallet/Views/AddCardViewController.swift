//
//  AddCardViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/12/21.
//
import SwiftValidator
import Signals
import ScrollableView

protocol AddCardView : BaseView{
    
}


class AddCardViewController: UIViewController, AddCardView , Alertable {

    lazy var contentViewSize = CGSize(width: view.frame.width, 
                                      height: view.frame.height - 200)
    
    var monthComponents : [String] = []
    var yearComponents : [String] = []

    let monthPicker = UIPickerView()
    let yearPicker = UIPickerView()

    var walletViewModel = WalletViewModelImpl()
    let validator = Validator()
    
    // success, otp needed, ref if success, error if any
    var cardAdded = Signal<(Bool, Bool, String?, String?)>()
    
    public lazy var content: UIStackView = {
        let contentView = UIStackView(frame: .zero)
        contentView.axis = .vertical
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.clipsToBounds = true
        contentView.distribution = .fill
        return contentView
    }()
    
    public lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isDirectionalLockEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
//    lazy var containerView  : UIView = {
//        let view  = UIView()
//        view.backgroundColor = .white
//        view.frame.size = contentViewSize
//        return view
//    }()
//
    var datePicker : UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
    var toolbar  : CustomToolbar = {
        let toolbar = CustomToolbar()
        toolbar.backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
        toolbar.titleLabel.text = "Add Card"
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    let cardImageView : UIImageView = {
        let imageView =  UIImageView()
        let w : CGFloat = 157
        imageView.frame.size.height = 157
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "user-card-holder")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var cardNumberLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "****  ****  ****  ****"
        label.font = UIFont(name: "Lato-Regular", size: 22)
        return label
    }()
    
    var cardHolderNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Card holder"
        label.font = UIFont(name: "Lato-Regular", size: 11)
        return label
    }()
    
    var cardHolderNameValue : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Full Name"
        label.font = UIFont(name: "Lato-Regular", size: 17)
        return label
    }()
    
    var expiryDateLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Expire date"
        label.font = UIFont(name: "Lato-Regular", size: 11)
        return label
    }()
    
    var expiryDateValue : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor =  .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "**/**"
        label.font = UIFont(name: "Lato-Regular", size: 17)
        return label
    }()
    
    let cardView : UIView = {
        let card = UIView()
        card.translatesAutoresizingMaskIntoConstraints = false 
        return card
    }()
    
    lazy var nameTextField: TextInput = {
        return UI.textField(label: "Name", placeholder: "Full Name")
    }()
    
    lazy var cardTextField : TextInput = {
        return UI.textField(label: "Card Number", placeholder: "0000 0000 0000 0000")
    }()
    
    lazy var expiryMonthTextField : TextInput = {
        return UI.textField(label: "Expiry Month", placeholder: "Apr")
    }()
    
    lazy var expiryYearTextField : TextInput = {
        return UI.textField(label: "Expiry Year", placeholder: "2024")
    }()
    
    lazy var cvvTextField : TextInput = {
        return UI.textField(label: "CVV", placeholder: "000")
    }()
    
    lazy var cardPinTextField : TextInput = {
        let field = UI.textField(label: "Card PIN", placeholder: "****")
        field.input.isSecureTextEntry = true
        return field
    }()

    var expiryDateStack = UIStackView()
    
    var addCardButton : UIButton = {
        let button  = UI.button(title: "Add Card")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpPickerView()
        setupValidation()
    }
    
    func setUpViews(){
        view.backgroundColor = .white
        content.spacing = 24
        
        self.scrollView.addSubview(self.content)
        
        self.view.addSubviews([toolbar, cardView, scrollView])

        toolbar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        toolbar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cardView.anchor(top: toolbar.safeAreaLayoutGuide.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 39, left: 0, bottom: 0, right: 0))
        cardView.heightAnchor.constraint(equalToConstant: 157).isActive = true
        
        scrollView.anchor(top: cardView.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
        
        content.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
        content.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
        
        // add components to card view
        cardView.addSubviews([cardImageView])
        
        cardImageView.addSubviews([cardNumberLabel, cardHolderNameLabel,
        cardHolderNameValue, expiryDateLabel, expiryDateValue])
        
        cardImageView.anchor(top: cardView.topAnchor, leading: cardView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: cardView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22))
        
        cardNumberLabel.anchor(top: cardImageView.topAnchor, leading: cardImageView.leadingAnchor, bottom: nil, trailing: cardView.trailingAnchor, padding: UIEdgeInsets(top: 14, left: 15, bottom: 0, right: 12))

        cardHolderNameLabel.anchor(top: nil, leading: cardImageView.leadingAnchor, bottom: cardImageView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 17, bottom: 52, right: 0))
        cardHolderNameLabel.heightAnchor.constraint(equalToConstant: 17).isActive = true

        cardHolderNameValue.anchor(top: cardHolderNameLabel.bottomAnchor, leading: cardImageView.leadingAnchor, bottom: cardView.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 17, bottom: 32, right: 0))

        expiryDateLabel.anchor(top: nil, leading: nil, bottom: cardView.bottomAnchor, trailing: cardImageView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 52, right: 17))

        expiryDateValue.anchor(top: expiryDateLabel.bottomAnchor, leading: expiryDateLabel.leadingAnchor, bottom: cardImageView.bottomAnchor, trailing: cardImageView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 17))

//        // Setup Form
        scrollView.isScrollEnabled = true
        content.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true

        let empty = UIView()
        empty.translatesAutoresizingMaskIntoConstraints = false
        content.addArrangedSubview(nameTextField)
        content.addArrangedSubview(cardTextField)
        content.addArrangedSubview(expiryDateStack)
        content.addArrangedSubview(cvvTextField)
        content.addArrangedSubview(cardPinTextField)
        content.addArrangedSubview(addCardButton)
        content.addArrangedSubview(empty)
        
        nameTextField.anchor(top: nil, leading: content.leadingAnchor, bottom: nil, trailing: content.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22))
        nameTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cardTextField.anchor(top: nil, leading: content.leadingAnchor, bottom: nil, trailing: content.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 22, bottom: 0, right: 22))
        cardTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        expiryDateStack.addArrangedSubview(expiryMonthTextField)
        expiryDateStack.addArrangedSubview(expiryYearTextField)
        expiryDateStack.distribution = .fillEqually
        expiryDateStack.spacing = 22
        expiryDateStack.axis = .horizontal
        expiryDateStack.translatesAutoresizingMaskIntoConstraints = false
        expiryDateStack.anchor(top: nil, leading: content.leadingAnchor, bottom: nil, trailing: content.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 22, bottom: 0, right: 22))
        expiryDateStack.heightAnchor.constraint(equalToConstant: 50).isActive = true

        expiryMonthTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        expiryYearTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        cvvTextField.anchor(top: nil, leading: content.leadingAnchor, bottom: nil, trailing: content.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22))
        cvvTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true

        cardPinTextField.anchor(top: nil, leading: content.leadingAnchor, bottom: nil, trailing: content.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22))
        cardPinTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        empty.anchor(top: nil, leading: content.leadingAnchor, bottom: nil, trailing: content.trailingAnchor)
        empty.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        addCardButton.anchor(top: nil, leading: content.leadingAnchor, bottom: nil, trailing: content.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22))
        addCardButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        addCardButton.addTarget(self, action: #selector(validateAndContinue), for: .touchUpInside)
        
        cvvTextField.input.keyboardType = .numberPad
        cardTextField.input.keyboardType = .numberPad
        cardPinTextField.input.keyboardType = .numberPad
        toolbar.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        cardTextField.input.addTarget(self, action: #selector(textListener(_:)), for: .editingChanged)
        expiryMonthTextField.input.addTarget(self, action: #selector(textListener(_:)), for: .editingChanged)
        cvvTextField.input.addTarget(self, action: #selector(textListener(_:)), for: .editingChanged)
        expiryYearTextField.input.addTarget(self, action: #selector(textListener(_:)), for: .editingChanged)
        nameTextField.input.addTarget(self, action: #selector(textListener(_:)), for: .editingChanged)
    }
    
    func setupValidation() {
        validator.registerField(cardTextField, errorLabel: cardTextField.errorLabel, rules: [RequiredRule(), CardNumberRule()])
        validator.registerField(expiryMonthTextField, errorLabel: expiryMonthTextField.errorLabel, rules: [RequiredRule()])
        validator.registerField(expiryYearTextField, errorLabel: expiryYearTextField.errorLabel, rules: [RequiredRule(), CardExpiryYearRule()])
        validator.registerField(cvvTextField, errorLabel: cvvTextField.errorLabel, rules: [RequiredRule(), MaxLengthRule(length: 3), MinLengthRule(length: 3)])
        validator.registerField(cardPinTextField, errorLabel: cardPinTextField.errorLabel, rules: [RequiredRule(), MinLengthRule(length: 4)])
    }
    
    @objc func textListener(_ sender: UITextField){
        switch sender {
            case nameTextField.input:
                cardHolderNameValue.text = nameTextField.input.text
            case cvvTextField.input:
                
                if let  cvvCount = cvvTextField.input.text?.count, cvvCount >= 3{
                    view.endEditing(true)
                }
            case cardTextField.input:
                cardNumberLabel.text = cardTextField.input.text
            default:
                break
        }

    }
    
    @objc func validateAndContinue() {
        self.validator.validate(self)
    }
    
    func addCard(){
        let wallet: String
        guard let allWallets = auth.data.accounts?.wallets, allWallets.count > 0 else {
            self.showAlert(message: "No wallet to fund")
            return
        }
        if let defaultWallet = allWallets.filter({$0.datumDefault == true}).first {
            wallet = defaultWallet.accountNo
        } else {
            wallet = allWallets.first!.accountNo
        }
        
        LoadingView.show()
        let df = DateFormatter()
        df.dateFormat = "LLL"  // if you need 3 letter month just use "LLL"
        if let date = df.date(from: expiryMonthTextField.input.text!) {
            let month = Calendar.current.component(.month, from: date)
            let cardRequest: [String:String] = [
                "name" : nameTextField.input.text!,
                "cardNumber" : cardTextField.input.text!,
                "expiryMonth" : String(month),
                "expiryYear" : expiryYearTextField.input.text!,
                "cvv" : cvvTextField.input.text!,
                "email" : String(auth.data.profile!.email),
                "accountNo" : wallet,
                "userId" : String(auth.data.userId!),
                "pin" : cardPinTextField.input.text!,
                "last4digit" : cardTextField.input.text!.getLastFew(range: 4),
            ]
            
            guard let request = try? cardRequest.customCodableObject(type: AddCardRequest.self) else {
                return
            }
            walletViewModel.addCard(addCardRequest: request) { [weak self] (result) in
                LoadingView.hide()
                switch result{
                    case .success(let response):
                        if let response = response as? Response<AddCardResponse> {
                            
                            if response.status! == true {
                                if let data = response.data {
                                    if data.status == .send_otp {
                                        self?.cardAdded => (true, true, data.reference, data.display_text)
                                    } else if data.status == .send_phone {
                                        self?.submitCardPhone(reference: data.reference)
                                    } else {
                                        self?.cardAdded => (true, false, nil, response.message!)
                                    }
                                } else {
                                    self?.cardAdded => (true, false, nil, response.message!)
                                }
                            } else {
                                if response.message!.contains("Unverified email or phone number") {
                                    self?.cardAdded => (false, false, nil, "Please verify your email address to perform transactions")
                                } else {
                                    self?.cardAdded => (false, false, nil, response.message)
                                }
                            }
                        }
                    case .failure(.custom(let message)):
                        self?.showAlert(title: "Failed to Add Card", message: message, preferredStyle: .alert)
                }
            }
        } else {
            self.showAlert(message: "failed")
        }
    }
    
    private func submitCardPhone(reference: String) {
        let request = SubmitPhoneRequest(phone: auth.data.profile!.phoneNumber, reference: reference, userId: String(auth.data.userId!))
        LoadingView.show()
        walletViewModel.submitCardPhone(request: request) { (result) in
            LoadingView.hide()
            switch result {
            case .success(let response):
                if let response = response as? Response<AddCardResponse>, let data = response.data {
                    if response.status! == true {
                        if data.status == .send_otp {
                            self.cardAdded => (true, true, data.reference, data.display_text)
                        } else {
                            self.cardAdded => (true, false, nil, response.message!)
                        }
                    } else {
                        self.cardAdded => (false, false, nil, response.message)
                    }
                }
            case .failure(let error):
                self.showAlert(title: "Failed to Add Card", message: error.localizedDescription, preferredStyle: .alert, completion: nil)
            }
        }
        
    }
    
   @objc func didTapBackButton(){
        dismiss(animated: true, completion: nil)
    }

}


extension AddCardViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == monthPicker{
            return monthComponents.count
        }
        return  yearComponents.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == monthPicker{
            return monthComponents[row]
        }
        return yearComponents[row]

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == monthPicker{
            if let  expDate = expiryDateValue.text{
                expiryDateValue.text = (row > 9 ? String(row + 1) : "0\(String(row + 1))") + expDate.getLastFew(range: 3)
            }
            expiryMonthTextField.input.text = monthComponents[row]
            expiryMonthTextField.resignFirstResponder()
            expiryYearTextField.becomeFirstResponder()
        } else {
            if let  expDate = expiryDateValue.text{
                expiryDateValue.text! = "\(expDate.getFirstFew(range: 2))/\(yearComponents[row].getLastFew(range: 2))"
            }
            expiryYearTextField.input.text = yearComponents[row]
            expiryYearTextField.resignFirstResponder()
            cvvTextField.becomeFirstResponder()

        }
    }
    
    func setUpPickerView(){
        let formatter = DateFormatter()
        monthComponents = formatter.shortMonthSymbols
        
        for i in 2021...2050{
            yearComponents.append(String(i))
        }
        
        monthPicker.delegate = self
        monthPicker.dataSource = self
        monthPicker.backgroundColor = .white
        expiryMonthTextField.input.inputView = monthPicker
        
        yearPicker.delegate = self
        yearPicker.dataSource = self
        yearPicker.backgroundColor = .white
        expiryYearTextField.input.inputView = yearPicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissDatePicker))
        toolbar.setItems([doneBtn], animated: true)
        
        expiryMonthTextField.input.inputAccessoryView = toolbar
        expiryYearTextField.input.inputAccessoryView = toolbar

    }
    
    @objc func dismissDatePicker(){
        
        view.endEditing(true)
    }
}


extension AddCardViewController: ValidationDelegate {
    func validationSuccessful() {
        showSimpleTwoOptionAlert(title: "Permissions", messageTitle: "OKAY, COOL", body: "We would deduct a refundable \n amount of N10 to verify your \n card, this amount will be refunded back into your wallet \n upon verification", action: addCard)
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for(field, error) in errors {
            if let field = field as? TextInput {
                field.errorLabel.text = error.errorMessage
                field.errorLabel.isHidden = false
            }
        }
    }
}
