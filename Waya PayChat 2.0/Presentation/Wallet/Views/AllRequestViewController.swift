//
//  AllRequestViewController.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/10/21.
//

protocol AllRequestView : BaseView {
    
}

class AllRequestViewController: UIViewController, AllRequestView {

    let walletViewModel : WalletViewModelImpl
    
    init(walletViewModel : WalletViewModelImpl){
        self.walletViewModel = walletViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init \(coder) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "Data Purchase"
        navigationController?.navigationBar.tintColor = UIColor(named: "toolbar-color-secondary")

        //temporarily added to launch only Wayapay to be removed af 
        showComingSoonView()
    }
    



}
