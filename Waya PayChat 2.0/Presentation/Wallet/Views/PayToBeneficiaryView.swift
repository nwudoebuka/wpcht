//
//  PayToBeneficiaryView.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 10/06/2021.
//

import Foundation

protocol PayToBeneficiaryView: BaseView {
    var onPayToBeneficiarySuccess: (() -> Void)? {get set}
    var onClose:(() -> Void)? {get set}
}

class PayToBeneficiaryViewController: UIViewController, PayToBeneficiaryView, Alertable {
    
    var onClose: (() -> Void)?
    var onPayToBeneficiarySuccess: (() -> Void)?
    let walletViewModel : WalletViewModelImpl!
    
    lazy var beneficiariesView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(ContactSearchDropdownCell.self, forCellReuseIdentifier: "contacts")
        return view
    }()
    
    init(walletViewModel : WalletViewModelImpl){
        self.walletViewModel = walletViewModel
        super.init(nibName : nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavigation()
        setupView()
    }
    
    private func setUpNavigation(){
        title = "Saved Beneficiaries"
        self.navigationItem.hidesBackButton = true
        let  backBarButton = UIBarButtonItem.init(image: UIImage(named: "back-arrow")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleBackPressed))
        
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func handleBackPressed(sender: UIBarButtonItem) {
        // Perform your custom actions
        self.onClose?()
    }
    
    func setupView() {
        self.view.addSubview(beneficiariesView)
        beneficiariesView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
}
