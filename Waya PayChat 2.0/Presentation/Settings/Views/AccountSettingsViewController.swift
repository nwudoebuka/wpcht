//
//  AccountSettingsViewController.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 25/08/2021.
//

import UIKit
import Signals

enum AccountOptions {
    case account_privacy
    case chat_privacy
    case read_receipt
    case security
    
    var title: String {
        switch self {
        case .account_privacy:
            return "Account privacy"
        case .chat_privacy:
            return "Chat privacy"
        case .read_receipt:
            return "Read receipt"
        case .security:
            return "Receive notification when one of your\ncontact security code changes"
        }
    }
}

fileprivate class AccountOption: UIView {
    var value: AccountOptions!
    let toggled = Signal<(AccountOptions, Bool)>()
    var toggle_switch: UISwitch!
    
    lazy var title: UILabel = {
        let txt = UI.text(string: "")
        txt.numberOfLines = 0
        txt.font = UIFont(name: "Lato-Regular", size: 15)
        return txt
    }()
    override init(frame: CGRect) {
        super.init(frame: .zero)
        initView()
    }
    
    convenience init(value: AccountOptions) {
        self.init()
        self.value = value
        self.title.text = value.title
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initView() {
        toggle_switch = UISwitch()
        self.addSubviews([title, toggle_switch])
        toggle_switch.translatesAutoresizingMaskIntoConstraints = false
        toggle_switch.isUserInteractionEnabled = true
        
        title.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 60))
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            toggle_switch.heightAnchor.constraint(equalToConstant: 16),
            toggle_switch.widthAnchor.constraint(equalToConstant: 33),
            toggle_switch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            toggle_switch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24)
        ])
        
        toggle_switch.onValueChanged.subscribe(with: self, callback: {
            self.toggled => (self.value, self.toggle_switch!.isOn)
        })
        
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
}

final class AccountSettingsViewController: UIViewController, SettingsView, Alertable {
    var onBack: ((Bool) -> Void)?
    var optionSelected: ((SettingsView?) -> Void)?
    var present: ((UIViewController) -> Void)?
    
    fileprivate var accountPrivacy: AccountOption!
    fileprivate var chatPrivacy: AccountOption!
    fileprivate var readReceipt: AccountOption!
    fileprivate var security: AccountOption!
    
    private var deleteAccount: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        title = "Account"
        self.view.backgroundColor = .white
        
        let privacyTitle = UI.text(string: "Privacy", style: .bold, color: nil)
        privacyTitle.font = UIFont(name: "Lato-Regular", size: 19)?.bold
        
        let securityTitle = UI.text(string: "Security", style: .bold, color: nil)
        securityTitle.font = UIFont(name: "Lato-Regular", size: 19)?.bold
        
        accountPrivacy = AccountOption(value: .account_privacy)
        accountPrivacy.translatesAutoresizingMaskIntoConstraints = false
        
        chatPrivacy = AccountOption(value: .chat_privacy)
        chatPrivacy.translatesAutoresizingMaskIntoConstraints = false
        
        readReceipt = AccountOption(value: .read_receipt)
        readReceipt.translatesAutoresizingMaskIntoConstraints = false
        
        security = AccountOption(value: .security)
        security.translatesAutoresizingMaskIntoConstraints = false
        deleteAccount = UI.button(title: "Delete my account", icon: nil, style: ButtonStyle.none, state: .active)
        
        self.view.addSubviews([
            privacyTitle, accountPrivacy, chatPrivacy,
            readReceipt, securityTitle, deleteAccount,
            security
        ])
        
        privacyTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 30, left: 24, bottom: 0, right: 0))
        accountPrivacy.anchor(top: privacyTitle.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        accountPrivacy.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        chatPrivacy.anchor(top: accountPrivacy.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        chatPrivacy.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        readReceipt.anchor(top: chatPrivacy.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        readReceipt.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        securityTitle.anchor(top: readReceipt.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 35, left: 24, bottom: 0, right: 0))
        
        security.anchor(top: securityTitle.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        security.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        deleteAccount.anchor(top: security.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing:nil, padding: UIEdgeInsets(top: 11, left: 24, bottom: 0, right: 0))
        deleteAccount.heightAnchor.constraint(equalToConstant: 40).isActive = true
//        deleteAccount.widthAnchor.constraint(equalToConstant: 100).isActive = true
        deleteAccount.setTitleColor(.black, for: .normal)
        addActions()
        setSwitches()
        
    }
    
    private func setSwitches() {
        accountPrivacy.toggle_switch.setOn(auth.data.wayagramProfile!.notPublic, animated: false)
    }
    
    private func addActions() {
        accountPrivacy.toggled.subscribe(with: self) { (option, value) in
            self.change(option: option, value: value)
        }
        deleteAccount.addTarget(self, action: #selector(promptDeleteAccount), for: .touchUpInside)
    }
    
    private func change(option: AccountOptions, value: Bool) {
        let userId = String(auth.data.userId!)
        let profile = auth.data.wayagramProfile
        switch option {
        case .account_privacy:
            let model = WayagramViewModelImpl()
            let update = UpdateWayagramProfile(
                avatar: nil, coverImage: nil,
                user_id: userId, username: profile?.username, notPublic: value, displayName: nil)
            model.updateWayagramProfile(updateWayagramProfile: update) { (result) in
                switch result {
                case .success(_):
                    self.showAlert(message: "Privacy updated")
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        default:
            break
        }
    }
    
    @objc func promptDeleteAccount() {
        self.showSimpleTwoOptionAlert(title: "Delete Account?", messageTitle: "YES, CONTINUE", body: "Your account will be deleted! please confirm that you wish to proceeed") {
            self.deleteUserAccount()
        }
    }
    
    private func deleteUserAccount() {
        LoadingView.show()
        let authViewModel = AuthViewModelImpl()
        authViewModel.deleteUserAccount { (result) in
            LoadingView.hide()
            switch result {
            case .success(let message):
                if let message = message as? String {
                    let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        DispatchQueue.main.async {
                            auth.logout()
                            self.onBack?(true)
                        }
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    return
                }
            case .failure(let error):
                self.showAlert(message: error.localizedDescription)
            }
        }
    }
}
