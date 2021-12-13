//
//  AddBankViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/12/21.
//
import Signals

protocol AddBankView : BaseView{
    var onComplete: (() -> Void)? { get set}
}

final class AddBankViewController: UIViewController , AddBankView, Alertable{


    var banks : [Bank] = []
    var selectedBank : Bank?
    var walletViewModel = WalletViewModelImpl()
    var onComplete: (() -> Void)?

    let transparentView = UIView()
    let tableView = UITableView()
    var alertView: AlertView?
    
    var toolbar  : CustomToolbar = {
        let toolbar = CustomToolbar()
        toolbar.backButton.setImage(UIImage(named: "back-arrow"), for: .normal)
        toolbar.titleLabel.text = "Add Bank Account"
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }()
    
    
    lazy var selectBankDropDownButton : TextInput = {
        let field = UI.textField(placeholder: "Select Bank")
        let image = UIImageView(image: UIImage(named: "drop-down-arrow")!)
        field.input.rightView = image
        field.input.rightViewMode = .always
        field.input.inputView = UIView()
        return field
    }()
    
    var accountNumberTextField : TextInput = {
        return UI.textField(placeholder: "Account Number")
    }()
    
    var accountNameTextField : TextInput = {
        let field = UI.textField(placeholder: "Account Name")
        field.isUserInteractionEnabled = false
        return field
    }()
    
    lazy var addBankButton : UIButton = {
        let button  = UI.button(title: "Add Bank Account")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getBanks()
    }
    
    func setUpView() {
        
        view.addSubviews([toolbar, selectBankDropDownButton, accountNumberTextField, accountNameTextField,addBankButton])
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 50),
            
            selectBankDropDownButton.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 50),
            selectBankDropDownButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            selectBankDropDownButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            selectBankDropDownButton.heightAnchor.constraint(equalToConstant: 60),
            
            accountNumberTextField.topAnchor.constraint(equalTo: selectBankDropDownButton.bottomAnchor, constant: 10),
            accountNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            accountNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            accountNumberTextField.heightAnchor.constraint(equalToConstant: 60),
            
            accountNameTextField.topAnchor.constraint(equalTo: accountNumberTextField.bottomAnchor, constant: 10),
            accountNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            accountNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            accountNameTextField.heightAnchor.constraint(equalToConstant: 60),
            
            addBankButton.topAnchor.constraint(equalTo: accountNameTextField.bottomAnchor, constant: 72),
            addBankButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            addBankButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            addBankButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        toolbar.backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        selectBankDropDownButton.input.onEditingDidBegin.subscribe(with: self) {_ in
            self.addTransparentView(frames: self.selectBankDropDownButton.frame)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DropdownCell.self, forCellReuseIdentifier: DropdownCell.identifier)
        
        accountNumberTextField.input.addTarget(self, action: #selector(accountListener(_:)), for: .editingChanged)
        accountNameTextField.input.addTarget(self, action: #selector(accountListener(_:)), for: .editingChanged)
        addBankButton.isEnabled = false
        addBankButton.alpha = 0.3
        
        accountNumberTextField.input.keyboardType = .numberPad
        addBankButton.addTarget(self, action: #selector(addBankToServer), for: .touchUpInside)
    }
    
    private func getBanks(){
        LoadingView.show()
        walletViewModel.getAllBanks { [weak self] (result) in
            LoadingView.hide()
            switch result{
                case .success(let response):
                    if let banks = response as? [Bank]{
                        self?.banks =  banks
                        self?.tableView.reloadData()
                    }
                case .failure(.custom(let message)):
                    print("error getting banks: \(message)")
            }
        }
    }
    
    func resolveBank(){
        LoadingView.show()    
        walletViewModel.resolveAccountRequest.accountNumber = accountNumberTextField.input.text ?? ""
        walletViewModel.resolveAccountRequest.bankCode = walletViewModel.addBankAccountReq.bankCode
        walletViewModel.resolveAccountNumber(resolveAccountRequest: walletViewModel.resolveAccountRequest) {[weak self] (result) in
            LoadingView.hide()
            switch result{
                case .success(let response):
                    if let response_ = response as? BankResolveResponse{
                        print("It success")
                        self?.walletViewModel.addBankAccountReq.accountNumber = response_.accountNumber
                        self?.walletViewModel.addBankAccountReq.accountName = response_.accountName
                        self?.accountNameTextField.input.text = response_.accountName
                        self?.addBankButton.isEnabled = true
                        self?.addBankButton.alpha = 1.0
                    }
                     
                case .failure(.custom(let message)) :
                    print("message")
                    self?.walletViewModel.addBankAccountReq.accountNumber = ""
                    self?.showAlert(message: "Please enter a valid account number")
            }
        }
    }
    
   @objc func addBankToServer(){
        LoadingView.show()    
    walletViewModel.addBankAccountReq.userId = String(auth.data.userId!)
        walletViewModel.addBankAccount(addBankAccountReq: walletViewModel.addBankAccountReq) { [weak self](result) in
            LoadingView.hide()
            switch result{
                case .success(_):
                    if let kyc = auth.data.completedKyc, !kyc.contains(.accountLinked) {
                        auth.data.completedKyc!.append(.accountLinked)
                        auth.updateLocalPrefs()
                    }
                    self?.showAddSuccess()
                case .failure(.custom(let message)):
                    self?.showAlert(message: message)
            }
        }
    }
    
    @objc func didTapBackButton(){
        self.onComplete?()
    }
    
    @objc func accountListener(_ sender: UITextField){
        switch sender {
            case accountNumberTextField.input:
                if let count = sender.text?.count, count > 0{
                    if selectedBank == nil{
                        sender.text = ""
                        showAlert(message: "Please select a bank")
                    }
                }
                if let count = sender.text?.count , count == 10{
                    walletViewModel.resolveAccountRequest.accountNumber = sender.text ?? ""
                    view.endEditing(true)
                    resolveBank()
                }else if let count = sender.text?.count , count > 10 {
                    sender.text = sender.text?.substring(0, 10)
                }
            case accountNameTextField.input :
                if  let count = sender.text?.count, count > 0,  let count2 = accountNumberTextField.input.text?.count , count2 < 10 {
                    sender.text = ""
                    showAlert(message: "Please type a valid account number")
                }
            default:
                break
        }
      
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
       // tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)      
        tableView.isHidden = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: selectBankDropDownButton.bottomAnchor,constant: 5).isActive = true
        tableView.leadingAnchor.constraint(equalTo: selectBankDropDownButton.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        tableView.trailingAnchor.constraint(equalTo: selectBankDropDownButton.trailingAnchor).isActive = true

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
        let frames = selectBankDropDownButton.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
            self.tableView.isHidden = true
        }, completion: nil)
    }
    
    private func showAddSuccess() {
        guard alertView == nil else {
           return
        }
        alertView = AlertView(frame: UIScreen.main.bounds, title: "Account Verified", mode: .success(.generic))
        alertView?.backgroundColor = .white
        alertView?.continueButton.setTitle("Finish", for: .normal)
        alertView?.continueButton.onTouchUpInside.subscribe(with: self) {
            self.alertView?.removeFromSuperview()
            self.alertView = nil
            self.onComplete?()
        }
       
        UIApplication.shared.keyWindow!.addSubview(alertView!)
        self.view.bringSubviewToFront(alertView!)
        alertView?.isUserInteractionEnabled = true
    }
}

extension AddBankViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return banks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DropdownCell.identifier) as? DropdownCell else {
            return UITableViewCell()
        }
        cell.title.text = banks[indexPath.row].name
        cell.subTitle.text = banks[indexPath.row].code
        
        if let bankLogo = BankLogo(rawValue: banks[indexPath.row].name)?.image {
            cell.logo.image = bankLogo
        } else {
            cell.logo.image = UIImage(named: "bank")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBank = banks[indexPath.row]
        walletViewModel.addBankAccountReq.bankCode = selectedBank!.code
        walletViewModel.addBankAccountReq.bankName = selectedBank!.name
        selectBankDropDownButton.input.text = selectedBank!.name
        removeTransparentView()
    } 
    
} 
