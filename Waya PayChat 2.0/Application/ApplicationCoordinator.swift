//
//  ApplicationCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/2/21.
//

fileprivate enum LaunchInstructor {
    case main, auth, onboarding
    
    static func configure() -> LaunchInstructor {
        let authorize = AuthService.shared()
        let isOldUser = authorize.data.onboardingShown
        if isOldUser == false {
            return .onboarding
        }

        if authorize.data.appLockStatus == .locked {
            return .auth
        }
        return .main
    }
}

final class ApplicationCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    private let dataController : DataController
    private let appDIContainer : AppDIContainer
    
    private var instructor: LaunchInstructor {
        return LaunchInstructor.configure()
    }
    
    init(router: Router, coordinatorFactory: CoordinatorFactory,  dataController : DataController, 
         appDIContainer: AppDIContainer) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.dataController = dataController
        self.appDIContainer = appDIContainer
    }
    
    override func start(with option: DeepLinkOption?) {
        //start with deepLink
        if let option = option {
            switch option {
                case .onboarding: runOnboardingFlow()
                case .signUp: runAuthFlow()
                default: childCoordinators.forEach { coordinator in
                    coordinator.start(with: option)
                }
            }
            // default start
        } else {
            switch instructor {
                case .onboarding: runOnboardingFlow()
                case .auth: runAuthFlow()
                case .main: runMainFlow()                        
            }
        }
    }
    
    private func runAuthFlow() {
        // clean logout just to be sure, some unsecured endpoints (login) were returning 401 errors because a token from a  previous session was being sent in the headers
        auth.logout()
        let coordinator = coordinatorFactory.makeAuthCoordinatorBox(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
//            self?.authorize.updateLocalPrefs()
            self?.start()
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runOnboardingFlow() {
        let coordinator = coordinatorFactory.makeOnboardingCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            auth.data.onboardingShown = true
            auth.updateLocalPrefs()
            self?.start()
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runMainFlow() {
        let (coordinator, module) = coordinatorFactory.makeTabbarCoordinator(dataController: self.dataController, appDIContainer : self.appDIContainer)
       
        coordinator.present = { [weak self, weak coordinator] (settingsView) in
            self?.removeDependency(coordinator)
            self?.runFlow(with: settingsView)
        }

        coordinator.finishFlow = {[weak self, weak coordinator] in
            
            if auth.data.loggedIn == true {
                self?.start()
                self?.removeDependency(coordinator)
            } else {
                DispatchQueue.main.async {
                    self?.runAuthFlow()
                }
            }
        }
        addDependency(coordinator)
        router.setRootModule(module, hideBar: true)
        coordinator.start()
    }
    
    private func runFlow(with settingView: SettingsView?) {
        let coordinator = coordinatorFactory.makeSettingsCoordinator(router: router, withView: settingView)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.start()
            self?.removeDependency(coordinator)
        }
        addDependency(coordinator)
        coordinator.start()
    }
}

