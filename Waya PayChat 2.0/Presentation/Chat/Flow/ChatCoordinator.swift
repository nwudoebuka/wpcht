//
//  ChatCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/7/21.
//


final class ChatCoordinator: BaseCoordinator {
    
    private let factory: ChatFactoryModule
    private let router: Router
    
    init(router: Router, factory: ChatFactoryModule) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showChatDefault()
    }
    
    //MARK: - Run current flow's controllers
    
    private func showChatDefault() {
        let chatFlowOutput = factory.makeChatOutput()
        router.setRootModule(chatFlowOutput)
    }
}
