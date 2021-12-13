//
//  TabBarCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//

class TabbarCoordinator: BaseCoordinator , TabBarCoordinatorOutput{
    var present: ((SettingsView?) -> Void)?
    var finishFlow: (() -> Void)?
    
    private let tabbarView: TabbarView
    private let coordinatorFactory: CoordinatorFactory
    let dataController : DataController
    var currentIndex  : DefaultView!
    let appDIContainer : AppDIContainer

    init(tabbarView: TabbarView, coordinatorFactory: CoordinatorFactory,
         dataController : DataController,appDIContainer : AppDIContainer) {
        self.tabbarView = tabbarView
        self.coordinatorFactory = coordinatorFactory
        
        self.dataController = dataController  
        self.appDIContainer = appDIContainer
    }
    
    override func start() {
        tabbarView.onViewDidLoad = runSelectedFlow()
        tabbarView.onHomeFlowSelect = runHomeFlow()
        tabbarView.onChatFlowSelect = runChatFlow()
        tabbarView.onWalletFlowSelect = runWalletFlow()
        tabbarView.onDiscoverFlowSelect = runDiscoverFlow()
        tabbarView.onNotificationFlowSelect = runNotificationFlow()
        tabbarView.onSettingsTap = { [weak self] (settingsView) in
            DispatchQueue.main.async {
                self?.present?(settingsView)
            }
            
        }
        
        tabbarView.onLogoutTap = {[weak self] in
            self?.finishFlow?()
        }
    }
    
    private func runSelectedFlow() -> ((UINavigationController) -> ()) {
        /*this code to shows the default landing tab bar based on the user
         selection */
        if let view = auth.prefs.defaultView {
            currentIndex = view
            return showUserPreferedSelectedPage(currentIndex)
        } else {
            return showSelectPage()
//            return runWalletFlow()
        }
    }
    
    private func showUserPreferedSelectedPage(_ currentIndex : DefaultView) -> ((UINavigationController) -> ()) {
        switch currentIndex {
        case .wayachat:
            return runChatFlow()
        case .wayapay:
            return runWalletFlow()
        case .wayagram:
            return runHomeFlow()
        }
    }
    
    private func showSelectPage() -> ((UINavigationController) -> Void) {
       
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let customHomePage = CustomizeHomeLandingView()
                customHomePage.finishAuthFlow = { [weak self] in
                    self?.start()
                }
                navController.pushViewController(customHomePage, animated: true)
//                navController = customHomePage.wrapInNavigation()
            }
        }
    }
    
    private func runHomeFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                
                let homeCoordinator = self.coordinatorFactory.makeHomeCoordinator(navController: navController, dataController: self.dataController, appDIContainer: self.appDIContainer)
            
                homeCoordinator.toogleMenu = { [weak self] in
                    self?.tabbarView.toogleNavigationMenu()
                }
                self.addDependency(homeCoordinator)
                homeCoordinator.start()
            }
        }
    }
    
    private func runChatFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let itemCoordinator = self.coordinatorFactory.makeChatCoordinator(navController: navController)
                self.addDependency(itemCoordinator)
                itemCoordinator.start()
            }
        }
    }
    
    private func runDiscoverFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let itemCoordinator = self.coordinatorFactory.makeDiscoverCoordinator(navController: navController)
                self.addDependency(itemCoordinator)
                itemCoordinator.start()
            }
        }
    }
    
    private func runNotificationFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let itemCoordinator = self.coordinatorFactory.makeNotificationCoordinator(navController: navController)
                self.addDependency(itemCoordinator)
                itemCoordinator.start()
            }
        }
    }
    
    private func runWalletFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let itemCoordinator = self.coordinatorFactory.makeWalletCoordinator(navController: navController)
                itemCoordinator.toogleMenu = { [weak self] in
                    self?.tabbarView.toogleNavigationMenu()
                }
                
                itemCoordinator.navToSettings = { [weak self, weak itemCoordinator] (view) in
                    DispatchQueue.main.async {
                        self?.removeDependency(itemCoordinator)
                        self?.present?(view)
                    }
                }
                
                self.addDependency(itemCoordinator)
                itemCoordinator.start()
            }
        }
    }
}

