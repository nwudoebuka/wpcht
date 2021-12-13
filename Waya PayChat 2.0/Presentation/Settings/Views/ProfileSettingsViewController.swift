//
//  ProfileSettingsViewController.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 15/07/2021.
//

import UIKit
import ScrollableView

class ProfileSettingsViewController: ScrollableView, SettingsView, Alertable {

    
    var present: ((UIViewController) -> Void)?
    var optionSelected: ((SettingsView?) -> Void)?
//    var option: SettingsOptions! //UserSetting = .profile
//    var option: Options = UserOptions.PaymentSettings
    var onBack: ((_ logout: Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hex: "#F8F8F8")
        self.setup()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = UIColor(hex: "#E5E5E5")
        content.spacing = 8
        
        let backBtn = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backBtn
        title = "Settings"
        generateButtons()
        
    }
    
    func generateButtons() {
        let buttons = ProfileSettings.allCases.map { (setting: ProfileSettings) -> LargeButton in
            let btn = LargeButton(title: setting.text.title, subtitle: setting.text.subtitle)
            btn.onTap.subscribe(with: self) {[weak self] () in
                DispatchQueue.main.async {
                    guard let controller = setting.controller else {
                        self?.showAlert(message: "Coming Soon")
                        return
                    }
                    self?.optionSelected?(controller)
                }
            }
            return btn
        }
        self.addViews(buttons)
        for (index, btn) in buttons.enumerated() {
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.clipsToBounds = false
            if(index == 0) {
                btn.topAnchor.constraint(equalTo: content.topAnchor, constant: 8).isActive = true
                btn.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -23).isActive = true
            }
            NSLayoutConstraint.activate([
                btn.heightAnchor.constraint(equalToConstant: 52),
                btn.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 22),
                btn.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -23),
            ])
        }
    }
    
    @objc func back() {
        self.onBack?(false)
    }
}
