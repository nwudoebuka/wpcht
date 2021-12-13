//
//  ManageCardViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/12/21.
//

protocol ManageCardView : BaseView {
    var goToAddCard : (() -> Void)?{ get set }
    var onBack: (() -> Void)? {get set}
}

class ManageCardViewController: UIViewController, ManageCardView, Alertable {

    var goToAddCard : (() -> Void)?
    var onBack: (() -> Void)?
    var alertView: AlertView?
    
    private let cardItemTableView : UITableView = {
        let table = UITableView()
        table.register(CustomWalletSubItemTableViewCell.self, forCellReuseIdentifier: CustomWalletSubItemTableViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.backgroundColor = .white
        table.rowHeight = 80
        return table
    }()
    
    var isEmpty = true
    var otpViewShown: Bool = false
    var walletViewModel = WalletViewModelImpl()
    
    var backgroundImage : UIImageView = {
        let imageV = UIImageView()
        let targetSize = CGSize(width: 105, height: 126)
        imageV.image = UIImage(named: "empty-manage-card")
        
        imageV.translatesAutoresizingMaskIntoConstraints = false
        return imageV
    }()
    
    var emptyLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textColor = UIColor(named: "dark-gray")
        label.text = "Your card section \n looks empty"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let addCardButton : UIButton = {
        let button = UI.button(title: "Add Card")
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
        getUserBankCard()
    }
    
    private func setUpView(){
        view.addSubview(backgroundImage)
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20).isActive = true
        
        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 32).isActive = true
        
        view.addSubview(addCardButton)
        addCardButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        addCardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        addCardButton.addTarget(self, action: #selector(showAddCard), for: .touchUpInside)
    }
    
    private func setViewsVisibility(){
        backgroundImage.isHidden = !isEmpty
        emptyLabel.isHidden = !isEmpty
        addCardButton.isHidden = !isEmpty
        
        cardItemTableView.isHidden = isEmpty
    }
    
    
    private func getUserBankCard(){
        LoadingView.show()
        let userId =  String(auth.data.userId!)
        walletViewModel.getUserBankCard(userId: userId) {[weak self] (result) in
            LoadingView.hide()
            switch result{
                case .success(let response):
                    if let cards = response as? [CardResponse]{
                        if auth.data.accounts == nil {
                            auth.data.accounts = PaymentAccounts()
                        }
                        auth.data.accounts?.cards = cards
                        
                        if auth.data.completedKyc?.firstIndex(of: RequiredSetup.cardLinked) == nil {
                            auth.data.completedKyc?.append(RequiredSetup.cardLinked)
                        }
                        
                        if let count = self?.walletViewModel.cardResponse.count {
                            if count > 0{
                                self?.isEmpty = false 
                                self?.setViewsVisibility()
                                self?.cardItemTableView.reloadData()    
                            }
                        }
                    }
                case .failure(.custom(let message)):
                    print(message)
            }
        }
    }

    
    private func setUpTableView(){
        cardItemTableView.dataSource = self
        cardItemTableView.delegate = self
        view.addSubview(cardItemTableView)
        cardItemTableView.backgroundColor = .white
        cardItemTableView.separatorStyle = .none
        cardItemTableView.separatorColor = .clear
        cardItemTableView.translatesAutoresizingMaskIntoConstraints = false
        cardItemTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 26).isActive  = true
        cardItemTableView.backgroundColor = .clear
        cardItemTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        cardItemTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        cardItemTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        cardItemTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        cardItemTableView.sectionIndexColor = .white
    }
    
    
    private func setUpNav(){
        title = "Manage Card"
        navigationController?.navigationBar.tintColor = UIColor(named: "toolbar-color-secondary")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        
        let  rightBarButton = UIBarButtonItem.init(image: UIImage(named: "add-bank-icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showAddCard))
//        let backBtn = UIBarButtonItem.init(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(back))
//
//        navigationItem.leftBarButtonItem = backBtn
        navigationItem.rightBarButtonItem = rightBarButton
    }

    @objc func back() {
//        self.onBack?()
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func showAddCard(){
        
        if let kycData = auth.data.completedKyc, kycData.contains(.emailVerify) {
            if auth.data.completedKyc!.contains(.phoneVerify) == true {
                if let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddCardViewController")  as? AddCardViewController {
                    newVC.cardAdded.subscribe(with: self) { (status, otp_needed, ref, error) in
                        DispatchQueue.main.async {
                            newVC.dismiss(animated: false, completion: nil)
                        }
                        DispatchQueue.main.async {
                            if status == true {
                                if otp_needed == true {
                                    self.showOTPView(reference: ref!)
                                } else {
                                    self.showAddCardSuccess()
                                }
                            } else {
                                self.showAlert(title: "Failed!!", message: error!, preferredStyle: .alert, completion: nil)
                            }
                        }
                    }
                    
                    self.present(newVC, animated: true)
                }
            } else {
                self.showAlert(message: "You need to verify your phone number first")
            }
            
        } else {
            self.showAlert(message: "You need to verify your email first")
        }
    }
   
    func showOTPView(reference: String) {
        guard self.otpViewShown == false  else {
            return
        }
        self.otpViewShown = true
        let request = VerifyCardRequest(reference: reference, otp: "", userId: String(auth.data.userId!))
        walletViewModel.cardVerifyReq = request
        
        let otpVC = VerifyAccountViewController.controllerFromStoryboard(.auth)
        otpVC.cardViewModel = self.walletViewModel
        otpVC.verifyMode = .card
        otpVC.onComplete = { (success) in
            self.otpViewShown = false
            let root = UIApplication.shared.keyWindow?.rootViewController
            root?.dismiss(animated: true, completion: nil)
            if success == true {
                self.showAddCardSuccess()
            }
        }
        let root = UIApplication.shared.keyWindow!.rootViewController!
        root.present(otpVC, animated: true, completion: nil)
    }
    
    private func showAddCardSuccess() {
        guard alertView == nil else {
            return
        }
        alertView = AlertView(frame: UIScreen.main.bounds, title: "Card Verified", mode: .success(.generic))
        alertView?.backgroundColor = .white
        alertView?.continueButton.setTitle("Finish", for: .normal)
        alertView?.continueButton.onTouchUpInside.subscribe(with: self) { [weak alertView] _ in
            alertView?.removeFromSuperview()
            alertView = nil
            self.getUserBankCard()
        }
        
        UIApplication.shared.keyWindow!.addSubview(alertView!)
        self.view.bringSubviewToFront(alertView!)
        alertView?.isUserInteractionEnabled = true
    }
}

extension ManageCardViewController : UITableViewDelegate, UITableViewDataSource{
    
    // True for enabling the editing mode
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletViewModel.cardResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  cardItemTableView.dequeueReusableCell(withIdentifier: CustomWalletSubItemTableViewCell.identifier) as! CustomWalletSubItemTableViewCell
        let cardNumberText = "**** " + walletViewModel.cardResponse[indexPath.row].cardNumber.getLastFew(range: 4)
        let cardExpireText = walletViewModel.cardResponse[indexPath.row].expiryMonth  + "/" + walletViewModel.cardResponse[indexPath.row].expiryYear.getLastFew(range: 2)
        let cardLogo = CardUtils.cardTypeImage(prefix: walletViewModel.cardResponse[indexPath.row].cardNumber.substring(0, 4))
        
        cell.selectionStyle = .none
        cell.configureCell(headerTitle: cardNumberText, subHeaderTitle: cardExpireText, logo: cardLogo)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (contextualAction, view, boolValue) in
            self.deleteCard(number: self.walletViewModel.cardResponse[indexPath.row].cardNumber)
        }

        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
    
        return swipeActions
    }
    
    
    func deleteCard(number: String) {
        LoadingView.show()
        self.walletViewModel.deleteBankCard(cardNumber: number) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self.showAlert(message: "Card Deleted")
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
            self.cardItemTableView.reloadData()
        }
    }
 
}
