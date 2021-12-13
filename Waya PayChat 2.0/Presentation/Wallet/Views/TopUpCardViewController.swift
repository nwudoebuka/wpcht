//
//  TopUpCardViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/7/21.
//
import SwiftValidator
import Signals
import SafariServices


protocol TopUpCardView : BaseView {
    var onTopUpSuccessful : (() -> Void)? { get set }
    var onTopUpFailed: (() -> Void)? {get set}
    var source: ChargeSource {get set}
    var onBack: (() -> Void)? { get set}
}

class TopUpCardViewController: UIViewController, TopUpCardView, UITextFieldDelegate, Alertable {

    var viewType  = 0 //0 = selectCard, 1 = CardDetail
    let walletViewModel : WalletViewModelImpl!
    var authViewModel = AuthViewModelImpl()
    var onBack: (() -> Void)?
    
    var transactionDetailView : TransactionDetailView!
    var transactionDetail : TransactionDetail!
    var successView : AlertView!
    
    var onTopUpSuccessful : (() -> Void)?
    var onTopUpFailed: (() -> Void)?
    
    var source: ChargeSource
    
    var userBanks = Signal<([Bank])>()
    var banks = [Bank]()
    var allowedBanks = [Bank]()
    
    var bankTopUpView: BankTopUp?
    var cardTopUp: CardTopUpView?
    
    let transparentView = UIView()
    
    init(walletViewModel : WalletViewModelImpl, chargeSource: ChargeSource){
        self.walletViewModel = walletViewModel
        self.source = chargeSource
        super.init(nibName : nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavigation()
        hideKeyboardWhenTappedAround()
        if (source != .card) {
            getUserBankAccount()
        } else {
            getUserCards()
        }
    }
    
    private func setUpNavigation(){
        if (source == .card) {
            title = "Top-up via Card"
        } else if source == .bank(.new) {
            title = "Top-up via New Bank Account"
        } else if source == .bank(.existing) {
            title = "Top-up via Existing Bank Account"
        }
        self.navigationItem.hidesBackButton = true
        let  backBarButton = UIBarButtonItem.init(image: UIImage(named: "back-arrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackPressed))
        
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func handleBackPressed(sender: UIBarButtonItem) {
        if source == .card {
            guard let cardView = cardTopUp else {
                self.onBack?()
                return
            }
            
            if cardView.selectedCard != nil {
                cardView.selectedCard = nil
                cardView.toggle()
            } else {
                self.onBack?()
            }
        } else {
            self.onBack?()
        }
    }
    
    func getUserBankAccount() {
        LoadingView.show()

        self.userBanks.subscribe(with: self) { (user_banks) in
            LoadingView.hide()
            DispatchQueue.main.async {
                self.showBankView(addedBanks: user_banks, allowed: self.allowedBanks)
            }
        }.onQueue(.main)

        self.walletViewModel.getChargeableBanks { (result) in
            switch result {
            case .success(let banks):
                guard let banks = banks as? [ChargeAbleBankResponse]  else {
                    return
                }
                self.allowedBanks = banks.map { Bank(name: $0.name, code: $0.code, accountNumber: nil) }
                self.loadAccounts()
            case .failure(_):
                break
            }
        }
    }
    
    private func showBankView(addedBanks: [Bank], allowed: [Bank]) {
        if source == .bank(.new) {
            bankTopUpView = NewBankView(model: walletViewModel)
        } else {
            bankTopUpView = ExistingBankView()
        }
        bankTopUpView?.userBanks = addedBanks
        bankTopUpView?.allowedBanks = allowed
        
        bankTopUpView?.onError.subscribe(with: self, callback: { (error) in
            self.showAlert(message: error)
        }).onQueue(.main)
       
        bankTopUpView?.onContinue = { (bank, amount) in
            let request = ChargeBankRequest(amount: amount, email: auth.data.profile!.email, walletAcctNo: self.walletViewModel.selectedWallet.accountNo)
            
            self.walletViewModel.chargeBankRequest = request
            self.bankTopUpView?.removeFromSuperview()
            self.setTransactionDetail(bank: bank, amount: amount)
            self.showTransactionDetailView()
        }
        self.view.addSubview(bankTopUpView!)
        bankTopUpView!.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        bankTopUpView?.refresh()
        
    }
    
    private func getUserCards() {
        LoadingView.show()
        let userId =  String(auth.data.userId!)
        walletViewModel.getUserBankCard(userId: userId) {[weak self] (result) in
            LoadingView.hide()
            guard let self = self else {
                return
            }
            switch result{
                case .success(let response):
                    if let cards = response as? [CardResponse]{
                        self.showCardView(cards: cards)
                    }
                case .failure(.custom(let message)):
                    self.showAlert(message: message)
            }
        }
    }
    
    func showCardView(cards: [CardResponse]) {
        cardTopUp = CardTopUpView()
        cardTopUp!.cards = cards
        
        cardTopUp!.onError.subscribe(with: self, callback: { (error) in
            self.showAlert(message: error)
        }).onQueue(.main)
        
        cardTopUp!.onContinue.subscribe(with: self) { (card, amount) in
            let chargeCard = ChargeCardRequest(
                userId: String(auth.data.userId!),
                cardNumber: card.cardNumber,
                amount: amount,
                walletAccountNo:  self.walletViewModel.selectedWallet.accountNo
            )
            self.walletViewModel.chargeCardRequest = chargeCard
            self.setTransactionDetail(card: card, amount: amount)
            self.showTransactionDetailView()
        }.onQueue(.main)
        
        self.view.addSubview(cardTopUp!)
        cardTopUp!.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        cardTopUp?.refresh()
    }
    
    private func chargeBank() {
        LoadingView.show()
        walletViewModel.chargeBankAccount() {[weak self] (result) in
            LoadingView.hide()
            switch result {
            case .success(let response):
                self?.transactionDetailView.removeFromSuperview()
                guard let response = response as? Response<ChargeBankResponse>, let data = response.data else {
                    self?.addFailureView(failure: .bank_verify_failed)
                    return
                }
                
                if response.status == true {
                    if let url = URL(string: data.authorization_url) {
                        let config = SFSafariViewController.Configuration()
                        config.entersReaderIfAvailable = false
                        
                        let vc = SFSafariViewController(url: url, configuration: config)
                        vc.delegate = self
                        
                        self?.present(vc, animated: true)
                    } else {
                        self?.addSuccessView()
                    }
                } else {
                    self?.addFailureView(failure: .error(message: response.message!))
                }
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func validatePin(){
        LoadingView.show()
        authViewModel.pinVerified.subscribeOnce(with: self) {[weak self] (verified, error) in
            LoadingView.hide()
            guard verified == true else {
                self?.addFailureView(failure: .incorrect_pin)
                return
            }
            
            (self?.source == .card) ? self?.chargeCard() : self?.chargeBank()
        }
        authViewModel.validateUserPin(pin: transactionDetailView.otpStackView.getOTP())
    }
    
    func chargeCard(){
        LoadingView.show()
        walletViewModel.chargeCard() { (result) in
            DispatchQueue.main.async {
                LoadingView.hide()
                self.transactionDetailView.removeFromSuperview()
                switch result{
                    case .success(let response):
                        if let response = response as? Response<String> {
                            if response.status == true {
                                self.addSuccessView()
                            } else {
                                if response.message!.contains("This authorization could not be charged") {
                                    self.addFailureView(failure: .error(message: response.message!))
                                } else {
                                    self.addFailureView(failure: .error(message: response.message!))
                                }
                            }
                        } else {
                         print("could not parse response")
                        }
                    case .failure(.custom(let message)):
                        self.showAlert(message: message)
                }
            }
        }
    }

    private func loadAccounts() {
        walletViewModel.getUserBankAccounts { [weak self] (_ response: ResponseList<BankResponse>?, error) in
            LoadingView.hide()
            guard let self = self else {
                return
            }
            if let error = error {
                self.showAlert(message: error)
                return
            }
            guard let banks = response?.data else {
                self.showAlert(message: "No bank account added to account")
                return
            }
            let allBanks = banks.compactMap { Bank(name: $0.bankName!, code: $0.bankCode!, accountNumber: $0.accountNumber) }
            self.userBanks => (allBanks)
        }
    }
    
    func addSuccessView(){
        successView = AlertView(frame:  UIScreen.main.bounds)
        successView.mode = .success(.generic)
        successView.tag = 0
        successView.bodyLabel.text = "Your wallet has been credited with \n \(transactionDetail.amount.currencySymbol!)"
        successView.continueButton.setTitle("Finish", for: .normal)
        UIApplication.shared.keyWindow!.addSubview(successView)
        self.view.bringSubviewToFront(successView)
        successView.isUserInteractionEnabled = true
        successView.continueButton.addTarget(self, action: #selector(didTapFinish), for: .touchUpInside)
    }
    
    func addFailureView(failure: TransactionError) {
        successView = AlertView(frame:  UIScreen.main.bounds)
        successView.mode = .failure(failure)
        successView.bodyLabel.text = "Your wallet could not be credited"
//        successView.bodyDetail.text = failure.message
//        successView.bodyDetail.isHidden = false
        successView.isUserInteractionEnabled = true
        successView.continueButton.addTarget(self, action: #selector(didTapTryAgain), for: .touchUpInside)
        successView.returnHomeButton.addTarget(self, action: #selector(didTapHome), for: .touchUpInside)
        
        UIApplication.shared.keyWindow!.addSubview(successView)
        self.view.bringSubviewToFront(successView)
        
    }
    
    @objc func didTapFinish(){
        self.successView.removeFromSuperview()
        switch successView.mode {
        case .failure(_), .security:
            onTopUpFailed?()
        case .success(_):
            onTopUpSuccessful?()
        case .none:
            break
        }
    }
    
    @objc func didTapTryAgain() {
        self.successView.removeFromSuperview()
        self.successView = nil
    }
    
    @objc func didTapHome() {
        self.successView.removeFromSuperview()
        self.onTopUpFailed?()
    }
    
    func setTransactionDetail(card : CardResponse, amount: String){
        self.transactionDetail = TransactionDetail(beneficary: card.accountName, amount: amount, accountNo: card.cardNumber, transactionFee: "10.00".currencySymbol!, bank: card.providerType, labelTitle: "Card Number", labelValue: "**** **** **** \(card.last4digit)", description: "Top-up")
    }
    
    func setTransactionDetail(bank: Bank, amount: String) {
        self.transactionDetail = TransactionDetail(beneficary: bank.accountName!, amount: amount, accountNo: bank.accountNumber!, transactionFee: "10.00".currencySymbol!, bank: bank.name, labelTitle: "Account Number", labelValue: bank.accountNumber!, description: "Top-up")
    }
    
    private func showTransactionDetailView(){
        transactionDetailView = TransactionDetailView(frame: CGRect.zero, transactionDetail: transactionDetail)
        transactionDetailView.source = self.source
        
        view.addSubview(transactionDetailView)
        transactionDetailView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        transactionDetailView.confirmButton.onTouchUpInside.subscribe(with: self) {
            self.validatePin()
        }
    }
    
    private func verifyOTP() {
        
    }
}


extension TopUpCardViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: {
            self.transactionDetailView.removeFromSuperview()
            self.onTopUpSuccessful?()
        })
    }
}
