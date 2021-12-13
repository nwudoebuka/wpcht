//
//  BankDetailViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/12/21.
//

protocol BankDetailView : BaseView {}

class BankDetailViewController: UIViewController, BankDetailView, Alertable {
    
    var bank: BankResponse!
    var viewModel = WalletViewModelImpl()
    var onBackClicked: (() -> Void)?
    
    lazy var topCard: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
        view.layer.shadowColor = Colors.black.cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 2)
        view.layer.shadowOpacity = 0.4
        return view
    }()
    
    lazy var bankLogo: UIImageView = {
       return UIImageView()
    }()
    
    lazy var accountNumber: UILabel = {
        return UI.text(string: "")
    }()
    
    lazy var bankName: UILabel = {
        let txt = UI.text(string: "", style: .bold)
        txt.textAlignment = .right
        return txt
    }()
    
    lazy var accountName: UILabel = {
        let txt = UI.text(string: "", style: .bold)
        txt.textAlignment = .right
        return txt
    }()
    
    lazy var deleteBankButton: UIButton = {
        return UI.button(title: "Delete Bank Account", style: .destructive, state: .active)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Bank Details"
        navigationController?.navigationBar.tintColor = UIColor(named: "toolbar-color-secondary")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        
        let backButton = UIBarButtonItem.init(image: UIImage(named: "back-arrow")!, style: .plain, target: self, action: #selector(back))
        navigationItem.backBarButtonItem = backButton
    }
    
    func setupView() {
        view.backgroundColor = .white
        bankLogo.translatesAutoresizingMaskIntoConstraints = false
        
        let code = UI.text(string: bank.bankCode!, color: .gray)
        code.text = self.bank.bankCode
        topCard.addSubviews([bankLogo, accountNumber, code])
        
        let issuer = UI.text(string: "Issuer bank", color: .gray)
        let account_name = UI.text(string: "Account name", style: .normal, color: .gray)
        view.addSubviews([topCard, issuer, account_name, accountName, bankName, deleteBankButton])
        
        NSLayoutConstraint.activate([
            topCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            topCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            topCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            topCard.heightAnchor.constraint(equalToConstant: 80),
            
            bankLogo.leadingAnchor.constraint(equalTo: topCard.leadingAnchor, constant: 20),
            bankLogo.heightAnchor.constraint(equalToConstant: 50),
            bankLogo.centerYAnchor.constraint(equalTo: topCard.centerYAnchor),
            bankLogo.widthAnchor.constraint(equalToConstant: 50),
            
            accountNumber.leadingAnchor.constraint(equalTo: bankLogo.trailingAnchor, constant: 14),
            accountNumber.topAnchor.constraint(equalTo: topCard.topAnchor, constant: 24),
            
            code.leadingAnchor.constraint(equalTo: accountNumber.leadingAnchor),
            code.topAnchor.constraint(equalTo: accountNumber.bottomAnchor, constant: 3),
            
            issuer.leadingAnchor.constraint(equalTo: topCard.leadingAnchor),
            issuer.topAnchor.constraint(equalTo: topCard.bottomAnchor, constant: 23),
            
            account_name.leadingAnchor.constraint(equalTo: topCard.leadingAnchor),
            account_name.topAnchor.constraint(equalTo: issuer.bottomAnchor, constant: 19),
            
            bankName.trailingAnchor.constraint(equalTo: topCard.trailingAnchor),
            bankName.topAnchor.constraint(equalTo: topCard.bottomAnchor, constant: 23),
            bankName.leadingAnchor.constraint(equalTo: issuer.trailingAnchor, constant: 20),
            
            accountName.trailingAnchor.constraint(equalTo: topCard.trailingAnchor),
            accountName.topAnchor.constraint(equalTo: bankName.bottomAnchor, constant: 19),
            accountName.leadingAnchor.constraint(equalTo: account_name.trailingAnchor, constant: 20),
            
            deleteBankButton.topAnchor.constraint(equalTo: account_name.bottomAnchor, constant: 97),
            deleteBankButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        deleteBankButton.addTarget(self, action: #selector(deleteBank), for: .touchUpInside)
    }
    
    func setData() {
        let offset = self.bank.accountNumber!.length - 3
        bankName.text = self.bank.bankName
        accountName.text = self.bank.accountName
        accountNumber.text = "****** " + self.bank.accountNumber!.substring(offset, 4)
        bankLogo.image = BankLogo(rawValue: self.bank.bankName!)?.image
    }
    
    @objc func back() {
        self.onBackClicked?()
    }
    
    @objc func deleteBank() {
        self.showSimpleTwoOptionAlert(title: "Delete Bank Account", messageTitle: "YES", body: "You are about to delete this bank account from your profile?") {
            LoadingView.show()
            self.viewModel.deleteBankAccount(accountNo: self.bank.accountNumber!) { [weak self] (result) in
                LoadingView.hide()
                switch result {
                case .success(_):
                    self?.showAlert(message: "Bank Account Deleted")
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
                self?.onBackClicked?()
            }
        }
        
        
    }
}
