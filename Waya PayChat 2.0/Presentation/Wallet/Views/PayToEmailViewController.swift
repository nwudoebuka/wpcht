//
//  PayToEmailViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/8/21.
//

import SwiftValidator

protocol PayToEmailView : BaseView {
    var onPayToEmailSuccessful : (() -> Void)? { get set }
}


class PayToEmailViewController: UIViewController, PayToEmailView, UITextFieldDelegate, Alertable {

    var viewType  = 0 //selectCard and CardDetail
    let walletViewModel : WalletViewModelImpl!
    var authViewModel = AuthViewModelImpl()
    
    var transactionDetailView : TransactionDetailView!
    var transactionDetail : TransactionDetail!
    var successView : AlertView!
    
    var nameTextField : TextInput!
    var emailTextField : TextInput!
    var amountTextField : TextInput!
    var walletField: TextInput!
    var descriptionField: TextInput!
    
    var headerImageView : UIImageView!
    
    var nextButton : UIButton!
    var selectedWallet: UserWalletResponse!
    let picker = UIPickerView()
    
    var onPayToEmailSuccessful : (() -> Void)?
    let validator = Validator()
    
    init(walletViewModel : WalletViewModelImpl){
        self.walletViewModel = walletViewModel
        super.init(nibName : nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavigation()
        setUpSelectCard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupValidation()
        authViewModel.pinVerified.subscribe(with: self) { (verified, error) in
            LoadingView.hide()
            DispatchQueue.main.async {
                if verified == true {
                    self.payToEmail()
                } else {
                    self.showAlert(message: error!)
                }
            }
        }
    }
    
    private func setUpNavigation(){
        title = "Pay to Email"
        self.navigationItem.hidesBackButton = true
        let  backBarButton = UIBarButtonItem.init(image: UIImage(named: "back-arrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackPressed))
        
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func handleBackPressed(sender: UIBarButtonItem) {
        // Perform your custom actions
        if viewType == 0{
            // Go back to the previous ViewController
            self.navigationController?.popViewController(animated: true) 
        } else{
            hideTransactionDetail()
        }
    }
    
    private func setUpSelectCard(){
        picker.dataSource = self
        picker.delegate = self
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem.init(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([doneBtn], animated: true)
        
        nameTextField = UI.textField(placeholder: "Name")
        emailTextField = UI.textField(placeholder: "E-mail Address")
        amountTextField = UI.textField(placeholder: "Enter Amount")
        walletField = UI.textField(placeholder: "Debit wallet")
        walletField.input.rightView = UIImageView(image: UIImage(named: "drop-down-arrow"))
        walletField.input.rightViewMode = .always
        walletField.input.inputView = picker
        walletField.input.inputAccessoryView = toolbar
        
        descriptionField = UI.textField(placeholder: "Add a Note (optional)")
        
        headerImageView = generateUIImageView(imageName: "ic_pay_to_email")
        view.backgroundColor = .white
        view.addSubviews([headerImageView, nameTextField, emailTextField, amountTextField, walletField, descriptionField])
        
        headerImageView.sizeAnchor(height: nil, width: nil, heightConstant: 100, widthConstant: 100)
        headerImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        headerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        nameTextField.anchor(top: headerImageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 40, left: 24, bottom: 0, right: 24))
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailTextField.anchor(top: nameTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24))
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        amountTextField.anchor(top: emailTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24))
        amountTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        walletField.anchor(top: amountTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24))
        walletField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        descriptionField.anchor(top: walletField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24))
        descriptionField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nextButton  = UI.button(title: "Next")
        view.addSubview(nextButton)
        nextButton.anchor(top: descriptionField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 48, left: 30, bottom: 0, right: 30))
        nextButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        amountTextField.input.delegate = self
        nameTextField.input.delegate = self
        emailTextField.input.delegate = self
                
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        amountTextField.input.keyboardType = .numberPad
        
        amountTextField.input.inputAccessoryView = toolbar
        nameTextField.input.inputAccessoryView = toolbar
        emailTextField.input.inputAccessoryView = toolbar
    } 
    
    @objc func dismissUserKeyboard(){
        view.endEditing(true)
    }

    
    func setupValidation() {
        validator.registerField(amountTextField.input, rules: [RequiredRule(), NumericRule()])
        validator.registerField(emailTextField.input, rules: [EmailRule(), RequiredRule()])
        validator.registerField(nameTextField.input, rules: [RequiredRule(), AlphaNumericRule()])
        validator.registerField(descriptionField.input, errorLabel: descriptionField.errorLabel, rules: [AlphaNumericRule(), MinLengthRule(length: 3)])
    }
    
    @objc func didTapNextButton(){
        validator.validate(self)
    }
    
    private func hideTransactionDetail(){
        if transactionDetailView != nil {
            transactionDetailView?.removeFromSuperview()
            transactionDetailView = nil
        }
        viewType = 0
    }
    
    @objc func didTapConfirmButton(){
        if transactionDetailView!.otpStackView.getOTP().count > 0{
            validateOtp()
        } else{
            showAlert(title: "Pin Error!", message: "Invalid Pin")
        }
    }
    
    func validateOtp(){
        let pin = transactionDetailView.otpStackView.getOTP()
        guard pin.length == 4 else {
            self.showAlert(message: "Invalid PIN entered")
            return
        }
        LoadingView.show()
        authViewModel.validateUserPin(pin: pin)
    }
        
    func addSuccessView(){
        transactionDetailView?.removeFromSuperview()
        successView = AlertView(frame: UIScreen.main.bounds, title: "Successful", mode: .success(.generic))
        successView.bodyLabel.text = "\(amountTextField.text.currencySymbol) has been sent to \n \(emailTextField.input.text!)"
        successView.continueButton.setTitle("Finish", for: .normal)
        UIApplication.shared.keyWindow!.addSubview(successView)
        self.view.bringSubviewToFront(successView)
        successView.isUserInteractionEnabled = true
        successView.continueButton.addTarget(self, action: #selector(didTapFinish), for: .touchUpInside)
    }
    
//    func addFailureView(failure: TransactionError) {
//        successView = AlertView(frame: UIScreen.main.bounds)
//        successView.mode = .failure(failure)
//        successView.continueButton.setTitle("Try Again", for: .normal)
//        UIApplication.shared.keyWindow!.addSubview(successView)
//        self.view.bringSubviewToFront(successView)
//        successView.isUserInteractionEnabled = true
//        successView.continueButton.addTarget(self, action: #selector(didTapTryAgain), for: .touchUpInside)
//    }
//
    @objc func didTapFinish(){
        self.successView.removeFromSuperview()
        self.successView = nil
        onPayToEmailSuccessful?()
    }
    
    @objc func didTapTryAgain() {
        self.successView.removeFromSuperview()
        self.successView = nil
        transactionDetailView.otpStackView.clear()
    }
    
    func payToEmail(){
        LoadingView.show()
        
        let sendMoneyRequest = SendMoneyToEmailRequest(amount: Decimal(string: amountTextField.text)!, description: transactionDetail.description!, senderAccountNumber: selectedWallet.accountNo, senderId: auth.data.userId!)
        walletViewModel.sendMoneyToEmail(email: emailTextField.text, sendMoneyToEmailRequest: sendMoneyRequest) {[weak self] (result) in
            LoadingView.hide()
            DispatchQueue.main.async {
                switch  result{
                   case .success(_):
                       self?.addSuccessView()
                   case .failure(.custom(let message)):
                       self?.transactionDetailView.showWarning(type: .error, text: message)
               }
            }
        }
    }
    
    func setTransactionDetailView(){
        self.transactionDetail = TransactionDetail(beneficary: emailTextField.text, amount: amountTextField.text, accountNo: selectedWallet.accountNo, transactionFee: "10.00", bank: "Wema", labelTitle: "To", labelValue: nameTextField.text, description: descriptionField.input.text ?? "Email Transfer")
    }
    
    private func showTransactionDetailView(){
        transactionDetail.amount = amountTextField.text
        transactionDetailView = TransactionDetailView(frame: view.frame, transactionDetail: transactionDetail)
        transactionDetailView.source = .wallet
        
        DispatchQueue.main.async {
            self.view.addSubview(self.transactionDetailView)
            self.transactionDetailView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            self.transactionDetailView.confirmButton.onTouchUpInside.subscribe(with: self) {
                self.validateOtp()
            }
            self.view.bringSubviewToFront(self.transactionDetailView)
        }
    }
}

extension PayToEmailViewController: ValidationDelegate {
    func validationSuccessful() {
        dismissKeyboard()
        setTransactionDetailView()
//        view.isHidden = true
        showTransactionDetailView()
        viewType = 1
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? TextInput {
                field.errorLabel.text = error.errorMessage
                field.isHidden = false
            }
        }
    }
}


extension PayToEmailViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return auth.data.accounts!.wallets!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return auth.data.accounts!.wallets![row].accountNo
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedWallet = auth.data.accounts!.wallets![row]
        walletField.input.text = selectedWallet.accountNo
        walletField.errorLabel.text = "\(selectedWallet.balance)".currencySymbol!
        walletField.errorLabel.isHidden = false
    }
}
