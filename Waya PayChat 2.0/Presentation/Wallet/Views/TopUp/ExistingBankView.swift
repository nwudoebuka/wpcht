//
//  ExistingBankView.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 02/08/2021.
//

import Foundation
import Signals
import SwiftValidator

class ExistingBankView: UIView, BankTopUp {
    var onError = Signal<(String)>() // -> Void)?
    var allowedBanks: [Bank] = [Bank]()
    var userBanks: [Bank] = [Bank]()
    var onContinue: ((Bank, String) -> Void)?
    private var selectedBank: Bank?
    let validator = Validator()
    
    lazy var selectView: TextInput = {
        let field = UI.textField(placeholder: "Select Bank")
        let image = UIImageView(image: UIImage(named: "drop-down-arrow")!)
        field.input.rightView = image
        field.input.rightViewMode = .always
        field.input.inputView = UIView(frame: .zero)
        return field
    }()
    
    lazy var amountTextField: TextInput = {
        let field =  UI.textField(label: "Top-up Amount", placeholder: "N0.00")
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
        let subLabel = UI.text(string: "Only acceptable bank is accepted for topping / funding wallet")
        subLabel.numberOfLines = 0
        
        self.addSubviews([selectView, subLabel, amountTextField, continueBtn])
        
        selectView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 41, left: 31, bottom: 0, right: 31))
        selectView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        subLabel.anchor(top: selectView.bottomAnchor, leading: selectView.leadingAnchor, bottom: nil, trailing: selectView.trailingAnchor)
        
        amountTextField.anchor(top: subLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 31, bottom: 0, right: 31))
        amountTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        continueBtn.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 31, bottom: 36, right: 31))
        continueBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        validator.registerField(selectView, rules: [RequiredRule()])
        validator.registerField(amountTextField, rules: [RequiredRule()])
        
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
        refresh()
    }
    
    func refresh() {
        dropdown.reloadData()
    }
}

extension ExistingBankView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBanks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropdownCell.identifier) as? DropdownCell else {
            return UITableViewCell()
        }
        cell.title.text = userBanks[indexPath.row].name
        cell.subTitle.text = userBanks[indexPath.row].code
        if let bankLogo = BankLogo(rawValue: userBanks[indexPath.row].name)?.image {
            cell.logo.image = bankLogo
        } else {
            cell.logo.image = UIImage(named: "bank")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBank = userBanks[indexPath.row]
        selectView.input.text = "\(selectedBank!.accountNumber!) - \(selectedBank!.name)"
        selectView.resignFirstResponder()
    }
}

extension ExistingBankView: ValidationDelegate {
    func validationSuccessful() {
        guard let bank = selectedBank else {
            self.onError => "Please select a bank from the list of accepted banks"
            return
        }
        
        let allowed: [String] = allowedBanks.map{ $0.code }
        
        if allowed.contains(bank.code) {
            if let amountDecimal: Decimal = Decimal(string: amountTextField.input.text!), amountDecimal >= 100.0 {
                self.onContinue?(bank, amountTextField.input.text!)
            } else {
                let minimum = "100".currencySymbol!
                self.onError => "Minimum amount is \(minimum)"
            }
        } else {
            self.onError => "Direct debit not supported on this account, please add a supported bank"
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
