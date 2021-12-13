//
//  HomeCoordinator.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/7/21.
//

final class HomeFeatureCoordinator: BaseCoordinator, DashBoardCoordinator {
    var navToTransactions: (() -> Void)?
    
    var navToSettings: ((SettingsView?) -> Void)?
    var toogleMenu: (() -> Void)?
    
    private let factory: HomeFactoryModule
    private let router: Router
    let dataController : DataController
    let appDIContainer : AppDIContainer
    let wayagramViewModel: WayagramViewModel = WayagramViewModelImpl()
    
    init(router: Router, factory: HomeFactoryModule, dataController : DataController, appDIContainer : AppDIContainer) {
        self.factory = factory
        self.router = router
        self.dataController = dataController
        self.appDIContainer = appDIContainer
    }
    
    override func start() {
        
        if auth.data.wayagramSetup == false {
            showWayagramSetup()
        } else {
            showHome()
        }
    }
    
    //MARK: - Run current flow's controllers
    private func showHome() {
        let homeFlowOutput = factory.makeHomeOutput(dataController: dataController, 
                                                    wayagramViewModel: appDIContainer.makeWayagramViewModel())
        homeFlowOutput.onNavToogle = { [weak self] in
            self?.toogleMenu?()
        }
        homeFlowOutput.showCreateMoment = {[weak self] in
            self?.showCreateMomentView()
        }
        homeFlowOutput.showCreatePost = {[weak self] (dataController) in
            self?.showCreatePostView(dataController)
        }
    
        homeFlowOutput.showHomeFollowing = { [weak self] in
            self?.showHomeFollowingView()
        }
        homeFlowOutput.showPostDetail = {[weak self] (wayagramViewModel) in
            self?.showPostDetailView(wayagramView: wayagramViewModel)
            
        }
        
        homeFlowOutput.showCommentView = {[weak self] 
            (waygraViewModel) in
            self?.showCommentView(wayagramView: waygraViewModel)
        }
        router.setRootModule(homeFlowOutput)
    }
    
    private func showCreatePostView(_ dataController : DataController){
        let createPostView = factory.makeCreatePostView(dataController: dataController)
        router.push(createPostView, hideBottomBar: true)
    }
    
    private func showCreateMomentView(){
        let createMomentView = factory.makeCreateMomentView()
        router.push(createMomentView, hideBottomBar: true)
    }
    
    private func showHomeFollowingView(){
        let homeFollowingView = factory.makeHomeFollowingView()
        homeFollowingView.navBack = { [weak self] in
            self?.router.popModule(animated: true)
        }
        router.push(homeFollowingView, hideBottomBar: true)
    }
    
    private func showCommentView(wayagramView: WayagramViewModelImpl){
        let commentView = factory.makeCommentView(wayagramViewModel: wayagramView)
        commentView.navBack = {[weak self] in
            self?.router.popModule()
        }
        router.push(commentView)
    }
    
    private func showPostDetailView(wayagramView: WayagramViewModelImpl){
        let postDetailView = factory.makePostDetailView(wayagramViewModel: wayagramView)
        postDetailView.navBack = {[weak self] in
            self?.router.popModule()
        }
        router.push(postDetailView, hideBottomBar: true)
    }
    
    private func showWayagramSetup() {
        let setupView = WayagramSetupViewController()
        setupView.onBack = {
            self.showHome()
        }
        
        setupView.onFinish = {
            auth.data.wayagramSetup = true
            auth.updateLocalPrefs()
            self.wayagramViewModel.followWaya()
            self.showHome()
            auth.refreshProfile()
        }
        router.push(setupView, hideBottomBar: true)
    }
}
