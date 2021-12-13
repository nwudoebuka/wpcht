//
//  SettingsCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 15/07/2021.
//

import Foundation

final class SettingsCoordinator: BaseCoordinator, SettingsCoordinatorOutput {
    var finishFlow: (() -> Void)?
    
    private let factory: SettingsModuleFactory
    private let router: Router
    var selected: SettingsView?
    
    init(router: Router, coordinator: SettingsModuleFactory) {
        self.router = router
        self.factory = coordinator
    }
    
    override func start() {
        showSettingsDefault()
    }
    
    private func showSettingsDefault() {
        var output = factory.makeSettingsOutput()
        output.onBack = { [weak self] (logout) in
            self?.finishFlow?()
        }
        output.optionSelected = { [weak self] (controller) in
            self?.showView(controller)
        }
        router.setRootModule(output.toPresent())
        if selected != nil {
            self.showView(selected)
        }
    }
    
    private func showView(_ controller: SettingsView?) {
        guard var controller = controller else {
            return
        }
        controller.onBack = { (logout) in
            DispatchQueue.main.async {
                if logout == true {
                    self.finishFlow?()
                } else {
                    self.router.popModule()
                }
            }
        }
        
        controller.optionSelected = { [weak self] (view) in
            self?.showView(view)
        }
        
        controller.present = { [weak self] (view) in
            self?.router.push(view, hideBottomBar: true)
        }
        router.push(controller)
    }
}
