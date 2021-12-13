//
//  HomeView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/7/21.
//

protocol HomeView : BaseView {
    var onNavToogle: (() -> Void)? { get set }
    var showCreatePost : ((_ dataController : DataController) -> Void)? { get set }
    var showCreateMoment : (() -> Void)? { get set }
    var showHomeFollowing : (() -> Void)? { get set }
    var showPostDetail : ((_ wayagramViewModel: WayagramViewModelImpl) -> Void)? {get set}
    var showCommentView : ((_ wayagramViewModel: WayagramViewModelImpl) -> Void)? {get set}
}

