//
//  NewBankView.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 02/08/2021.
//

import Foundation
import Signals
import SwiftValidator

class NewBankView: UIView, BankTopUp {
    var onError = Signal<(String)>() 
    var allowedBanks: [Bank] = [Bank]()
    var userBanks: [Bank] = [Bank]()
    var onContinue: ((Bank, String) -> Void)?
    var selectedBank: Bank?
    var filtered = [Bank]()
    let validator = Validator()
    var model: WalletViewModelImpl!
    
    lazy var selectView: TextInput = {
        let field = UI.textField(placeholder: "Select Bank")
        let image = UIImageView(image: UIImage(named: "drop-down-arrow")!)
        field.input.rightView = image
        field.input.rightViewMode = .always
        return field
    }()
    
    lazy var accountNumberField: TextInput = {
        let field = UI.textField(placeholder: "Account Number")
        field.input.keyboardType = .numberPad
        return field
    }()
    
    lazy var accountNameTextField: TextInput = {
        let field = UI.textField(placeholder: "Account Name")
        field.isUserInteractionEnabled = false
        return field
    }()
    
    lazy var amountTextField: TextInput = {
        let field =  UI.textField(label: "Top-up Amount", placeholder: "0.00".currencySymbol!)
        field.input.keyboardType = .decimalPad
        return field
    }()
    
    lazy var continueBtn: UIButton = {
        return UI.button(title: "Continue")
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
    
    convenience init(model: WalletViewModelImpl) {
        self.init(frame: .zero)
        self.model = model
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hideKeyboardWhenTappedAround()
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        let subLabel = UI.text(string: "Only acceptable bank is accepted for topping/funding wallet")
        subLabel.numberOfLines = 0
        
        self.addSubviews([selectView, subLabel, accountNumberField, accountNameTextField, amountTextField, continueBtn])
        
        selectView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 41, left: 31, bottom: 0, right: 31))
        selectView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        subLabel.anchor(top: selectView.bottomAnchor, leading: selectView.leadingAnchor, bottom: nil, trailing: selectView.trailingAnchor)
        
        accountNumberField.anchor(top: subLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 17, left: 31, bottom: 0, right: 31))
        accountNumberField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        accountNameTextField.anchor(top: accountNumberField.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 20, left: 31, bottom: 0, right: 31))
        accountNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        amountTextField.anchor(top: accountNameTextField.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 31, bottom: 0, right: 31))
        amountTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        continueBtn.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 31, bottom: 36, right: 31))
        continueBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        validator.registerField(accountNumberField, errorLabel: accountNumberField.errorLabel, rules: [RequiredRule(), NumericRule()])
        validator.registerField(accountNameTextField, errorLabel: accountNameTextField.errorLabel, rules: [RequiredRule()])
        validator.registerField(amountTextField, errorLabel: amountTextField.errorLabel, rules: [RequiredRule()])
        
        accountNumberField.input.onEditingChanged.subscribe(with: self) { () in
            if self.accountNumberField.text.length == 10 {
                self.accountNumberField.resignFirstResponder()
                self.resolveAccountNumber()
            }
        }
        
        selectView.input.onEditingDidBegin.subscribe(with: self) { () in
            self.addDropdown()
        }
        
        selectView.input.onEditingDidEnd.subscribe(with: self) { () in
            self.dropdown.removeFromSuperview()
        }
        
        continueBtn.onTouchUpInside.subscribe(with: self) { () in
            self.validator.validate(self)
        }
    }
    
    @objc func filterBanks() {
        guard selectView.text.length > 5 else {
            return
        }
        let text = selectView.text
        filtered = allowedBanks.filter { $0.name.contains(text) }
        dropdown.reloadData()
    }
    
    private func addDropdown() {
        addSubview(dropdown)
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        dropdown.clipsToBounds = false
        NSLayoutConstraint.activate([
            dropdown.topAnchor.constraint(equalTo: selectView.bottomAnchor),
            dropdown.leadingAnchor.constraint(equalTo: selectView.leadingAnchor),
            dropdown.trailingAnchor.constraint(equalTo: selectView.trailingAnchor),
            dropdown.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        self.bringSubviewToFront(dropdown)
        dropdown.reloadData()
    }
    
    private func resolveAccountNumber() {
        guard let selected = selectedBank else {
            return
        }
        LoadingView.show()
        let req = ResolveAccountRequest(accountNumber: accountNumberField.input.text!, bankCode: selected.code)
        model.resolveAccountNumber(resolveAccountRequest: req) { (result) in
            LoadingView.hide()
            switch result {
            case .success(let response):
                if let account = response as? BankResolveResponse{
                    print("It success")
                    self.accountNameTextField.input.text = account.accountName
                    self.selectedBank?.accountName = account.accountName
                }
            case .failure(.custom(let message)) :
                self.onError => message
            }
        }
    }
    
    func refresh() {
        dropdown.reloadData()
    }
}

extension NewBankView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (filtered.count > 0) ? filtered.count : allowedBanks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropdownCell.identifier) as? DropdownCell else {
            return UITableViewCell()
        }
        if filtered.count > 0 {
            cell.title.text = filtered[indexPath.row].name
            cell.subTitle.text = filtered[indexPath.row].code
            if let bankLogo = BankLogo(rawValue: filtered[indexPath.row].name)?.image {
                cell.logo.image = bankLogo
            } else {
                cell.logo.image = UIImage(named: "bank")
            }
            return cell
        } else {
            cell.textLabel?.text = allowedBanks[indexPath.row].name
            cell.detailTextLabel?.text = allowedBanks[indexPath.row].code
            if let bankLogo = BankLogo(rawValue: allowedBanks[indexPath.row].name)?.image {
                cell.logo.image = bankLogo
            } else {
                cell.logo.image = UIImage(named: "bank")
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBank = (filtered.count > 0) ? filtered[indexPath.row] : allowedBanks[indexPath.row]
        selectView.input.text = (filtered.count > 0) ? filtered[indexPath.row].name : allowedBanks[indexPath.row].name
        selectView.resignFirstResponder()
    }
}

extension NewBankView: ValidationDelegate {
    func validationSuccessful() {
        guard var bank = selectedBank else {
            self.onError => ("Please select a valid bank")
            return
        }
        bank.accountNumber = accountNumberField.input.text!
        bank.accountName = accountNameTextField.input.text!
        if let amountDecimal: Decimal = Decimal(string: amountTextField.input.text!), amountDecimal >= 100.0 {
            self.onContinue?(bank, amountTextField.input.text!)
        } else {
            self.onError => ("Minimum amount is \(amountTextField.input.text!.currencySymbol!)")
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            guard let field = field as? TextInput else {
                return
            }
            field.errorLabel.text = error.errorMessage
            field.errorLabel.isHidden = false
        }
    }
}
