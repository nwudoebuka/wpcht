//
//  HomeFactoryModule.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/7/21.
//


protocol HomeFactoryModule {
    func makeHomeOutput(dataController : DataController, wayagramViewModel : WayagramViewModelImpl) -> HomeView
    func makeCreateMomentView() -> CreateMomentView
    func makeCreatePostView(dataController : DataController) -> CreatePostView
    func makeHomeFollowingView() -> HomeFollowingView
    func makePostDetailView(wayagramViewModel : WayagramViewModelImpl) -> PostDetailView
    func makeCommentView(wayagramViewModel : WayagramViewModelImpl) -> CommentView
}
