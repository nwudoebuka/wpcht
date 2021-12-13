//
//  TabBarViewController.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//
import CoreData
import Signals

enum TabBarItem: Int, CaseIterable {
    case home = 0
    case discover
    case wallet
    case notifications
    case chat
}

final class TabBarViewController : UITabBarController, UITabBarControllerDelegate, TabbarView {

    var onLogoutTap: (() -> Void)?
    var dataController:DataController!
    var appDIContainer : AppDIContainer!
 
    var finishFlow: (() -> Void)?
    var profileImageView = UIImageView(image: UIImage(named: "profile-placeholder"))
    let userDefaults = UserDefaults.standard
    var leftBarButton = UIBarButtonItem()
    var profileImage  =  UIImage(named: "profile-placeholder")?.resized(to: CGSize(width: 24, height: 24))
    var qRImage = UIImage()
    
    var refferalCode  = ""
    
    let profileViewModel = ProfileViewModelImpl()
    
   // var menuController : UIViewController!
    lazy var menuController : UIView = {
        let screenSize: CGRect = UIScreen.main.bounds
        let view = UIView()
        view.frame.size = CGSize(width: screenSize.width - 80, height: screenSize.height)
        return view
    }()
    
    var currentIndex  : TabBarItem!
    var timer: Timer?
    static var walletSesion: Signal = Signal<(Bool)>()

    var transparentBackground : UIView!
    var opaqueView : UIScrollView!
    var centerController : UINavigationController!
    var isExpanded = false
    
    var onHomeFlowSelect: ((UINavigationController) -> ())?
    var onDiscoverFlowSelect: ((UINavigationController) -> ())?
    var onWalletFlowSelect: ((UINavigationController) -> ())?
    var onChatFlowSelect: ((UINavigationController) -> ())?
    var onNotificationFlowSelect: ((UINavigationController) -> ())?
    var onSettingsTap: ((SettingsView?) -> Void)?
    
    var onViewDidLoad: ((UINavigationController) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().barTintColor = .white
        UITabBar.appearance().isTranslucent = false
     
        delegate = self
        // to do change the get the selected index from user default
        setUpMenuView()
        fetchReferralCode()
        fetchProfileImage()
        
        switch auth.prefs.defaultView! {
        case .wayachat:
            selectedIndex = 4
            currentIndex = .chat
        case .wayagram:
            selectedIndex = 0
            currentIndex = .home
        case .wayapay:
            selectedIndex = 2
            currentIndex = .wallet
        }
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        onViewDidLoad?(controller)
        startSessionTimer()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        self.currentIndex = TabBarItem(rawValue: selectedIndex)!
        switch self.currentIndex {
        case .home:
            centerController = controller
            onHomeFlowSelect?(controller)
        case .discover:
            centerController = controller
            onDiscoverFlowSelect?(controller)
        case .wallet:
            centerController = controller
            onWalletFlowSelect?(controller)
        case .notifications:
            centerController = controller
            onNotificationFlowSelect?(controller)
        case .chat:
            centerController = controller
            onChatFlowSelect?(controller)
        default:
            break
            
        }
    }
    
    func fetchProfileImage(){
        if let profile = auth.data.profile, let profileImage = profile.profileImage {
            guard let url = URL(string: profileImage) else { return }
            let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    let image = UIImage(data: data) ?? UIImage(named: "profile-placeholder")
                    self?.profileImage = image
                }
            }
            task.resume()
        }
    }
    
    func generateQRCodeWithReferral(_ referralCode : String){
        qRImage = generateQRCodeAndConvert(from: referralCode) ?? qRImage
    }
    
    func fetchReferralCode(){
        profileViewModel.getReferralCode { [weak self](result) in
            switch result{
                case .success(let response):
                    if let response_  = response as? ReferralCodeResponse{
                        auth.data.profile!.referalCode = response_.referralCode
                        self?.refferalCode = response_.referralCode
                        self?.generateQRCodeWithReferral(response_.referralCode)
                        print("The referralCOde gotten is \(response_.referralCode)")

                    }
                case .failure(.custom(let message)):
                    print("The failure message \(message)")
            }
        }
    }
    
    func addSideMenuDrawer(){
        if self.transparentBackground == nil{
            self.transparentBackground = UIView(frame: UIScreen.main.bounds)
            self.transparentBackground.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleOKButtonTapped(_:)))
            tap.numberOfTapsRequired = 1
            self.transparentBackground.addGestureRecognizer(tap)
            self.transparentBackground.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.addSubview(self.transparentBackground)
            self.opaqueView = self.setupOpaqueView()
            self.transparentBackground.addSubview(self.opaqueView)
            opaqueView.translatesAutoresizingMaskIntoConstraints = false
            opaqueView.topAnchor.constraint(equalTo: transparentBackground.topAnchor).isActive = true
            opaqueView.leadingAnchor.constraint(equalTo: transparentBackground.leadingAnchor).isActive = true
            opaqueView.bottomAnchor.constraint(equalTo: transparentBackground.bottomAnchor).isActive = true
            opaqueView.trailingAnchor.constraint(equalTo: transparentBackground.trailingAnchor, constant: -80).isActive = true
            opaqueView.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.bringSubviewToFront(self.transparentBackground)
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            self.opaqueView.addGestureRecognizer(gestureRecognizer)
            self.view.bringSubviewToFront(self.transparentBackground)
        } else {
            print("failed cuz it already exists")
        }
    }
    
    func setupOpaqueView() -> UIScrollView{
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width-80), height: Int(UIScreen.main.bounds.height)))
        let menuView = MenuView(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width-80), height: Int(UIScreen.main.bounds.height)))
        menuView.qRButton.addTarget(self, action: #selector(showQRCode), for: .touchUpInside)
        menuView.logOutButton.addTarget(self, action: #selector(didTapLogOut), for: .touchUpInside)
        menuView.inviteCodeButton.addTarget(self, action: #selector(showInviteCode), for: .touchUpInside)
        menuView.profileButton.addTarget(self, action: #selector(didTapShowProfile), for: .touchUpInside)
        menuView.settingButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        scrollView.addSubview(menuView)
        menuView.backgroundColor = UIColor.white
        return scrollView
    }
    
    @objc func showSettings(){
        closeSideMenu()
        self.onSettingsTap?(nil)
    }
    
    @objc func showQRCode(){
        closeSideMenu()
        if let newVC = self.storyboard?.instantiateViewController(withIdentifier: "QRViewController")  as? QRViewController{
            newVC.profileImageView.image = profileImage
            newVC.qRImageView.image = qRImage
            self.present(newVC, animated: true)
        }   
    }
    
    @objc func showInviteCode(){
        closeSideMenu()
        if let newVC = self.storyboard?.instantiateViewController(withIdentifier: "InviteCodeViewController")  as? InviteCodeViewController{
            newVC.qRImageView.image = qRImage
            self.present(newVC, animated: true)
        }   
    }
    
    @objc func didTapLogOut(){
        closeSideMenu()
        auth.logout()
        onLogoutTap?()
    }
    
    public func clearDatabase() {
        
//        // delete all user default 
//        let domain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: domain)
//        UserDefaults.standard.synchronize()
//        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        dataController.clearDataFromController()
//        DispatchQueue.global(qos: .background).async {[weak self] in
//            guard let url = self?.dataController.persistentContainer.persistentStoreDescriptions.first?.url else { return }
//            
//            let persistentStoreCoordinator = self?.dataController.persistentContainer.persistentStoreCoordinator
//            
//            do {
//                try persistentStoreCoordinator?.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
//                try persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
//                print("Done deleting")
//            } catch {
//                print("Attempted to clear persistent store: " + error.localizedDescription)
//            }
//        }

    }
    
    @objc func didTapShowProfile(){
        closeSideMenu()
        if let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")  as? ProfileViewController{
            //newVC.profileImageView.image = profileImage
            newVC.wayagramViewModel = appDIContainer.makeWayagramViewModel()
            self.present(newVC, animated: true)
        } 
    }
    
    @objc func handleOKButtonTapped(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentBackground.alpha = 0
        }) {  done in
            self.transparentBackground.removeFromSuperview()
            self.transparentBackground = nil
            
        }
    }
    
    @objc func handleDrawerCloseWithDragGesture(_ sender: UITapGestureRecognizer? = nil){
        closeSideMenu()
    }
   
    func closeSideMenu(){
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentBackground.alpha = 0
        }) {  done in
            if(self.transparentBackground != nil){
                self.transparentBackground.removeFromSuperview()
                self.transparentBackground = nil
            }
        }
    }
    
    func setUpMenuView(){
        if menuController == nil{
            print("not nil menu")
            self.view.addSubview(menuController)
            menuController.clipsToBounds = true
            UIApplication.shared.keyWindow!.bringSubviewToFront(menuController)
        } else {
            print("menu is nil")
        }
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            var translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            print("get the x \(translation.x)")
                
            if translation.x < -8{
                closeSideMenu()
            }else if translation.x > 0{
                translation.x -= translation.x  
            } else{
//                UIView.anima
                UIView.animate(withDuration: 0.2) {
                    gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y )
                    gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
                }
            }
        }
        if gestureRecognizer.state == .ended{
            if self.transparentBackground != nil{
                closeSideMenu()
            }
        }
    }
 
    func toogleNavigationMenu() {
        if !isExpanded{
           setUpMenuView()
        }
        isExpanded.toggle()
        addSideMenuDrawer()
    }
    
    private func startSessionTimer() {
        // set a timer to fire every two minutes, if the active tab is the wallet tab and the session is still valid, do nothing, else fire a signal the wallet view controller can react to. at this point the auth service must have already updated the last_active timestamp
        guard self.timer == nil else {
            return
        }
        
        WayaPayChat.activityBegan.subscribe(with: self) {
            if self.currentIndex == .wallet && auth.data.appLockStatus == .walletUnlocked {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                auth.data.last_active = dateFormatter.string(from: Date())
                auth.updateLocalPrefs()
                self.resetWalletSessionTimer()
                return
            } else {
                print("something is seriously wrong")
                print("view: \(self.currentIndex)")
                print("status: \(auth.data.appLockStatus)")
            }
        }
        resetWalletSessionTimer()
    }
    
    private func resetWalletSessionTimer() {
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 121.0, repeats: true, block: { (timer) in
            timer.invalidate()
            if self.currentIndex == .wallet && auth.sessionTimedOut() == true {
                auth.toggleLock(status: .appUnlocked)
            } else {
                if auth.data.appLockStatus == .walletUnlocked && auth.sessionTimedOut() == true {
                    auth.toggleLock(status: .appUnlocked)
                } else {
                    auth.updateLocalPrefs()
                }
            }
        })
    }
}


