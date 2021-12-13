//
//  ManageWalletViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/12/21.
//

protocol ManageWalletView : BaseView{
    var onAddWalletSuccessful : (() -> Void)?{ get set }
    var goToWalletDetail : (()-> Void)?{get set}
    
}

class ManageWalletViewController: UIViewController , ManageWalletView, Alertable {

    var onAddWalletSuccessful : (() -> Void)?
    var goToWalletDetail : (()-> Void)?
    var transparentBackground : UIView!
    var popUpView : WalletPinPopView!
    var walletViewModel = WalletViewModelImpl() 
    
    private let walletItemTableView : UITableView = {
        let table = UITableView()
        table.register(CustomWalletSubItemTableViewCell.self, forCellReuseIdentifier: CustomWalletSubItemTableViewCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = .white
        table.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right:  0)
        table.rowHeight = 90
        return table
    }()
    
    var successView : AlertView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNav()
        setUpTableView()
        fetchUserWallet()
    }
    
    private func setUpNav(){
        title = "Manage Wallet"
        navigationController?.navigationBar.tintColor = UIColor(named: "toolbar-color-secondary")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        
        let  rightBarButton = UIBarButtonItem.init(image: UIImage(named: "add-bank-icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showAddWallet))
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func showAddWallet(){ 
        self.showSimpleTwoOptionAlert(title: "Create New Wallet Account", messageTitle: "CONTINUE", body: "Are you sure you want to create \n another wallet account?", action: { [weak self] in
            self?.showInputPinView()
        })
    }
    
    private func showInputPinView(){
        if self.transparentBackground == nil{
            self.transparentBackground = UIView(frame: UIScreen.main.bounds)
            self.transparentBackground.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAddWalletPopUp(_:)))
            tap.numberOfTapsRequired = 1
            self.transparentBackground.addGestureRecognizer(tap)
            self.transparentBackground.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.addSubview(self.transparentBackground)
            
            popUpView = setUpPopView()
            popUpView.translatesAutoresizingMaskIntoConstraints = false
            transparentBackground.addSubview(popUpView)
            popUpView.centerYAnchor.constraint(equalTo: transparentBackground.centerYAnchor).isActive = true
            popUpView.trailingAnchor.constraint(equalTo: transparentBackground.trailingAnchor, constant: -15).isActive = true
            popUpView.heightAnchor.constraint(equalToConstant: 360).isActive = true
            popUpView.leadingAnchor.constraint(equalTo: transparentBackground.leadingAnchor, constant: 15).isActive = true
            popUpView.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.bringSubviewToFront(self.transparentBackground)
            self.view.bringSubviewToFront(self.transparentBackground)
            
            popUpView.createWalletButton.addTarget(self, action: #selector(createWallet), for: .touchUpInside)
        }
    }
    
    func setUpPopView() -> WalletPinPopView{
        let view = WalletPinPopView(frame: CGRect(x: 15, y: (UIScreen.main.bounds.height - 360)/2, width: UIScreen.main.bounds.width - 30, height: 360))
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        return view
        
    }
    
    
    @objc func dismissAddWalletPopUp(_ sender : UIGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.3, animations: {[weak self] in 
            self?.transparentBackground.alpha = 0
        }) { [weak self] done in
            self?.transparentBackground.removeFromSuperview()
            self?.transparentBackground = nil
            
        }
    }
    
    private func fetchUserWallet(){
        
        //to do api network calls 
        LoadingView.show()
        walletViewModel.wallets.subscribe(with: self) { [weak self] in
            LoadingView.hide()
            self?.walletItemTableView.reloadData()
        }
        walletViewModel.getUserWallets()
    }
    
    @objc func createWallet(){
        dismissAddWalletPopUp()
        LoadingView.show()
        
        walletViewModel.createWallet { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self.showAlert(message: "Wallet creation successful")
                self.fetchUserWallet()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func showSuccessViewController(){
        successView = AlertView(frame: UIScreen.main.bounds, title: "Successful", mode: .success(nil))
//        successView = SuccessView(frame: UIScreen.main.bounds)
//        successView.headerImage.image = UIImage(named: "success-icon")
//        successView.bodyLabel.isHidden = true
//        successView.backgroundColor = .white 
        successView.continueButton.setTitle("Return to Home", for: .normal)
        successView.headerText.text = "Wallet Creation Successful"
//        view.addSubview(successView)
        self.successView.isUserInteractionEnabled = true
        UIApplication.shared.keyWindow!.addSubview(self.successView)
        UIApplication.shared.keyWindow!.bringSubviewToFront(self.successView)
//        self.view.bringSubviewToFront(self.successView)
        successView.continueButton.addTarget(self, action: #selector(goToHome), for: .touchUpInside)
    }
    
    @objc func goToHome(){
        print("going to hoome")
        onAddWalletSuccessful?()
        self.successView.removeFromSuperview()
        self.successView = nil
    }

    private func setUpTableView(){
        walletItemTableView.dataSource = self
        walletItemTableView.delegate = self
        view.addSubview(walletItemTableView)
        walletItemTableView.backgroundColor = .white
        walletItemTableView.separatorStyle = .none
        walletItemTableView.separatorColor = .clear
        walletItemTableView.translatesAutoresizingMaskIntoConstraints = false
        walletItemTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26).isActive  = true
        walletItemTableView.backgroundColor = .clear
        walletItemTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        walletItemTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        walletItemTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        walletItemTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        walletItemTableView.sectionIndexColor = .white
    }
}

extension ManageWalletViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletViewModel.userWalletResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  walletItemTableView.dequeueReusableCell(withIdentifier: CustomWalletSubItemTableViewCell.identifier) as! CustomWalletSubItemTableViewCell
        
        cell.selectionStyle = .none
        let logo = UIImage(named: "logo")
        cell.configureCell(headerTitle: walletViewModel.userWalletResponse[indexPath.row].accountNo, subHeaderTitle: "N\(walletViewModel.userWalletResponse[indexPath.row].balance)", logo: logo)
        cell.layoutIfNeeded()
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    
    
}
