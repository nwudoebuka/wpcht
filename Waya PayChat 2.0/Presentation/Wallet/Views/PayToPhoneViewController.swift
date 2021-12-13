//
//  PayToPhoneViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/8/21.
//
import UIKit

protocol PayToPhoneView : BaseView {
   var  onPayToPhoneViewSuccess: (() -> Void)?{ get set} 
}

class PayToPhoneViewController: UIViewController, PayToPhoneView, Alertable {

    let walletViewModel : WalletViewModelImpl!
    var onPayToPhoneViewSuccess: (() -> Void)?

    var viewType  = 0 //selectCard and CardDetail
    var authViewModel = AuthViewModelImpl()
    var contactViewModel = ContactViewModelImpl()
    
    let phonelDetailView = UIView()
    var transactionDetailView : TransactionDetailView!
    var transactionDetail : TransactionDetail!
    var successView : AlertView!
    
    var descriptionTextField : TextInput!
    var phoneTextField : TextInput!
    var amountTextField : TextInput!
    
    lazy var searchDropdown: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 0.2
        view.register(ContactSearchDropdownCell.self, forCellReuseIdentifier: "contact")
        return view
    }()
    
    var headerImageView : UIImageView!
    
    var nextButton : UIButton!
    var selectedRow = -1
        
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
        accessContacts()
    }
    
    private func showTransactionDetailView(){
        transactionDetail.amount = amountTextField.input.text!
        transactionDetailView = TransactionDetailView(frame: CGRect.zero, transactionDetail: transactionDetail)
        view.addSubview(transactionDetailView)
        transactionDetailView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        transactionDetailView.confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
    }
    
    private func setUpNavigation(){
        title = "Pay to Phone"
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
        
        searchDropdown.delegate = self
        searchDropdown.dataSource = self
        
        descriptionTextField = UI.textField(placeholder: "Add a Note (optional)")
        
        phoneTextField = UI.textField(placeholder: "Phone Number")
        phoneTextField.input.delegate = self

        amountTextField = UI.textField(placeholder: "Enter Amount")
        headerImageView = generateUIImageView(imageName: "ic_pay_to_email")
        
        phonelDetailView.addSubview(phoneTextField)
        phonelDetailView.addSubview(amountTextField)
        phonelDetailView.addSubview(descriptionTextField)

        
        phoneTextField.anchor(top: phonelDetailView.topAnchor, leading: phonelDetailView.leadingAnchor, bottom: nil, trailing: phonelDetailView.trailingAnchor, padding: UIEdgeInsets(top: 56, left: 32, bottom: 0, right: 28))
        phoneTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        amountTextField.anchor(top: phoneTextField.bottomAnchor, leading: phonelDetailView.leadingAnchor, bottom: nil, trailing: phonelDetailView.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 32, bottom: 0, right: 28))
        amountTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        descriptionTextField.anchor(top: amountTextField.bottomAnchor, leading: phonelDetailView.leadingAnchor, bottom: nil, trailing: phonelDetailView.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 32, bottom: 0, right: 28))
        descriptionTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        nextButton  = customPrimaryButton(text: "Next")
        phonelDetailView.addSubview(nextButton)
        nextButton.anchor(top: descriptionTextField.bottomAnchor, leading: phonelDetailView.leadingAnchor, bottom: nil, trailing: phonelDetailView.trailingAnchor, padding: UIEdgeInsets(top: 48, left: 30, bottom: 0, right: 30))
        nextButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        view.addSubview(phonelDetailView)
        phonelDetailView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        amountTextField.input.delegate = self
        descriptionTextField.input.delegate = self
        phoneTextField.input.delegate = self
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        amountTextField.input.keyboardType = .numberPad
        phoneTextField.input.keyboardType = .numberPad
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissUserKeyboard))
        toolbar.setItems([doneBtn], animated: true)
        amountTextField.input.inputAccessoryView = toolbar
        descriptionTextField.input.inputAccessoryView = toolbar
        phoneTextField.input.inputAccessoryView = toolbar
        
        phoneTextField.input.addTarget(self, action: #selector(changeFirstNumberToCode(_:)), for: .editingChanged)
    }
    
    private func accessContacts() {
        contactViewModel.requestContactAccess { [weak self] (granted, error) in
            if granted {
                self?.contactViewModel.loadContacts() {[weak self] (done, error) in
                    if done {
                        self?.contactViewModel.checkForWayaUsers()
                        self?.searchDropdown.reloadData()
                    } else {
                        self?.showAlert(message: error!)
                    }
                }
            } else {
                self?.showSimpleTwoOptionAlert(title: "Error Access Contacts", messageTitle: "Show Settings", body: "Wayapaychat does not have access to your contacts") {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }

                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl)
                    }
                }
            }
        }
    }
    
    @objc func changeFirstNumberToCode(_ sender : UITextField){
        if sender  == phoneTextField.input && sender.text != nil && sender.text!.count == 1  {
            if phoneTextField.input.text?.first == "0"{
                phoneTextField.input.text?.removeFirst()
                phoneTextField.input.text = "234"
            }
            
            self.contactViewModel.filter(nameOrPhone: sender.text!) { [weak self] in
                self?.searchDropdown.reloadData()
            }
        }
        
    }
    
    @objc func dismissUserKeyboard(){
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowShortView(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    
    @objc func didTapNextButton(){
       if amountTextField.input.text == "" || amountTextField.input.text == nil{
            showAlert(message: "Please type an amount")
        }else if phoneTextField.input.text == "" || phoneTextField.input.text == nil{
            showAlert(message: "Please enter email")
        }
        else{
            showChargeAlert() 
        }
    }
    
    private func hideTransactionDetail(){
        transactionDetailView.removeFromSuperview()
        transactionDetailView = nil
        phonelDetailView.isHidden = false
        viewType = 1
    }
    
    @objc func didTapConfirmButton(){
        if transactionDetailView.otpStackView.getOTP().count > 0{
            validateOtp()  
        } else{
            showAlert(title: "Pin Error!!", message: "Invalid Pin") 
        }
    }
    
    func showChargeAlert(){
        showSimpleTwoOptionAlert(title: "Transfer to Phone", messageTitle: "Okay", body: "Send money to anyone using their phone number. Once sent users will receive an SMS through which they can sign up and access the money in their wallet", action: acceptCharge)
    }
    
    func acceptCharge(){
        setTransactionDetailView()
        phonelDetailView.isHidden = true
        showTransactionDetailView()
        viewType = 1
    }
    
    func validateOtp(){
//        LoadingView.show()
//        
//        let pin = transactionDetailView.otpStackView.getOTP()
//        authViewModel.validateUserPin(pin: pin) {[weak self]
//            (result) in
//            LoadingView.hide()
//            switch result{
//                case .success(let response):
//                    self?.payToPhone()
//                case .failure(.custom(let message)):
//                    self?.showAlert(title: "Pin Failed", message: message)
//                    
//            }
//        }        
    }
    
    func addSuccessView(){
        
        successView = AlertView(frame:  UIScreen.main.bounds)
        successView.bodyLabel.text = "N\(amountTextField.input.text!) has been sent to \n \(phoneTextField.input.text!)"
        successView.continueButton.setTitle("Finish", for: .normal)
        UIApplication.shared.keyWindow!.addSubview(successView)
        self.view.bringSubviewToFront(successView)
        successView.isUserInteractionEnabled = true
        successView.continueButton.addTarget(self, action: #selector(didTapFinish), for: .touchUpInside)
        
    }
    
    func addFailureView(failure: TransactionError) {
        successView = AlertView(frame:  UIScreen.main.bounds)
        successView.mode = .failure(nil) //TODO: better error handing
        successView.bodyLabel.text = failure.message
        successView.continueButton.setTitle("Try Again", for: .normal)
        UIApplication.shared.keyWindow!.addSubview(successView)
        self.view.bringSubviewToFront(successView)
        successView.isUserInteractionEnabled = true
        successView.continueButton.addTarget(self, action: #selector(didTapTryAgain), for: .touchUpInside)
    }
    
    @objc func didTapFinish(){
        self.successView.removeFromSuperview()
        self.successView = nil
//        print("Sucess tap on top up")
        onPayToPhoneViewSuccess?()
    }
    
    @objc func didTapTryAgain() {
        self.successView.removeFromSuperview()
        self.successView = nil
        transactionDetailView.otpStackView.clear()
    }
    
    func payToPhone(){
        let sendMoneyToContact = SendMoneyToPhoneRequest(amount: Int(amountTextField.input.text!) ?? 0, phoneNumber: phoneTextField.input.text!)
        walletViewModel.sendMoneyToContact(sendMoneyToPhoneRequest: sendMoneyToContact) {[weak self] (result) in
            switch  result{
                case .success(let response):
                    print("respo")
                    self?.addSuccessView()
                case .failure(.custom(let message)):
                    print("message \(message)")
                    guard let message = self?.phoneTextField.input.text else {
                        self?.showAlert(message: "Failed to send money")
                        return
                    }
                    self?.showAlert(message: "Failed to send money to \(message)")


            }
        }
    }
    
    func setTransactionDetailView(){
        self.transactionDetail = TransactionDetail(beneficary: phoneTextField.input.text!, amount: amountTextField.input.text!, accountNo: phoneTextField.input.text!, transactionFee: amountTextField.input.text!, bank: "Rubies", labelTitle: "To", labelValue: phoneTextField.input.text!, description: descriptionTextField.input.text ?? "")
    }    
}

extension PayToPhoneViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchDropdown.removeFromSuperview()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addSubview(searchDropdown)
        NSLayoutConstraint.activate([
            searchDropdown.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 10),
            searchDropdown.heightAnchor.constraint(equalToConstant: 250),
            searchDropdown.trailingAnchor.constraint(equalTo: phoneTextField.trailingAnchor),
            searchDropdown.leadingAnchor.constraint(equalTo: phoneTextField.leadingAnchor)
        ])
    }
}

extension PayToPhoneViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contactViewModel.filteredContacts.count > 0) ? contactViewModel.filteredContacts.count : contactViewModel.contacts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as? ContactSearchDropdownCell else {
            return UITableViewCell()
        }
        
        cell.contact = (contactViewModel.filteredContacts.count > 0) ? contactViewModel.filteredContacts[indexPath.row] : contactViewModel.contacts[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as? ContactSearchDropdownCell else {
            return
        }
        
        let contact = (self.contactViewModel.filteredContacts.count > 0) ? self.contactViewModel.filteredContacts[indexPath.row] : self.contactViewModel.contacts[indexPath.row]
        cell.contact = contact
//        cell.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
}
