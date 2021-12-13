//
//  PayToIDViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/8/21.
//
import SwiftValidator

protocol PayToIDView : BaseView {
    var  onPayToIDSuccess : (() -> Void)?{get set}
}

class PayToIDViewController: UIViewController, PayToIDView, Alertable {

    let walletViewModel : WalletViewModelImpl!
    let contactViewModel = ContactViewModelImpl()
    let validator = Validator()
    var navTitle = "Pay to Waya ID"
    var  onPayToIDSuccess : (() -> Void)?
   
    //table view to show list of all contacts 
    let transparentView = UIView() 
    let tableView = UITableView() 

    var viewType  = 0 //selectCard and CardDetail
    var authViewModel = AuthViewModelImpl()
    
    let phonelDetailView = UIView()
    var transactionDetailView : TransactionDetailView!
    var transactionDetail : TransactionDetail!
    var successView : AlertView!
    
    var descriptionTextField : TextInput!
    var selectedUserTextField : TextInput!
    var amountTextField : TextInput!
    
    var headerImageView : UIImageView!
    
    var nextButton : UIButton!
    var selectedRow = -1
    
    lazy var searchDropdown: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        view.layer.borderWidth = 0.2
        view.register(ContactSearchDropdownCell.self, forCellReuseIdentifier: "contact")
        return view
    }()
    
    init(walletViewModel : WalletViewModelImpl, title:String){
        self.navTitle = title
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
        fetchContactList()
        //temporarily added to launch only Wayapay to be removed af 
//        showComingSoonView()
    }
    
    private func showTransactionDetailView(){
        transactionDetail.amount = amountTextField.input.text!
        transactionDetailView = TransactionDetailView(frame: CGRect.zero, transactionDetail: transactionDetail)
        view.addSubview(transactionDetailView)
        transactionDetailView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        transactionDetailView.confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
    }
    
    private func setUpNavigation(){
        title = navTitle
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
        descriptionTextField = UI.textField(placeholder: "Add a Note (optional)")
        
        selectedUserTextField = UI.textField(placeholder: "Select User")
        
        amountTextField = UI.textField(placeholder: "Enter Amount")
        headerImageView = generateUIImageView(imageName: "ic_pay_to_email")
        
        phonelDetailView.addSubview(selectedUserTextField)
        phonelDetailView.addSubview(amountTextField)
        phonelDetailView.addSubview(descriptionTextField)
        
        
        selectedUserTextField.anchor(top: phonelDetailView.topAnchor, leading: phonelDetailView.leadingAnchor, bottom: nil, trailing: phonelDetailView.trailingAnchor, padding: UIEdgeInsets(top: 56, left: 32, bottom: 0, right: 28))
        selectedUserTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        amountTextField.anchor(top: selectedUserTextField.bottomAnchor, leading: phonelDetailView.leadingAnchor, bottom: nil, trailing: phonelDetailView.trailingAnchor, padding: UIEdgeInsets(top: 24, left: 32, bottom: 0, right: 28))
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
        selectedUserTextField.input.delegate = self
        
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        amountTextField.input.keyboardType = .numberPad
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissUserKeyboard))
        toolbar.setItems([doneBtn], animated: true)
        amountTextField.input.inputAccessoryView = toolbar
        descriptionTextField.input.inputAccessoryView = toolbar
        
        selectedUserTextField.input.delegate = self
        
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
        }else if selectedUserTextField.input.text == "" || selectedUserTextField.input.text == nil{
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
////        let validatePinRequest = ValidatePinRequest(token: UserDefaults.standard.string(forKey: "Token") ?? "",
//        let pin = transactionDetailView.otpStackView.getOTP()
//        authViewModel.validateUserPin(pin: pin) { [weak self] (result) in
//            LoadingView.hide()
//            switch result{
//                case .success(let response):
////                    print("the response \(response)")
//                    self?.payToPhone()
//                case .failure(.custom(let message)):
//                    self?.addFailureView(failure: .incorrect_pin)
////                    self?.showAlert(title: "Pin Failed", message: message)
//                    
//                    
//            }
//        }        
    }
    
    func addSuccessView(){
        successView = AlertView(frame: UIScreen.main.bounds)
//        successView.headerText.text = "Successful"
//        successView.headerImage.image = UIImage(named: "success-icon")
        successView.bodyLabel.text = "N\(amountTextField.input.text!) has been sent to \n \(selectedUserTextField.input.text!)"
        successView.continueButton.setTitle("Finish", for: .normal)
        UIApplication.shared.keyWindow!.addSubview(successView)
        self.view.bringSubviewToFront(successView)
//        successView.isUserInteractionEnabled = true
        successView.continueButton.addTarget(self, action: #selector(didTapFinish), for: .touchUpInside)
        
    }
    
    func addFailureView(failure: TransactionError) {
        successView = AlertView(frame: UIScreen.main.bounds)//SuccessView(frame:  )
        successView.mode = .failure(failure)
        successView.continueButton.setTitle("Try Again", for: .normal)
        UIApplication.shared.keyWindow!.addSubview(successView)
        self.view.bringSubviewToFront(successView)
        successView.isUserInteractionEnabled = true
        successView.continueButton.addTarget(self, action: #selector(didTapTryAgain), for: .touchUpInside)
    }
    
    @objc func didTapFinish(){
        self.successView.removeFromSuperview()
        self.successView = nil
        onPayToIDSuccess?()
    }
    
    @objc func didTapTryAgain() {
        self.successView.removeFromSuperview()
        self.successView = nil
    }
    
    func payToPhone(){
//        let sendMoneyToID = SendMoneyToIDRequest(amount: Int(amountTextField.input.text!)!, id: selectedUserTextField.input.text!)
//        walletViewModel.sendMoneyToWayaID(sendMoneyToIDRequest: sendMoneyToID) {[weak self] (result) in
//            switch  result{
//                case .success(let response):
//                    self?.addSuccessView()
//                case .failure(.custom(let message)):
//
////                    print("message \(message)")
////                    guard let message = self?.selectedUserTextField.input.text else {
////                        self?.showAlert(message: "Failed to send money")
////                        return
////                    }
//                    self?.showAlert(message: "Failed to send money to \(message)")
//
//
//            }
//        }
    }
    
    func setTransactionDetailView(){
        self.transactionDetail = TransactionDetail(beneficary: selectedUserTextField.input.text!, amount: amountTextField.input.text!, accountNo: selectedUserTextField.input.text!, transactionFee: amountTextField.input.text!, bank: "Wema", labelTitle: "To", labelValue: selectedUserTextField.input.text!, description: descriptionTextField.input.text ?? "")
    }
    
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        // tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)      
        tableView.isHidden = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: selectedUserTextField.bottomAnchor,constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: selectedUserTextField.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: selectedUserTextField.trailingAnchor).isActive = true
        
        tableView.layer.cornerRadius = 5
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.5
            self.view.bringSubviewToFront(self.tableView)
            self.tableView.isUserInteractionEnabled = true
        }, completion: nil)
        
    }
    
    @objc func removeTransparentView() {
        let frames = selectedUserTextField.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            self.tableView.isHidden = true
        }, completion: nil)
    } 
    
    func fetchContactList(){
        LoadingView.show()
        walletViewModel.findAllContact { [weak self] (result) in
            LoadingView.hide()
            switch result{
                case .success(let response):
                    if let contacts = response as? [FindAllContactsResponse]? {
                        contacts?.forEach({ (wayaContacts) in
                            if let contact = self?.contactViewModel.contacts.first(where: { $0.phone.contains(wayaContacts.phoneNumber)}) {
                                self?.contactViewModel.wayaContacts.appendDistinct(contentsOf: [contact], where: { (old, new) -> Bool in
                                    return old.name != new.name
                                })
                            }
                        })
                    }
                case .failure(.custom(let message)):
                    break
            }
        }
    } 
    
}

extension PayToIDViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchDropdown.removeFromSuperview()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addSubview(searchDropdown)
        NSLayoutConstraint.activate([
            searchDropdown.topAnchor.constraint(equalTo: selectedUserTextField.bottomAnchor, constant: 10),
            searchDropdown.heightAnchor.constraint(equalToConstant: 250),
            searchDropdown.trailingAnchor.constraint(equalTo: selectedUserTextField.trailingAnchor),
            searchDropdown.leadingAnchor.constraint(equalTo: selectedUserTextField.leadingAnchor)
        ])
    }
}

extension PayToIDViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (contactViewModel.filteredContacts.count > 0) ? contactViewModel.filteredContacts.count : contactViewModel.wayaContacts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as? ContactSearchDropdownCell else {
            return UITableViewCell()
        }
        
        cell.contact = (contactViewModel.filteredContacts.count > 0) ? contactViewModel.filteredContacts[indexPath.row] : contactViewModel.wayaContacts[indexPath.row]
        
        return cell
    }
        
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contact", for: indexPath) as? ContactSearchDropdownCell else {
            return
        }
        
        let contact = (self.contactViewModel.filteredContacts.count > 0) ? self.contactViewModel.filteredContacts[indexPath.row] : self.contactViewModel.wayaContacts[indexPath.row]
        cell.contact = contact
//        cell.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
} 


