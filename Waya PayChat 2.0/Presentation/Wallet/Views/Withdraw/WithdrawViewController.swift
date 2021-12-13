//
//  WithdrawViewController.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 09/08/2021.
//

import UIKit
import SwiftValidator

protocol WithdrawView : BaseView {
    var onExit: (() -> Void)? { get set }
}

class WithdrawViewController: UIViewController , WithdrawView, Alertable {

    var walletViewModel : WalletViewModelImpl!
    var bankAccounts: [Bank] = [Bank]()
    private var selectedBank: Bank?
    private var selectedWallet: UserWalletResponse!
    
    var transactionDetail: TransactionDetail!
    var transactionDetailView : TransactionDetailView!
    var successView: AlertView!
    var onExit: (() -> Void)?
    var request: WithdrawalRequest!
    let validator = Validator()
    var mode: WithdrawMode!
    
    lazy var selectView: TextInput = {
        let field = UI.textField(placeholder: "Select Bank")
        let image = UIImageView(image: UIImage(named: "drop-down-arrow")!)
        field.input.rightView = image
        field.input.rightViewMode = .always
        field.input.inputView = UIView()
        return field
    }()
    
    lazy var accountNameField: TextInput = {
        let txt = UI.textField(placeholder: "Account Name")
        txt.input.isUserInteractionEnabled = false
        return txt
    }()
    
    lazy var accountNumberField: TextInput = {
        return UI.textField(placeholder: "Account Number")
    }()
    
    lazy var walletField: TextInput = {
        let field = UI.textField(placeholder: "Select Wallet")
        let image = UIImageView(image: UIImage(named: "drop-down-arrow")!)
        field.input.rightView = image
        field.input.rightViewMode = .always
        field.input.inputView = UIView()
        return field
    }()
    
    lazy var descriptionText: TextInput = {
        return UI.textField(placeholder: "Add a note (optional)")
    }()
    
    lazy var amountField: TextInput = {
        let field = UI.textField(label: "Amount", placeholder: "0.00".currencySymbol!)
        field.input.keyboardType = .decimalPad
        return field
    }()
    
    lazy var continueBtn: UIButton = {
        return UI.button(title: "Continue", icon: nil, style: .primary, state: .active)
    }()
    
    lazy var dropDownView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var dropdown: UITableView = {
        let view = UITableView(frame: .zero)
        view.separatorStyle = .none
        view.backgroundColor = .white
        view.layer.borderWidth = 0.3
        view.delegate = self
        view.dataSource = self
        view.register(DropdownCell.self, forCellReuseIdentifier: DropdownCell.identifier)
        return view
    }()
    
    let walletPicker = UIPickerView()
    
    init(walletViewModel : WalletViewModelImpl, mode: WithdrawMode) {
        self.walletViewModel = walletViewModel
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init \(coder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = (self.mode == .new) ? "Withdraw to New Bank Account" : "Withdraw to Saved Bank Account"
        navigationController?.navigationBar.tintColor = UIColor(named: "toolbar-color-secondary")
//        navi
        self.setup()
        fetchAccounts()
        hideKeyboardWhenTappedAround()
    }
    
    private func setup() {
        view.addSubviews([selectView, accountNumberField, accountNameField, amountField, descriptionText, continueBtn, walletField, dropDownView])
        
        selectView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 47, left: 31, bottom: 0, right: 31))
        selectView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        accountNameField.anchor(top: selectView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 27, left: 31, bottom: 0, right: 31))
        accountNameField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        accountNumberField.anchor(top: accountNameField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 27, left: 31, bottom: 0, right: 31))
        accountNumberField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        descriptionText.anchor(top: accountNumberField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 27, left: 31, bottom: 0, right: 31))
        descriptionText.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        walletField.anchor(top: descriptionText.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 27, left: 31, bottom: 0, right: 31))
        walletField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        amountField.anchor(top: walletField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 27, left: 31, bottom: 0, right: 31))
        amountField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        
        continueBtn.anchor(top: amountField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 72, left: 32, bottom: 0, right: 31))
        continueBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.clipsToBounds = false
        dropDownView.anchor(top: selectView.bottomAnchor, leading: selectView.leadingAnchor, bottom: nil, trailing: selectView.trailingAnchor)
        dropDownView.heightAnchor.constraint(equalToConstant: 230).isActive = true
        self.view.bringSubviewToFront(dropDownView)
        dropDownView.isHidden = true
        
        self.dropDownView.addSubview(dropdown)
        dropdown.anchor(top: dropDownView.topAnchor, leading: dropDownView.leadingAnchor, bottom: dropDownView.bottomAnchor, trailing: dropDownView.trailingAnchor)
        dropdown.clipsToBounds = true
        
        selectView.input.onEditingDidBegin.subscribe(with: self) { () in
            self.dropDownView.isHidden = false
        }
        
        selectView.input.onEditingDidEnd.subscribe(with: self) { () in
            self.dropDownView.isHidden = true
        }
        
        walletPicker.dataSource = self
        walletPicker.delegate = self
        
        walletField.input.inputView = walletPicker
        walletField.addToolbar()
        
        continueBtn.onTouchUpInside.subscribe(with: self) { () in
            self.validator.validate(self)
        }
        
        accountNumberField.input.onEditingChanged.subscribe(with: self) { () in
            if self.accountNumberField.text.length == 10 {
                self.accountNumberField.resignFirstResponder()
                self.resolveAccountNumber()
            }
        }
        
        validator.registerField(accountNameField, errorLabel: accountNameField.errorLabel, rules: [RequiredRule()])
        validator.registerField(amountField, errorLabel: amountField.errorLabel, rules: [RequiredRule()])
        validator.registerField(accountNumberField, errorLabel: accountNumberField.errorLabel, rules: [RequiredRule()])
        validator.registerField(walletField, rules: [RequiredRule()])
        self.dropdown.reloadData()
        walletPicker.reloadAllComponents()
        //        getAccounts()
    }
    
    private func fetchAccounts() {
        switch self.mode {
        case .new:
            self.getBanks()
        case .saved:
            guard let allBanks = auth.data.accounts?.banks?.compactMap({ Bank(name: $0.bankName!, code: $0.bankCode!, accountNumber: $0.accountNumber!, accountName: $0.accountName!) }) else {
                return
            }
            self.bankAccounts = allBanks.filter({ $0.name.range(of: "rubies", options: .caseInsensitive) == nil})
            self.dropdown.reloadData()
        case .beneficiary:
            loadBeneficiaryList()
        default:
            break
        }
        
    }
    
    private func loadBeneficiaryList() {
        LoadingView.show()
        walletViewModel.getBeneficiaries { (result) in
            LoadingView.hide()
            switch result {
            case .success(let beneficiaries):
                guard let beneficiaries = beneficiaries as? [BankBeneficiary] else {
                    return
                }
                self.bankAccounts = beneficiaries.map({ $0.bankInfo() }).filter({ $0.name.range(of: "rubies", options: .caseInsensitive) == nil })
                self.dropdown.reloadData()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func getBanks() {
        LoadingView.show()
        walletViewModel.getAllBanks { [weak self] (result) in
            LoadingView.hide()
            switch result{
                case .success(let response):
                    if let banks = response as? [Bank] {
                        self?.bankAccounts = banks.filter({ $0.name.range(of: "rubies", options: .caseInsensitive) == nil}) // user can withdraw to any bank except rubies bank.
                        self?.dropdown.reloadData()
                    }
                case .failure(.custom(let message)):
                    print(message)
            }
        }
    }
    
    private func setTransactionDetail(bank: Bank, amount: String) {
        self.transactionDetail = TransactionDetail(
            beneficary: bank.accountName!,
            amount: amount,
            accountNo: bank.accountNumber!,
            transactionFee: "10.00".currencySymbol!,
            bank: bank.name, labelTitle: "Account Number",
            labelValue: bank.accountNumber!,
            description: descriptionText.text
        )
    }
    
    private func resolveAccountNumber() {
        guard let selected = selectedBank else {
            return
        }
        LoadingView.show()
        let req = ResolveAccountRequest(accountNumber: accountNumberField.input.text!, bankCode: selected.code)
        self.walletViewModel.resolveAccountNumber(resolveAccountRequest: req) { (result) in
            LoadingView.hide()
            switch result {
            case .success(let response):
                if let bank = response as? BankResolveResponse{
                    self.accountNameField.input.text = bank.accountName
                    self.selectedBank?.accountName = bank.accountName
                    self.selectedBank?.accountNumber = self.accountNumberField.text
                }
            case .failure(.custom(let message)):
                self.showAlert(message: message)
            }
        }
    }
    
    private func showTransactionDetail() {
        if let kyc = auth.data.completedKyc, !kyc.contains(.bvnLinked) {
            self.transactionDetailView = TransactionDetailView(frame: self.view.frame, transactionDetail: self.transactionDetail, alertType: .info, warningLabel: "You need to Link your BVN to complete\nyour withdrawal process")
        } else {
            self.transactionDetailView = TransactionDetailView(frame: self.view.frame, transactionDetail: self.transactionDetail)
        }
        transactionDetailView.translatesAutoresizingMaskIntoConstraints = false
        transactionDetailView.source = .bank(.existing)
        
        view.addSubview(transactionDetailView)
        transactionDetailView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        self.view.bringSubviewToFront(transactionDetailView)
        transactionDetailView.confirmButton.onTouchUpInside.subscribe(with: self) {

            if self.transactionDetailView.otpStackView.getOTP().length == 4 {
                self.processWithDrawal()
            } else {
                self.showAlert(message: "Invalid PIN entered")
            }
        }
    }
    
    private func validatePinAndContinue() {
        LoadingView.show()
        let authViewModel = AuthViewModelImpl()
        let pin = self.transactionDetailView.otpStackView.getOTP()
        authViewModel.pinVerified.subscribeOnce(with: self) {[weak self] (verified, error) in
            LoadingView.hide()
            guard verified == true else {
                self?.addFailureView(failure: .incorrect_pin)
                return
            }
            self?.withdraw()
        }
        authViewModel.validateUserPin(pin: pin)
    }
    
    private func processWithDrawal() {
        
        let amount = self.amountField.text
        
        if selectedWallet.balance < Decimal(string: amount)! {
            transactionDetailView.showWarning(type: .error, text: "Transaction failed, Insufficient fund!")
            return
        }
        
        if Decimal(string: amountField.text)! >= 100.0 {
            let pin = self.transactionDetailView.otpStackView.getOTP()
            let request = WithdrawalRequest(
                amount: amountField.text,
                bankCode: selectedBank!.code,
                bankName: selectedBank!.name,
                crAccount: selectedBank!.accountNumber!,
                crAccountName: selectedBank!.accountName!,
                narration: descriptionText.text,
                saveBen: false,
                transactionPin: pin,
                userId: String(auth.data.userId!),
                walletAccountNo: self.selectedWallet.accountNo
            )
            self.request = request
            self.validatePinAndContinue()
        } else {
            let min_amount = "100.00".currencySymbol!
            transactionDetailView.showWarning(type: .error, text: "You cannot withdraw less than \(min_amount)")
            return
        }
    }
    
    var withdrawing = false
    private func withdraw() {
        guard withdrawing == false else {
            return
        }
        withdrawing = true
        LoadingView.show()
        walletViewModel.withdrawToBank(request: self.request) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self.showSuccess()
            case .failure(let error):
                self.transactionDetailView.showWarning(type: .warning, text: "Transaction failed,  \(error.localizedDescription)")
            }
            self.withdrawing = false
        }
    }
    
    private func showSuccess() {
        successView = AlertView(frame:  UIScreen.main.bounds)
        successView.mode = .success(.withdrawal)
        successView.headerText.text = "Withdrawal Successful"
        successView.bodyLabel.text = "\(amountField.text.currencySymbol!) has been withdrawn to"
        successView.bodyDetail.text = String(format: "%@ \n %@/%@", accountNameField.text, accountNumberField.text, selectView.text)
        successView.bodyDetail.isHidden = false
        
        UIApplication.shared.keyWindow!.addSubview(successView)
        self.view.bringSubviewToFront(successView)
        successView.isUserInteractionEnabled = true
        successView.continueButton.setTitle("Finish", for: .normal)
        successView.onContinue = { (save) in
            if save == true {
                let beneficiary = BankBeneficiary(
                    id: 0,
                    name: self.selectedBank!.accountName!,
                    bankCode: self.selectedBank!.code,
                    bankName: self.selectedBank!.name,
                    branchCode: self.selectedBank!.code,
                    accountNumber: self.selectedBank!.accountNumber!,
                    userId: String(auth.data.userId!),
                    alias: self.selectedBank!.accountName!)
                self.walletViewModel.saveBeneficiary(account: beneficiary)
            }
            self.successView.removeFromSuperview()
            self.onExit?()
        }
    }
    
    
    private func addFailureView(failure: TransactionError) {
        successView = AlertView(frame:  UIScreen.main.bounds)
        successView.mode = .failure(failure)
        successView.headerText.text = "Withdrawal Failed"
        successView.bodyLabel.text = failure.message // "Your withdrawal could not be completed"
        UIApplication.shared.keyWindow!.addSubview(successView)
        self.view.bringSubviewToFront(successView)
        successView.isUserInteractionEnabled = true
        successView.continueButton.onTouchUpInside.subscribe(with: self) { () in
            self.successView.removeFromSuperview()
        }
        successView.onHome = { [weak self] in
            self?.successView.removeFromSuperview()
            self?.onExit?()
        }
    }
}

extension WithdrawViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankAccounts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropdownCell.identifier, for: indexPath) as? DropdownCell else {
            return UITableViewCell()
        }
        cell.setup()
        
        if bankAccounts.count > 0 {
            let bank = bankAccounts[indexPath.row]
            cell.title.text = bank.name
            cell.subTitle.text = bank.code
            if let bankLogo = BankLogo(rawValue: bank.name)?.image {
                cell.logo.image = bankLogo
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bank = bankAccounts[indexPath.row]
        selectView.input.text = bank.name
        accountNameField.input.text = bank.accountName
        accountNumberField.input.text  = bank.accountNumber
        selectedBank = bank
    }
}

extension WithdrawViewController: ValidationDelegate {
    func validationSuccessful() {
        guard selectedBank != nil, selectedWallet != nil else {
            self.showAlert(message: "Please select a bank account and a debit wallet")
            return
        }
        setTransactionDetail(bank: selectedBank!, amount: amountField.text)
        showTransactionDetail()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            guard let field = field as? TextInput else {
                return
            }
            field.errorLabel.isHidden = false
            field.errorLabel.text = error.errorMessage
        }
    }
}

extension WithdrawViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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
        walletField.input.text = self.selectedWallet.accountNo
        walletField.errorLabel.text = "\(self.selectedWallet.balance)".currencySymbol!
        walletField.errorLabel.isHidden = false
        walletField.errorLabel.font = UIFont(name: "Lato-Regular", size: 13)?.semibold
        walletField.errorLabel.textColor = .black
    }
}
