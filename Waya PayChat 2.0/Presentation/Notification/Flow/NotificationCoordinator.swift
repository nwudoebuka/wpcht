//
//  NotificationCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/7/21.
//

final class NotificationCoordinator: BaseCoordinator {
    
    private let factory: NotificationFactoryModule
    private let router: Router
    
    init(router: Router, factory: NotificationFactoryModule) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showNotification()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showNotification() {
        let notificationFlowOutput = factory.makeNotificationOutput()
        router.setRootModule(notificationFlowOutput)
    }
}
