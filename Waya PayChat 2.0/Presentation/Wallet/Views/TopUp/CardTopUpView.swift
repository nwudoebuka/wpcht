//
//  CardTopUpView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 02/08/2021.
//

import Foundation
import Signals
import SwiftValidator

class CardTopUpView: UIView, CardTopUp {
    var cards: [CardResponse] = [CardResponse]()
    var onError = Signal<(String)>()
    var model: WalletViewModelImpl!
    var selectedCard: CardResponse? {
        didSet {
            self.toggle()
        }
    }
    var onContinue: Signal<(CardResponse, String)> =  Signal<(CardResponse, String)>()
    let validator = Validator()
    
    private let cardItemTableView : UITableView = {
        let table = UITableView()
        table.register(CustomWalletSubItemTableViewCell.self, forCellReuseIdentifier: CustomWalletSubItemTableViewCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var savedCardLabel: UILabel = {
        let txt = UI.text(string: "Saved card")
        txt.textAlignment = .center
        return txt
    }()
    
    lazy var amountTextField: TextInput = {
        let field =  UI.textField(label: "Top-up Amount", placeholder: "0.00".currencySymbol)
        field.input.keyboardType = .decimalPad
        field.isHidden = true
        return field
    }()
    
    lazy var continueBtn: UIButton = {
        let btn = UI.button(title: "Continue")
        btn.isHidden = true
        return btn
    }()

    convenience init(viewModel: WalletViewModelImpl) {
        self.init(frame: .zero)
        self.model = viewModel
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
        
        self.addSubviews([cardItemTableView, savedCardLabel, amountTextField, continueBtn])

        savedCardLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 27, left: 0, bottom: 0, right: 0))
        
        NSLayoutConstraint.activate([
            cardItemTableView.topAnchor.constraint(equalTo: savedCardLabel.bottomAnchor),
            cardItemTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardItemTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardItemTableView.heightAnchor.constraint(lessThanOrEqualToConstant: 500)
        ])
        
        cardItemTableView.contentInset = UIEdgeInsets(top: 26, left: 16, bottom: -16, right: -16)
        
        cardItemTableView.delegate = self
        cardItemTableView.dataSource = self


        amountTextField.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 10, left: 31, bottom: 0, right: 31))
        amountTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        continueBtn.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 31, bottom: 36, right: 31))
        continueBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        validator.registerField(amountTextField, rules: [RequiredRule()])

        continueBtn.onTouchUpInside.subscribe(with: self) {
            self.validator.validate(self)
        }
    }
    
    func toggle() {
        savedCardLabel.isHidden = (selectedCard == nil) ? false : true
        cardItemTableView.isHidden = (selectedCard == nil) ? false : true
        
        amountTextField.isHidden = (selectedCard == nil) ? true : false
        continueBtn.isHidden = (selectedCard == nil) ? true : false
    }
    
    func refresh() {
        cardItemTableView.reloadData()
    }
}

extension CardTopUpView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  cardItemTableView.dequeueReusableCell(withIdentifier: CustomWalletSubItemTableViewCell.identifier) as! CustomWalletSubItemTableViewCell
        let cardNumberText = "**** " + cards[indexPath.row].cardNumber.getLastFew(range: 4)
        
        let cardExpireText = cards[indexPath.row].expiryMonth + "/" + cards[indexPath.row].expiryYear.getLastFew(range: 2)
        let cardLogo = CardUtils.cardTypeImage(prefix: cards[indexPath.row].cardNumber.getFirstFew(range: 4))
        
        cell.selectionStyle = .none
        cell.configureCell(headerTitle: cardNumberText, subHeaderTitle: cardExpireText, logo: cardLogo)
        cell.isUserInteractionEnabled = true
        cell.imageView?.image = cardLogo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCard = cards[indexPath.row]
    }
}

extension CardTopUpView: ValidationDelegate {
    func validationSuccessful() {
        guard let card = selectedCard else {
            self.onError => "Invalid card selected"
            return
        }
        if let amountDecimal: Decimal = Decimal(string: amountTextField.input.text!), amountDecimal >= 100.0 {
            self.onContinue => (card, amountTextField.input.text!)
        } else {
            self.onError => "Minimum amount is \(amountTextField.input.text!.currencySymbol!)"
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
