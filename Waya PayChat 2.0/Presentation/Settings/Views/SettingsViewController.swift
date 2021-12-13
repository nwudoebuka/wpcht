//
//  SettingsViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 13/07/2021.
//

import UIKit
import ScrollableView
import Signals

final class SettingsViewController: ScrollableView, SettingsView, Alertable {
    var present: ((UIViewController) -> Void)?
    var optionSelected: ((SettingsView?) -> Void)?
    var onBack: ((_ logout: Bool) -> Void)?
    
    lazy var header: UIView = {
        return ProfileHeader.new()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
        initView()
    }
    
    func initView() {
        view.backgroundColor = UIColor(hex: "#E5E5E5")
        content.spacing = 8
        
        let backBtn = UIBarButtonItem(image: UIImage(named: "back-arrow"), style: .plain, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backBtn
        title = "Settings"
        
        self.addViews([header])
        
        NSLayoutConstraint.activate([
            header.heightAnchor.constraint(equalToConstant: 170),
            header.widthAnchor.constraint(equalTo: content.widthAnchor)
        ])
        generateButtons()
    }
    
    @objc private func back() {
        self.onBack?(false)
    }
    
    func generateButtons() {
        let buttons = MainSettings.allCases.map { (setting: MainSettings) -> LargeButton in
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
        buttons.forEach {
            NSLayoutConstraint.activate([
                $0.heightAnchor.constraint(equalToConstant: 52),
                $0.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 22),
                $0.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -23),
            ])
            $0.clipsToBounds = false
        }
    }
}
