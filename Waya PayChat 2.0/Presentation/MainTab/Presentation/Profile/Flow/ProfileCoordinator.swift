//
//  ProfileCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 06/09/2021.


final class ProfileCoordinator: BaseCoordinator{
    var navToFollowing: (() -> Void)?
    
    private let factory: ProfileFactoryModule
    private let router: Router
    
    init(router: Router, factory: ProfileFactoryModule) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        //showWalletDefault()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showFollowing() {
        let profileFlowOutput = factory.makeFollowingOutput()
        
        router.setRootModule(profileFlowOutput)
    }
    
   
}
