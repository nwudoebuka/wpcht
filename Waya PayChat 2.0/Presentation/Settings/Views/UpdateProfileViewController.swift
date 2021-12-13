//
//  UpdateProfileViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 26/07/2021.
//

import UIKit

class UpdateProfileViewController: UIViewController, SettingsView, Alertable {
    var onBack: ((Bool) -> Void)?
    var optionSelected: ((SettingsView?) -> Void)?
    var present: ((UIViewController) -> Void)?
    
    var rightBarButton: UIBarButtonItem = {
        let btn = UIBarButtonItem.init(image: UIImage(named: "close-icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back))
        return btn
    }()
    var leftBarButton: UIBarButtonItem!

    let profileViewModel = ProfileViewModelImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNav()
    }
    
    func setupNav() {
        view.backgroundColor = .white
        title = "Edit Profile"
        leftBarButton = UIBarButtonItem.init(image: UIImage(named: "back-arrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(back))
        leftBarButton.tintColor = .black
        
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back-arrow")
        restoreNavLine()
              
//        self.navigationItem.rightBarButtonItems = [rightBarButton]
        self.navigationItem.leftBarButtonItems = [leftBarButton]
    }
    
    @objc func back() {
        self.onBack?(false)
    }

}
