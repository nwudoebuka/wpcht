//
//  WayagramSetupViewController.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 26/08/2021.
//

import Foundation
import Signals

protocol WayagramSetupView: UIView {
    var onError: ((String) -> Void)? { get set}
    var onBack: (() -> Void)? { get set}
}

final class WayagramSetupViewController: UIViewController, Alertable {
    
    lazy var interestView: InterestsView = {
        return InterestsView(frame: UIScreen.main.bounds)
    }()
    
    lazy var handleView: HandleView = {
        return HandleView(frame: UIScreen.main.bounds)
    }()
    
    lazy var recommendationsView: RecommendationsView = {
        return RecommendationsView(frame: UIScreen.main.bounds)
    }()
    
    var currentIndex = 0
    let viewWidth = UIScreen.main.bounds.width
    
    let wayagramViewModel = WayagramViewModelImpl()
    var onBack: (() -> Void)?
    var onFinish: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        initView()
    }
    
    private func initView() {
        self.view.backgroundColor = .white
        self.view.addSubviews([interestView, handleView, recommendationsView])
        
        interestView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        handleView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        recommendationsView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        handleView.isHidden = true
        recommendationsView.isHidden = true
        
        
        self.addActions()
        getInterests()
    }
    
    private func addActions() {
        interestView.onSelect.subscribe(with: self) { (interest) in
            self.saveInterest(interest: interest)
        }
        interestView.onBack = {
            self.onBack?()
        }
        interestView.onContinue.subscribe(with: self) { [weak self] in
            if self?.interestView.selected.count == 0 {
                guard let random = self?.interestView.interests.randomElement() else {
                    return
                }
                self?.saveInterest(interest: random)
            }
            self?.forward()
        }
        
        handleView.onContinue.subscribe(with: self) {
            let handle = self.handleView.handleInput.text
            self.saveHandle(handle: handle)
        }
        
        handleView.onError = { (error) in
            self.showAlert(message: error)
        }
        
        recommendationsView.onError = { (error) in
            self.showAlert(message: error)
        }
        
        recommendationsView.onFollow.subscribe(with: self) { (suggestion, follow) in
            self.followUser(user: suggestion, follow: follow)
        }
        
        recommendationsView.onFinish.subscribe(with: self) {
            self.onFinish?()
        }
    }
    
    private func getInterests() {
        if let profile = auth.data.wayagramProfile {
            LoadingView.show()
            wayagramViewModel.getUserNewInterests(profileId: profile.id) { (result) in
               LoadingView.hide()
                switch result {
                case .success(let interests):
                    guard let interests = interests as? [UserInterest] else {
                        return
                    }
                    self.interestView.interests = interests
                    self.interestView.reload()
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func loadFollowSuggestions() {
        LoadingView.show()
        wayagramViewModel.getSuggestedFollows { (result) in
            LoadingView.hide()
            switch result {
            case .success(let follows):
                guard let follows = follows as? [SuggestFriendProfiles] else {
                    return
                }
                self.recommendationsView.suggested = follows
                self.recommendationsView.recommended.reloadData()
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func followUser(user: SuggestFriendProfiles, follow: Bool) {
        LoadingView.show()
        wayagramViewModel.followUser(username: user.username, follow: follow) { (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func saveInterest(interest: UserInterest) {
        wayagramViewModel.saveUserInterests(interest: interest.id) { (result) in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func forward() {
        switch currentIndex {
        case 0:
            self.interestView.isHidden = true
            self.handleView.isHidden = false
            self.view.bringSubviewToFront(handleView)
            currentIndex += 1
        case 1:
            self.handleView.isHidden = true
            self.recommendationsView.isHidden = false
            currentIndex += 1
            self.loadFollowSuggestions()
        default:
            break
        }
    }
    
    private func saveHandle(handle: String) {
        let username: String
        if handle.starts(with: "@") {
            username = handle.substring(1)
        } else {
            username = handle
        }
        LoadingView.show()
        let userId = String(auth.data.userId!)
        let displayName = "\(auth.data.profile!.firstName) \(auth.data.profile!.lastName)"
        let update = UpdateWayagramProfile(avatar: nil, coverImage: nil, user_id: userId, username: username, notPublic: nil,displayName: displayName)
        wayagramViewModel.updateWayagramProfile(updateWayagramProfile: update) { [weak self] (result) in
            LoadingView.hide()
            switch result {
            case .success(_):
                self?.forward()
            case .failure(let error):
                self?.showAlert(message: error.localizedDescription)
            }
        }
    }
}

