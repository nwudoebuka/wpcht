//
//  CoordinatorFactory.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/2/21.
//
protocol CoordinatorFactory {
    func makeTabbarCoordinator(dataController: DataController, appDIContainer : AppDIContainer) -> (configurator: Coordinator & TabBarCoordinatorOutput, toPresent: Presentable?) 
    func makeAuthCoordinatorBox(router: Router) -> Coordinator & AuthCoordinatorOutput
    
    func makeOnboardingCoordinator(router: Router) -> Coordinator & OnboardingCoordinatorOutput
    
    func makeHomeCoordinator() -> Coordinator & DashBoardCoordinator
    func makeHomeCoordinator(navController: UINavigationController?, dataController: DataController?, appDIContainer : AppDIContainer) -> Coordinator & DashBoardCoordinator
    
    func makeDiscoverCoordinator() -> Coordinator
    func makeDiscoverCoordinator(navController: UINavigationController?) -> Coordinator
    
    func makeChatCoordinator() -> Coordinator
    //func makeProfileCoordinator() -> Coordinator
    func makeChatCoordinator(navController: UINavigationController?) -> Coordinator
    
    func makeNotificationCoordinator() -> Coordinator
    func makeNotificationCoordinator(navController: UINavigationController?) -> Coordinator 
    
    func makeWalletCoordinator() -> Coordinator & DashBoardCoordinator
    func makeWalletCoordinator(navController: UINavigationController?) -> Coordinator & DashBoardCoordinator
    
    func makeSettingsCoordinator(router: Router, withView: SettingsView?) -> Coordinator & SettingsCoordinator
  }
