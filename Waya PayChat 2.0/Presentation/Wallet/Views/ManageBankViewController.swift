//
//  ManageBankViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/12/21.
//

protocol ManageBankView  : BaseView {
    var goToAddBank : (() -> Void)?{ get set }
    var gotToShowBankDetails: ((BankResponse) -> Void)? { get set}
}

class ManageBankViewController: UIViewController, ManageBankView, Alertable {

    var goToAddBank : (() -> Void)?
    var gotToShowBankDetails: ((BankResponse) -> Void)?
    
    private let bankTableView : UITableView = {
        let table = UITableView()
        table.register(CustomWalletSubItemTableViewCell.self, forCellReuseIdentifier: CustomWalletSubItemTableViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.backgroundColor = .white
        table.rowHeight = 80
        return table
    }()
    
    var isEmpty = true
    
    var walletViewModel = WalletViewModelImpl()
    
    var backgroundImage : UIImageView = {
        let imageV = UIImageView()
        let targetSize = CGSize(width: 105, height: 126)
        imageV.image = UIImage(named: "empty-manage-bank")
        
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var emptyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textColor = UIColor(named: "dark-gray")
        label.text = "Your bank account \n section looks empty"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let addBankButton : UIButton = {
        let button = UI.button(title: "Add Bank Account")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNav()
        setUpTableView()
        setUpView()
        setViewsVisibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserBank()
    }
    
    private func setUpView(){
        view.addSubview(backgroundImage)
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        
        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 32).isActive = true
        
        view.addSubview(addBankButton)
        addBankButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        addBankButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        addBankButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        addBankButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        addBankButton.addTarget(self, action: #selector(showAddBank), for: .touchUpInside)
    }
    
    private func setViewsVisibility(){
        backgroundImage.isHidden = !isEmpty
        emptyLabel.isHidden = !isEmpty
        addBankButton.isHidden = !isEmpty
        
        bankTableView.isHidden = isEmpty
    }
    
    
    private func getUserBank(){
        LoadingView.show()
        walletViewModel.getUserBankAccounts() { [weak self] (_ response: ResponseList<BankResponse>?, error) in
            LoadingView.hide()
            if let banks = response?.data {
                auth.data.accounts?.banks = banks
                if let count = self?.walletViewModel.bankResponse.count, count > 0{
                        self?.isEmpty = false
                        self?.setViewsVisibility()
                        self?.bankTableView.reloadData()
                }
                return
            }
        }
    }

    private func setUpNav(){
        title = "Manage Bank Accounts"
        navigationController?.navigationBar.tintColor = UIColor(named: "toolbar-color-secondary")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        
        let  rightBarButton = UIBarButtonItem.init(image: UIImage(named: "add-bank-icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showAddBank))
        
        navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc func showAddBank(){
        self.goToAddBank?()
    }
    
    private func setUpTableView(){
        bankTableView.dataSource = self
        bankTableView.delegate = self
        view.addSubview(bankTableView)
        bankTableView.backgroundColor = .white
        bankTableView.separatorStyle = .none
        bankTableView.separatorColor = .clear
        bankTableView.translatesAutoresizingMaskIntoConstraints = false
        bankTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26).isActive  = true
        bankTableView.backgroundColor = .clear
        bankTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        bankTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        bankTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        bankTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        bankTableView.sectionIndexColor = .white
    }

}

extension ManageBankViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletViewModel.bankResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  bankTableView.dequeueReusableCell(withIdentifier: CustomWalletSubItemTableViewCell.identifier) as! CustomWalletSubItemTableViewCell
        cell.selectionStyle = .none
        let logo = BankLogo(rawValue: walletViewModel.bankResponse[indexPath.row].bankName!)?.image
        cell.configureCell(headerTitle: walletViewModel.bankResponse[indexPath.row].accountNumber!, subHeaderTitle: walletViewModel.bankResponse[indexPath.row].bankCode ?? "N/A", logo: logo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.deleteBank(number: self.walletViewModel.bankResponse[indexPath.row].accountNumber!)
        }

        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
    
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bank = walletViewModel.bankResponse[indexPath.row]
        self.gotToShowBankDetails?(bank)
    }
    
    func deleteBank(number: String) {
        LoadingView.show()
        self.walletViewModel.deleteBankAccount(accountNo: number) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self.showAlert(message: "Account Deleted")
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
            self.bankTableView.reloadData()
        }
    }
    
}


