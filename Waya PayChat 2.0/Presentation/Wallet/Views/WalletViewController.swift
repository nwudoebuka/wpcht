//
//  WalletViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/7/21.
//
import Signals
import UIKit

final class WalletViewController: UIViewController, WalletView, Alertable {
   
    // Flow Coordinator navigate using closure
    var onNavToogle: (() -> Void)?
    var navToPaymentSetting : (() -> Void)?
    var navToTransactions: ((_ transactionViewModel : TransactionViewModelImpl) -> Void)?
    var navToManageWallet : (() -> Void)? 
    var navToManageCard : (() -> Void)? 
    var navToManageBank : (() -> Void)? 
    var navToWalletItemDetail: ((WalletViewModelImpl,TransactionViewModelImpl) -> Void)?
    var navToTopUpCard: ((_ walletViewModel : WalletViewModelImpl) -> Void)?
    var navToTopUpBank: ((WalletViewModelImpl, BankType) -> Void)?
    var bottomSheetView : CustomBottomSheetViewController<TransferBottomSheetView>!
    var navToPayToPhone: ((WalletViewModelImpl) -> Void)?
    var navToPayToEmail: ((WalletViewModelImpl) -> Void)?
    var navToPayToID: ((WalletViewModelImpl,String) -> Void)?
    var navToPayBeneficiary: ((_ walletViewModel: WalletViewModelImpl) -> Void)?
    
    //show billPaymentViews
    var navToShowCableView : ((_ walletViewModel : WalletViewModelImpl) -> Void)? 
    var navToShowDataPurchaseView  : ((_ walletViewModel : WalletViewModelImpl) -> Void)?
    var navToShowAirtimeView : ((_ walletViewModel : WalletViewModelImpl) -> Void)? 
    var navToShowUtilityView : ((_ walletViewModel : WalletViewModelImpl) -> Void)? 
    
    //show RequestViews
    var navToSendRequest : ((_ walletViewModel : WalletViewModelImpl) -> Void)? 
    var navToReceiveRequest : ((_ walletViewModel : WalletViewModelImpl) -> Void)?
    var navToAllRequest : ((_ walletViewModel : WalletViewModelImpl) -> Void)? 
    
    //show Receive Views
    var navToRequestPayment : ((_ walletViewModel : WalletViewModelImpl) -> Void)?
    var navToScanToPayView : ((_ walletViewModel : WalletViewModelImpl) -> Void)? 
    
    //show Withdraw Views 
    var navToWithdrawView : ((_ walletViewModel : WalletViewModelImpl, _ mode: WithdrawMode) -> Void)?
    
    // show bvn linking
    var navToLinkBVN: ((WalletViewModelImpl) -> Void)?
    
    // show Email/Phone Verify
    var navToVerify: ((ForgotOTPChannel, AuthViewModel) -> Void)?
    
    //fundWalletBottomShettController that show on click Each wallet 
    var fundWalletBottomSheetController : CustomBottomSheetViewController<FundWalletBottomSheet>!
    var receivePaymentBottomSheetController : CustomBottomSheetViewController<ReceivePaymentBottomSheet>!
    var requestPaymentBottomSheetController : CustomBottomSheetViewController<RequestPaymentBottomSheet>!
    
    var withdrawBottomSheetController: CustomBottomSheetViewController<WithdrawToBankBottomSheet>!
    
    
    var profileImageNavItem = UIBarButtonItem()
    var rightBarButton = UIBarButtonItem()
    var rightBarButton2 = UIBarButtonItem()
    
    var walletActionType : WalletActionType = WalletActionType.transfer
    
    lazy var contentViewSize = CGSize(width: view.frame.width, 
                                      height: view.frame.height + 10)
    
    var cardTopConstraint : NSLayoutConstraint! 
    
    let userDefaults = UserDefaults.standard
    var profileImage  =  UIImage(named: "profile-placeholder")?.resized(to: CGSize(width: 24, height: 24))
    
    var transparentBackground : UIView!
    var walletDropDownView : WalletTopDropDownView!
    var walletViewModel = WalletViewModelImpl()
    var txnViewModelImpl = TransactionViewModelImpl()
    let authViewModel = AuthViewModelImpl()
    let transactionViewModel = TransactionViewModelImpl()
    
    
    var placeholderImageView : UIImageView!

    lazy var cardCollectionView : UICollectionView = {
        let layout  = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.register(CardViewCell.self, forCellWithReuseIdentifier: CardViewCell.identifier)
        collectionView.isUserInteractionEnabled = true
        return collectionView
    }()
    
    var pageControl  : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.frame.size = CGSize(width: 300, height: 30)
        pageControl.pageIndicatorTintColor = UIColor(named: "light-gray")
        pageControl.currentPageIndicatorTintColor =  UIColor(named: "color-accent")
        return pageControl
    }()
    

    var transferView : WalletActionItemView = {
       let view = WalletActionItemView()
        view.actionButton.setImage(UIImage(named: "transfer-icon"), for: .normal)
        view.headerLabel.text = "Transfer"
       return view 
    }()
    
    var withdrawView : WalletActionItemView = {
        let view = WalletActionItemView()
        view.actionButton.setImage(UIImage(named: "withdraw-icon"), for: .normal)
        view.headerLabel.text = "Withdraw"
        return view 
    }()
    
    var receiveView : WalletActionItemView = {
        let view = WalletActionItemView()
        view.actionButton.setImage(UIImage(named: "receive-icon"), for: .normal)
        view.headerLabel.text = "Receive"
        return view 
    }()
    
    var requestView : WalletActionItemView = {
        let view = WalletActionItemView()
        view.actionButton.setImage(UIImage(named: "request-icon"), for: .normal)
        view.headerLabel.text = "Request"
        return view 
    }()
    
    var walletActionStackView = UIStackView()
    
    var utilityPurchaseView : PurchaseItemCategoryView = {
        let view = PurchaseItemCategoryView()
        view.headerLabel.text = "Utility Bills"
        view.purchaseImageView.image = UIImage(named: "utility-icon")
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = .white
        return view
    }()
    
    var airtimePurchaseView : PurchaseItemCategoryView = {
        let view = PurchaseItemCategoryView()
        view.headerLabel.text = "Airtime"
        view.purchaseImageView.image = UIImage(named: "airtime-icon")
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    var dataPurchaseView : PurchaseItemCategoryView = {
        let view = PurchaseItemCategoryView()
        view.headerLabel.text = "Data"
        view.purchaseImageView.image = UIImage(named: "data-icon")
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    var cablePurchaseView : PurchaseItemCategoryView = {
        let view = PurchaseItemCategoryView()
        view.headerLabel.text = "Cable"
        view.purchaseImageView.image = UIImage(named: "cable-icon")
        view.layer.cornerRadius = 8
        view.backgroundColor = .white
        return view
    }()
    
    var pinView: PinVerify?
    var otpView: OTPVerifyView?
    
    var subStack1 = UIStackView()
    var subStack2 = UIStackView()
    var successView: AlertView?
    
    lazy var bottomBackgroundView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "light-background")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var  scrollView  : UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.frame = view.bounds
        scrollView.contentSize = contentViewSize
        scrollView.autoresizingMask = .flexibleHeight
        return scrollView
    }()
    
    lazy var containerView  : UIView = {
        let view  = UIView()
        view.backgroundColor = .white
        view.frame.size = contentViewSize
        return view
    }()
    
     var advertImageView  : UIImageView = {
        let view  = UIImageView()
        view.image = UIImage(named: "advert-wallet")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var accountSetupView: AccountSetupView = {
        let view = AccountSetupView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    var serviceLaneBusy: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpNav()
        setLeftItem()
        fetchProfileImage()
        checkChangeNaviagtionStyle()
        setUpCardCollectionView()
        
        if auth.data.appLockStatus != .walletUnlocked {
            showPinOverlay()
        }
        auth.appLockChanged.subscribe(with: self) { (status) in
            if status == .appUnlocked {
                self.showPinOverlay()
            }
        }
    }
    
    func setUpNav(){
        title = "Wayapay"
        
        rightBarButton2.tintColor = UIColor(named: "toolbar-color-secondary")
        rightBarButton2 = UIBarButtonItem.init(image: UIImage(named: "history-icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapHistory))
        rightBarButton.tintColor = UIColor(named: "toolbar-color-secondary")
        rightBarButton = UIBarButtonItem.init(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapDropDown))
 
        navigationItem.rightBarButtonItems = [rightBarButton, rightBarButton2]
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back-arrow")
        restoreNavLine()
        
        title = "Wayapay"
        
        self.navigationItem.rightBarButtonItems = [rightBarButton, rightBarButton2]
    }
    
    private func fetchProfileImage()  {
        
        if userDefaults.object(forKey: "ProfileImage") != nil && userDefaults.string(forKey: "ProfileImage") != ""{
            guard let url = URL(string:  userDefaults.string(forKey: "ProfileImage") ?? "") else { return }
            let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    let image = UIImage(data: data) ?? UIImage(named: "profile-placeholder")?.resized(to: CGSize(width: 10, height: 10))
                    self?.profileImage = image
                    let menuBtn = UIButton(type: .custom)
                    
                    menuBtn.setBackgroundImage(self?.profileImage, for: .normal)
                    menuBtn.addTarget(self, action: #selector(self?.showNavigation), for: .touchUpInside)
                    menuBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                    menuBtn.layer.cornerRadius = menuBtn.frame.width/2
                    menuBtn.clipsToBounds = true
                    
                    let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                    view.bounds = view.bounds.offsetBy(dx: 10, dy: 3)
                    view.addSubview(menuBtn)
                    //let backButton = UIBarButtonItem(customView: view)
                    self?.profileImageNavItem = UIBarButtonItem(customView: view)
                    
                    self?.navigationItem.leftBarButtonItem = self?.profileImageNavItem
                }
            }
            task.resume()
        } 
    }
    
    @objc func showNavigation(){
        onNavToogle?()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        restoreNavLine()
        setUpButtonsTap()
        getUserWallets()
        accountSetupView.reload()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        auth.profileReloaded.subscribe(with: self) {
            self.accountSetupView.reload()
        }
        self.cardCollectionView.reloadData()
        accountSetupView.reload()
    }
    
    private func setLeftItem(){
        let menuBtn = UIButton(type: .custom)
        
        menuBtn.setBackgroundImage(profileImage, for: .normal)
        menuBtn.addTarget(self, action: #selector(showNavigation), for: .touchUpInside)
        menuBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        menuBtn.layer.cornerRadius = menuBtn.frame.width/2
        menuBtn.clipsToBounds = true
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.bounds = view.bounds.offsetBy(dx: 10, dy: 3)
        view.addSubview(menuBtn)
        //let backButton = UIBarButtonItem(customView: view)
        profileImageNavItem = UIBarButtonItem(customView: view)
        
        navigationItem.leftBarButtonItem = profileImageNavItem
    }
    
    private func setUpButtonsTap(){
        transferView.actionButton.addTarget(self, action: #selector(showBottomSheetForTransfer(_:)), for: .touchUpInside)
        receiveView.actionButton.addTarget(self, action: #selector(showRecivePaymentBottomSheet(_:)), for: .touchUpInside)
        withdrawView.actionButton.addTarget(self, action: #selector(didTapWithDrawView), for: .touchUpInside)
        requestView.actionButton.addTarget(self, action: #selector(showRequestPaymentBottomSheet(_:)), for: .touchUpInside)

    }
    
    @objc func didTapWithDrawView(){
        withdrawBottomSheetController = CustomBottomSheetViewController<WithdrawToBankBottomSheet>()
        withdrawBottomSheetController.modalPresentationStyle = .custom
        withdrawBottomSheetController.transitioningDelegate = self
        
        withdrawBottomSheetController.contentView.onClick.subscribe(with: self) { (mode) in
            self.withdrawBottomSheetController.dismiss(animated: true) {
                DispatchQueue.main.async {
                    self.navToWithdrawView?(self.walletViewModel, mode)
                }
            }
        }
        present(withdrawBottomSheetController, animated: true, completion: nil)
    }
    

    @objc func didTapHistory(){
        print("Tap wallet is working")
        navToTransactions?(transactionViewModel)
    }
    
    @objc func didTapDropDown(){
        addWalletDropDown()
    }
    
    func addWalletDropDown(){
        if self.transparentBackground == nil{
            self.transparentBackground = UIView(frame: UIScreen.main.bounds)
            self.transparentBackground.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissWalletDropDownPopUp(_:)))
            tap.numberOfTapsRequired = 1
            self.transparentBackground.addGestureRecognizer(tap)
            self.transparentBackground.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.addSubview(self.transparentBackground)
            walletDropDownView = setupOpaqueView()
            walletDropDownView.translatesAutoresizingMaskIntoConstraints = false
            transparentBackground.addSubview(walletDropDownView)
            walletDropDownView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            walletDropDownView.trailingAnchor.constraint(equalTo: transparentBackground.trailingAnchor, constant: -17).isActive = true
            walletDropDownView.heightAnchor.constraint(equalToConstant: 128).isActive = true
            walletDropDownView.widthAnchor.constraint(equalToConstant: 210).isActive = true
            walletDropDownView.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.bringSubviewToFront(self.transparentBackground)
            self.view.bringSubviewToFront(self.transparentBackground)
            
            walletDropDownView.paymentSettingButton.addTarget(self, action: #selector(didTapPaymentSetting), for: .touchUpInside)
            walletDropDownView.manageWalletButton.addTarget(self, action: #selector(didTapManageWallet), 
                                                            for: .touchUpInside)
            walletDropDownView.manageCardButton.addTarget(self, action: #selector(didTapManageCard), 
                                                          for: .touchUpInside)
            walletDropDownView.manageBankButton.addTarget(self, action: #selector(didTapManageBank), 
                                                          for: .touchUpInside)
        }
    }
    
    // did tap  payment setting
    @objc func didTapPaymentSetting(){
        walletDropDownView.setSelectedIndex(0)
        dismissWalletDropDownPopUp(nil)
        navToPaymentSetting?()
    }
    
    // dismiss manageWallet dropdown
    @objc func didTapManageWallet(){
        walletDropDownView.setSelectedIndex(1)
        dismissWalletDropDownPopUp(nil)
        navToManageWallet?()
    }
    
    @objc func didTapManageCard(){
        walletDropDownView.setSelectedIndex(2)
        dismissWalletDropDownPopUp(nil)
        navToManageCard?()
    }
    
    @objc func didTapManageBank(){
        walletDropDownView.setSelectedIndex(3)
        dismissWalletDropDownPopUp(nil)
        navToManageBank?()
    }
    
    func setupOpaqueView() -> WalletTopDropDownView{
        let view = WalletTopDropDownView(frame: CGRect(x: 0, y: 0, width: 210, height: 128))
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }
    
    @objc func dismissWalletDropDownPopUp(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentBackground.alpha = 0
        }) {  done in
            self.transparentBackground.removeFromSuperview()
            self.transparentBackground = nil
        }
    }
    
    private func setUpCardCollectionView(){
        
        placeholderImageView = generateUIImageView(imageName: "wallet-card-virtual")
        view.addSubviews([accountSetupView, cardCollectionView, placeholderImageView])
        
        accountSetupView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        accountSetupView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        accountSetupView.onSelect.subscribe(with: self, callback: { [weak self] (setup) in
            switch setup {
            case .emailVerify, .phoneVerify:
                let channel: ForgotOTPChannel = (setup == .phoneVerify) ? .phone : .email
                self?.startVerify(channel: channel)
            case .bvnLinked:
                self?.verifyBvnClicked()
            case .accountLinked:
                self?.linkBankClicked()
            case .cardLinked:
                self?.linkCardClicked()
            }
        })
        
        accountSetupView.toggle.subscribe(with: self, callback: { [weak accountSetupView] (show) in
            accountSetupView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = false
            accountSetupView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -100).isActive = false
            UIView.animate(withDuration: 0.3) {
                if show == true {
                    accountSetupView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
                } else {
                    accountSetupView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -100).isActive = true
                }
            }
            
        })
        accountSetupView.isUserInteractionEnabled = true
        
        placeholderImageView.anchor(top: accountSetupView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 14, left: 32, bottom: 0, right: 16))
        placeholderImageView.heightAnchor.constraint(equalToConstant: 134).isActive = true
        
        cardCollectionView.anchor(top: accountSetupView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        cardCollectionView.heightAnchor.constraint(equalToConstant: 134).isActive = true
        
        auth.profileReloaded.subscribe(with: self) { () in
            self.accountSetupView.reload()
        }
        
        cardCollectionView.showsVerticalScrollIndicator = false
        cardCollectionView.showsHorizontalScrollIndicator = false
        cardCollectionView.backgroundColor = .white
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        cardCollectionView.isScrollEnabled = true
        setUpViewContraint()
        cardCollectionView.reloadData()
    }
    
    private func setUpViewContraint(){
        view.addSubviews([pageControl, scrollView])
        pageControl.heightAnchor.constraint(equalToConstant: 10).isActive = true
        pageControl.topAnchor.constraint(equalTo: cardCollectionView.bottomAnchor, constant: 8).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.currentPage = 0
          
        scrollView.isScrollEnabled = true
        scrollView.anchor(top: pageControl.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
          
        containerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: view.frame.size.height + 50).isActive = true
        containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        self.view.layoutIfNeeded()

        walletActionStackView.translatesAutoresizingMaskIntoConstraints = false
        walletActionStackView.addArrangedSubview(transferView)
        walletActionStackView.addArrangedSubview(withdrawView)
        walletActionStackView.addArrangedSubview(receiveView)
        walletActionStackView.addArrangedSubview(requestView)
          
        walletActionStackView.axis = .horizontal
        walletActionStackView.distribution = .fillEqually
        walletActionStackView.alignment = .fill

          
        containerView.addSubviews([walletActionStackView, bottomBackgroundView])
        walletActionStackView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        walletActionStackView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        walletActionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        walletActionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true

        bottomBackgroundView.topAnchor.constraint(equalTo: walletActionStackView.bottomAnchor, constant: 20).isActive = true
        bottomBackgroundView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        bottomBackgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    
        utilityPurchaseView.translatesAutoresizingMaskIntoConstraints = false
        utilityPurchaseView.frame.size = CGSize(width: view.frame.size.width/2 - 50, height: 65)
          
        dataPurchaseView.translatesAutoresizingMaskIntoConstraints = false
        dataPurchaseView.frame.size = CGSize(width: view.frame.size.width/2 - 50, height: 65)
          
        airtimePurchaseView.translatesAutoresizingMaskIntoConstraints = false
        airtimePurchaseView.frame.size = CGSize(width: view.frame.size.width/2 - 50, height: 65)
          
        cablePurchaseView.translatesAutoresizingMaskIntoConstraints = false
        cablePurchaseView.frame.size = CGSize(width: view.frame.size.width/2 - 50, height: 65)
          
          
        bottomBackgroundView.addSubviews([
            utilityPurchaseView, airtimePurchaseView,
            dataPurchaseView, cablePurchaseView, advertImageView
        ])
        
        utilityPurchaseView.leadingAnchor.constraint(equalTo: bottomBackgroundView.leadingAnchor, constant: 17).isActive = true
        utilityPurchaseView.widthAnchor.constraint(equalToConstant: (view.frame.size.width - 50)/2  ).isActive = true
        utilityPurchaseView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        utilityPurchaseView.topAnchor.constraint(equalTo: bottomBackgroundView.topAnchor, constant: 8).isActive = true
          
        airtimePurchaseView.trailingAnchor.constraint(equalTo: bottomBackgroundView.trailingAnchor, constant: -17).isActive = true
        airtimePurchaseView.widthAnchor.constraint(equalToConstant: (view.frame.size.width - 50)/2  ).isActive = true
        airtimePurchaseView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        airtimePurchaseView.topAnchor.constraint(equalTo: bottomBackgroundView.topAnchor, constant: 8).isActive = true
          
        dataPurchaseView.leadingAnchor.constraint(equalTo: bottomBackgroundView.leadingAnchor, constant: 17).isActive = true
        dataPurchaseView.widthAnchor.constraint(equalToConstant: (view.frame.size.width - 50)/2  ).isActive = true
        dataPurchaseView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        dataPurchaseView.topAnchor.constraint(equalTo: utilityPurchaseView.bottomAnchor, constant: 8).isActive = true
          
        cablePurchaseView.trailingAnchor.constraint(equalTo: bottomBackgroundView.trailingAnchor, constant: -17).isActive = true
        cablePurchaseView.widthAnchor.constraint(equalToConstant: (view.frame.size.width - 50)/2  ).isActive = true
        cablePurchaseView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        cablePurchaseView.topAnchor.constraint(equalTo: utilityPurchaseView.bottomAnchor, constant: 8).isActive = true
          
        advertImageView.topAnchor.constraint(equalTo: cablePurchaseView.bottomAnchor, constant: 21).isActive = true
        advertImageView.centerXAnchor.constraint(equalTo: bottomBackgroundView.centerXAnchor).isActive = true
        advertImageView.widthAnchor.constraint(equalToConstant: view.frame.width - 34).isActive = true
          
        walletActionStackView.isUserInteractionEnabled = true
          
        let utitlityTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapUtilityView(_:)))
        utitlityTapGesture.numberOfTapsRequired = 1
        utilityPurchaseView.addGestureRecognizer(utitlityTapGesture)
          
        let airtimeTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAirtimeView(_:)))
        airtimeTapGesture.numberOfTapsRequired = 1
        airtimePurchaseView.addGestureRecognizer(airtimeTapGesture)
          
        let dataTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDataView(_:)))
        dataTapGesture.numberOfTapsRequired = 1
        dataPurchaseView.addGestureRecognizer(dataTapGesture)
          
        let cableTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCableView(_:)))
        cableTapGesture.numberOfTapsRequired = 1
        cablePurchaseView.addGestureRecognizer(cableTapGesture)
          
    }
    
    @objc  func showBottomSheetForTransfer(_ gestureRecognizer : UITapGestureRecognizer?){
        walletActionType = .transfer
        bottomSheetView = CustomBottomSheetViewController<TransferBottomSheetView>()
        bottomSheetView.contentView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.58)
        bottomSheetView.modalPresentationStyle = .custom
        bottomSheetView.transitioningDelegate = self
        bottomSheetView.contentView.payToEmailButton.addTarget(self, action: #selector(didTapPayToEmail), for: .touchUpInside)
        bottomSheetView.contentView.payToPhone.addTarget(self, action: #selector(didTapPayToPhone), for: .touchUpInside)
        bottomSheetView.contentView.payToWayaId.addTarget(self, action: #selector(didTapPayToID), for: .touchUpInside)
        bottomSheetView.contentView.payToIndividualButton.addTarget(self, action: #selector(didTapPayToIndividual), for: .touchUpInside)
        bottomSheetView.contentView.sendToBeneficiary.addTarget(self, action: #selector(didTapSendToBeneficiary), for: .touchUpInside)
        bottomSheetView.contentView.scanToPay.addTarget(self, action: #selector(didTapScanToPay), for: .touchUpInside)

        present(bottomSheetView, animated: true, completion: nil)
    }
    
    @objc func didTapScanToPay(){
        bottomSheetView.dismiss(animated: true, completion: nil)
        bottomSheetView = nil
        navToScanToPayView?(walletViewModel)
    }
    
    @objc func didTapSendToBeneficiary(){
        bottomSheetView.dismiss(animated: true, completion: nil)
        bottomSheetView = nil
        navToPayBeneficiary?(walletViewModel)
    }
    
    //implement different event click for all button selected in transfer bottom sheet controller 
    @objc func didTapPayToEmail(){
        print("Did click on pay to email")
        bottomSheetView.dismiss(animated: true, completion: nil)
        bottomSheetView = nil
        navToPayToEmail?(walletViewModel)
    }
    
    @objc func didTapPayToID(){
        bottomSheetView.dismiss(animated: true, completion: nil)
        bottomSheetView = nil
        navToPayToID?(walletViewModel,"Pay to Id")
    }
    
    @objc func didTapPayToIndividual(){
        bottomSheetView.dismiss(animated: true, completion: nil)
        bottomSheetView = nil
        navToPayToID?(walletViewModel,"Pay to Waya ID")
    }
    
    @objc func didTapPayToPhone(){
        bottomSheetView.dismiss(animated: true, completion: nil)
        bottomSheetView = nil
        navToPayToPhone?(walletViewModel)
    }
    
    @objc  func showBottomSheetForFund(_ gestureRecognizer : UITapGestureRecognizer?){
        walletActionType = .fund
        fundWalletBottomSheetController = CustomBottomSheetViewController<FundWalletBottomSheet>()
        fundWalletBottomSheetController.contentView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.58)
        fundWalletBottomSheetController.modalPresentationStyle = .custom
        fundWalletBottomSheetController.transitioningDelegate = self
        
        
        fundWalletBottomSheetController.contentView.bankCardButton.addTarget(self, action: #selector(didTapBankCardButton), for: .touchUpInside)
        fundWalletBottomSheetController.contentView.bankAccountButton.addTarget(self, action: #selector(didTapBankAccountButton), for: .touchUpInside)
        fundWalletBottomSheetController.contentView.bankTransferButton.addTarget(self, action: #selector(didTapBankTransferButton), for: .touchUpInside)
        fundWalletBottomSheetController.contentView.ussdButton.addTarget(self, action: #selector(didTapUssdButton), for: .touchUpInside)
        
        present(fundWalletBottomSheetController, animated: true, completion: nil)
    }
    
    @objc  func showRecivePaymentBottomSheet(_ gestureRecognizer : UITapGestureRecognizer?){
        print("Button tapped ")
        walletActionType = .receivePayment
        receivePaymentBottomSheetController = CustomBottomSheetViewController<ReceivePaymentBottomSheet>()
        receivePaymentBottomSheetController.contentView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
        receivePaymentBottomSheetController.modalPresentationStyle = .custom
        receivePaymentBottomSheetController.transitioningDelegate = self
        receivePaymentBottomSheetController.contentView.receivePaymentButton.addTarget(self, action: #selector(didTapReceivePaymentButton), for: .touchUpInside)
        receivePaymentBottomSheetController.contentView.scanToReceivePaymentButton.addTarget(self, action: #selector(didTapScanToReceiveButton), for: .touchUpInside)
        present(receivePaymentBottomSheetController, animated: true, completion: nil)
    }
    
    @objc  func showRequestPaymentBottomSheet(_ gestureRecognizer : UITapGestureRecognizer?){
        print("Button tapped ")
        walletActionType = .requestPayment
        requestPaymentBottomSheetController = CustomBottomSheetViewController<RequestPaymentBottomSheet>()
        requestPaymentBottomSheetController.contentView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.3)
        requestPaymentBottomSheetController.modalPresentationStyle = .custom
        requestPaymentBottomSheetController.transitioningDelegate = self
        requestPaymentBottomSheetController.contentView.receivePaymentButton.addTarget(self, action: #selector(didTapReceivePaymentButton), for: .touchUpInside)
        requestPaymentBottomSheetController.contentView.scanToReceivePaymentButton.addTarget(self, action: #selector(didTapScanToReceiveButton), for: .touchUpInside)
        present(requestPaymentBottomSheetController, animated: true, completion: nil)
    }
    
    @objc func didTapReceivePaymentButton(){
        receivePaymentBottomSheetController.dismiss(animated: true, completion: nil)
        receivePaymentBottomSheetController = nil
        navToRequestPayment?(walletViewModel)
    }
    
    @objc func didTapScanToReceiveButton(){
        receivePaymentBottomSheetController.dismiss(animated: true, completion: nil)
        receivePaymentBottomSheetController = nil
        navToScanToPayView?(walletViewModel)
    }
    
    @objc func didTapBankCardButton(){
        fundWalletBottomSheetController.dismiss(animated: true, completion: nil)
        fundWalletBottomSheetController = nil
        navToTopUpCard?(walletViewModel)
    }
    
    @objc func didTapBankAccountButton() {
        let view = FundViaBankView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onBack = {
            view.removeFromSuperview()
        }
        
        view.onFundViaExisting = {
            self.fundWalletBottomSheetController.dismiss(animated: true, completion: nil)
            self.fundWalletBottomSheetController = nil
            self.navToTopUpBank?(self.walletViewModel, .existing)
        }
        
        view.onFundViaNew = {
            self.fundWalletBottomSheetController.dismiss(animated: true, completion: nil)
            self.fundWalletBottomSheetController = nil
            self.navToTopUpBank?(self.walletViewModel,  .new)
        }
        
        fundWalletBottomSheetController.contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: fundWalletBottomSheetController.contentView.topLine.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: fundWalletBottomSheetController.contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: fundWalletBottomSheetController.contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: fundWalletBottomSheetController.contentView.bottomAnchor)
        ])
    }
    
    @objc func didTapUssdButton() {
        fundWalletBottomSheetController.dismiss(animated: true, completion: nil)
        fundWalletBottomSheetController = nil
        let ussdView = FundViaUssdView()
        ussdView.onBack = {
            ussdView.removeFromSuperview()
        }
        ussdView.dial = { [weak self] () in
            let ac = UIAlertController(title: "Enter amount", message: nil, preferredStyle: .alert)
            ac.addTextField { (textField) in
                textField.keyboardType = .numberPad
            }

            let submitAction = UIAlertAction(title: "Continue", style: .default) { [unowned ac] _ in
                let answer = ac.textFields![0]
                if let string = "*347*006*2*\(answer)*6#".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    if let callUrl = URL(string: "tel://\(string)") {
                        if  UIApplication.shared.canOpenURL(callUrl) {
                            UIApplication.shared.open(callUrl)
                        } else {
                            print("dialling not supported on device")
                        }
                    } else {
                        print("url is invalid")
                    }
                } else{
                    print("ussd dialing not allowed, invalid characters")
                }
                ac.dismiss(animated: false)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [unowned ac] _ in
                ac.dismiss(animated: false)
            }
            ac.addAction(cancelAction)
            ac.addAction(submitAction)
        
            self?.present(ac, animated: true)
        }
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(ussdView)
            ussdView.anchor(top: window.topAnchor, leading: window.leadingAnchor, bottom: window.bottomAnchor, trailing: window.trailingAnchor)
        }
    }
    
    @objc func didTapBankTransferButton() {
        let view = FundViaBankTransferView()
        view.onCopy = { [weak self] (account_number) in
            let pasteboard = UIPasteboard.general
            pasteboard.string = account_number
            let alert = UIAlertController(title: "Success", message: "Account number copied", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self?.fundWalletBottomSheetController.present(alert, animated: true, completion: nil)
        }
        fundWalletBottomSheetController.navToView(view: view)
    }
    
    @objc func didTapUtilityView(_ sender: UITapGestureRecognizer? = nil){
        navToShowUtilityView?(walletViewModel)
    }
    
    @objc func didTapAirtimeView(_ sender: UITapGestureRecognizer? = nil){
        navToShowAirtimeView?(walletViewModel)
    }
    
    @objc func didTapDataView(_ sender: UITapGestureRecognizer? = nil){
        navToShowDataPurchaseView?(walletViewModel)
    }
    
    @objc func didTapCableView(_ sender: UITapGestureRecognizer? = nil){
        navToShowCableView?(walletViewModel)
    }
    
    
    private func toogleWalletDropDown(){
        if walletDropDownView.isHidden == true{
            walletDropDownView.isHidden = false
        }
    }

    func getUserWallets(){
        cardCollectionView.isHidden = true
        walletViewModel.wallets.subscribe(with: self) { [weak self] in
            print("should display wallets")
            self?.pageControl.numberOfPages = self?.walletViewModel.userWalletResponse.count ?? 0
            self?.placeholderImageView.isHidden = true
            self?.cardCollectionView.isHidden = false
            self?.cardCollectionView.reloadData()
        }
        walletViewModel.getVirtualAccounts()
        walletViewModel.getUserWallets()
    }
    

    
    func showPinOverlay() {
        if pinView == nil {
            DispatchQueue.main.async {
                self.pinView = PinVerify(frame: self.view.frame)
                self.pinView?.translatesAutoresizingMaskIntoConstraints = false
                self.pinView?.pinEntered.subscribe(with: self) { (pin) in
                    self.validatePin(pin: pin)
                }
                
                self.view.addSubview(self.pinView!)
                self.pinView?.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
                
                self.view.bringSubviewToFront(self.pinView!)
            }
        }
    }
    
    func hidePinOverlay() {
        if pinView != nil {
            pinView!.removeFromSuperview()
            pinView = nil
            getUserWallets()
        }
    }
    
    private func validatePin(pin: String) {
        LoadingView.show()
        self.authViewModel.pinVerified.subscribeOnce(with: self) { (verified, error) in
            LoadingView.hide()
            DispatchQueue.main.async {
                if verified == true {
                   self.hidePinOverlay()
                } else {
                   self.showAlert(message: error!)
                }
            }
        }
        authViewModel.validateUserPin(pin: pin)
    }

}

extension WalletViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cardCollectionView{
            return walletViewModel.userWalletResponse.count
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardViewCell.identifier, for: indexPath) as! CardViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        cell.configureCard(walletViewModel.userWalletResponse[indexPath.row])
        cell.cardDelegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 308, height:  132)
    }
}

extension WalletViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        switch walletActionType {
            case .transfer:
                return   PresentationController(presentedViewController: presented, presenting: presenting)
            case .fund :
                return   PresentationController(presentedViewController: presented, presenting: presenting, multiplier: 0.5)
            case .receivePayment :
                return   PresentationController(presentedViewController: presented, presenting: presenting, multiplier: 0.3)
            case .requestPayment:
                return   PresentationController(presentedViewController: presented, presenting: presenting, multiplier: 0.388)

        }
    }
}

extension WalletViewController : CardViewCellDelegate{
    func clickToExpand(userWalletResponse: UserWalletResponse) {
        //the selected wallet as the wallet click in the walletViewModel
        walletViewModel.selectedWallet = userWalletResponse
        navToWalletItemDetail?(walletViewModel, txnViewModelImpl)
    }
    
    func topUpWallet(userWalletResponse: UserWalletResponse) {
        walletViewModel.selectedWallet = userWalletResponse
        showBottomSheetForFund(nil)
    }
}

extension WalletViewController {
    func startVerify(channel: ForgotOTPChannel) {
        guard serviceLaneBusy == false else {
            return
        }
        serviceLaneBusy = true
        LoadingView.show()
        authViewModel.resendAuthOTP(phoneOrEmail: nil, channel: channel) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self.navToVerify?(channel, self.authViewModel)
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
            self.serviceLaneBusy = false
        }
    }
    
    func verifyBvnClicked() {
        self.navToLinkBVN?(walletViewModel)
    }
    
    func linkCardClicked() {
        self.navToManageCard?()
    }
    
    func linkBankClicked() {
        self.navToManageBank?()
    }
}
