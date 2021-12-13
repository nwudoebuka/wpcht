//
//  CoordinatorFactoryImpl.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/2/21.
//

final class CoordinatorFactoryImpl: CoordinatorFactory {
//    func makeProfileCoordinator() -> Coordinator {
//
//    }
    
    func makeSettingsCoordinator(router: Router, withView: SettingsView? = nil) -> SettingsCoordinator & Coordinator {
        let cordinator = SettingsCoordinator(router: router, coordinator: ModuleFactoryImpl())
        cordinator.selected = withView
        return cordinator
    }

    func makeTabbarCoordinator(dataController: DataController, appDIContainer : AppDIContainer) -> (configurator: Coordinator & TabBarCoordinatorOutput, toPresent: Presentable?) {
        let controller = TabBarViewController.controllerFromStoryboard(.dashboard)
        controller.dataController = dataController
        controller.appDIContainer  = appDIContainer
        let coordinator = TabbarCoordinator(tabbarView: controller, coordinatorFactory: CoordinatorFactoryImpl(), dataController: dataController, appDIContainer: appDIContainer)
        return (coordinator, controller)
    }
    
    func makeHomeCoordinator() -> Coordinator & DashBoardCoordinator {
        return makeHomeCoordinator(navController: nil, appDIContainer: AppDIContainer())
    }
 
    
    func makeHomeCoordinator(navController: UINavigationController? = nil, dataController: DataController? = nil,
                             appDIContainer : AppDIContainer) -> DashBoardCoordinator & Coordinator {
        let coordinator = HomeFeatureCoordinator(router: router(navController), factory: ModuleFactoryImpl(), dataController: dataController ?? DataController(modelName: "WayaPayCoreData"), appDIContainer: appDIContainer)
        return coordinator
    }
    
    func makeDiscoverCoordinator() -> Coordinator {
        return makeDiscoverCoordinator(navController: nil)
    }
    
    func makeDiscoverCoordinator(navController: UINavigationController? = nil) -> Coordinator {
        let coordinator = DiscoverCoordinator(router: router(navController), factory: ModuleFactoryImpl())
        return coordinator
    }
    
    func makeWalletCoordinator() -> DashBoardCoordinator & Coordinator {
        return makeWalletCoordinator(navController: nil)
    }
    
    func makeWalletCoordinator(navController: UINavigationController? = nil) -> DashBoardCoordinator & Coordinator {
        let coordinator = WalletCoordinator(router: router(navController), factory: ModuleFactoryImpl())
        return coordinator
    }
    
    
    func makeNotificationCoordinator() -> Coordinator {
        return makeNotificationCoordinator(navController: nil)
    }
    
    func makeNotificationCoordinator(navController: UINavigationController? = nil) -> Coordinator {
        let coordinator = NotificationCoordinator(router: router(navController), factory: ModuleFactoryImpl())
        return coordinator
    }
    
    func makeChatCoordinator() -> Coordinator {
        return makeChatCoordinator(navController: nil)
    }
    
    func makeChatCoordinator(navController: UINavigationController? = nil) -> Coordinator {
        let coordinator = ChatCoordinator(router: router(navController), factory: ModuleFactoryImpl())
        return coordinator
    }
    
    func makeAuthCoordinatorBox(router: Router) -> AuthCoordinatorOutput & Coordinator {
        let coordinator = AuthCoordinator(router: router, factory: ModuleFactoryImpl())
        print("The auth coord")
        return coordinator
    }
    
    func makeOnboardingCoordinator(router: Router) -> Coordinator & OnboardingCoordinatorOutput {
        return OnboardingCoordinator(with: ModuleFactoryImpl(), router: router)
    }
    
    private func router(_ navController: UINavigationController?) -> Router {
        return RouterImp(rootController: navigationController(navController))
    }
    
    private func navigationController(_ navController: UINavigationController?) -> UINavigationController {
        if let navController = navController { return navController }
        else { return UINavigationController.controllerFromStoryboard(.dashboard) }
    }
}
