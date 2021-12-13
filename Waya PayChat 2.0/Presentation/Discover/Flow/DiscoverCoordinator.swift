//
//  DiscoverCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/7/21.
//

final class DiscoverCoordinator: BaseCoordinator {
    
    private let factory: DiscoverFactoryModule
    private let router: Router
    
    init(router: Router, factory: DiscoverFactoryModule) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showDiscoverDefault()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showDiscoverDefault() {
        let discoverFlowOutput = factory.makeDiscoverOutput()
        router.setRootModule(discoverFlowOutput)
    }
}
