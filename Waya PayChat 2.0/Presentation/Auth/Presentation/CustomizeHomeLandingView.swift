//
//  CustomHomeContentViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/5/21.
//

import UIKit

final class CustomizeHomeLandingView: UIViewController, SelectLandingPageView, CustomHomePagerViewControllerDelegate{
    var onBack: ((Bool) -> Void)?
    
    var optionSelected: ((SettingsView?) -> Void)?
    
    var present: ((UIViewController) -> Void)?
    var finishAuthFlow :(() -> Void)?

    var currentIndex_ = 0
    let pageSelectorController: CustomHomePagerViewController = CustomHomePagerViewController()
    
    func didUpdatePageIndex(currentIndex: Int) {
        currentIndex_ = currentIndex
        updateUI()
    }
    
    
    var pageControl  : UIPageControl = {
       let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.frame.size = CGSize(width: 300, height: 30)
        pageControl.pageIndicatorTintColor = UIColor(named: "color-gray4")
        pageControl.currentPageIndicatorTintColor =  UIColor(named: "color-gray2")
        return pageControl
    }()
    
    lazy var button : UIButton = {
        let button = UI.button(title: "Select")
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()
    
    var onFinish: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageSelectorController.onBoardingDelegate = self
        pageSelectorController.view.translatesAutoresizingMaskIntoConstraints = false
        pageSelectorController.view.backgroundColor = UIColor.black
        view.addSubview(pageSelectorController.view)
       
        view.addSubview(pageControl)
        
        view.addSubview(button)
        pageSelectorController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pageSelectorController.view.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        pageSelectorController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageSelectorController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageSelectorController.view.heightAnchor.constraint(equalToConstant: view.frame.height * 0.8).isActive = true
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        button.widthAnchor.constraint(equalToConstant: view.frame.width - 60).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -56).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        pageControl.topAnchor.constraint(equalTo: button.topAnchor, constant: -50).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.currentPage = 0
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        super.viewDidAppear(animated)
    }
    
    @objc func didTapButton(_ sender: Any){
        if auth.data.profile != nil {
            switch currentIndex_ {
            case 0:
                auth.prefs.defaultView = .wayapay
            case 1:
                auth.prefs.defaultView = .wayachat
            case 2:
                auth.prefs.defaultView = .wayagram
            default:
                break
            }
            auth.updateLocalPrefs()
            finishAuthFlow?()
        } else {
            print("unable to set default page, user not authenticated")
        }
    }
    
    func updateUI(){
        pageControl.currentPage = currentIndex_
        pageSelectorController.currentIndex = currentIndex_
        pageSelectorController.onBoardingDelegate = self
    }
    
}
