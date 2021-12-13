//
//  OnboardingCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/3/21.
//

class OnboardingCoordinator: BaseCoordinator, OnboardingCoordinatorOutput {
    
    var finishFlow: (() -> Void)?
    
    private let factory: OnboardingModuleFactory
    private let router: Router
    
    init(with factory: OnboardingModuleFactory, router: Router) {
        self.factory = factory
        self.router = router
    }
    
    override func start() {
        showOnboarding()
    }
    
    func showOnboarding() {
        let onboardingModule = factory.makeOnboardingModule()
        onboardingModule.onFinish = { [weak self] in
            self?.finishFlow?()
        }
        router.setRootModule(onboardingModule.toPresent())
    }
}
