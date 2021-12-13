//
//  WalletItemDetailViewController.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/12/21.
//
import UIKit

protocol WalletItemDetailView: BaseView {
    
}


class WalletItemDetailViewController: UIViewController, WalletItemDetailView, Alertable {

    let walletViewModel : WalletViewModelImpl!
    let transactionViewModel:TransactionViewModelImpl!
    var noHistorylabel:UILabel!
    var transparentBackground : UIView!
    var walletItemDropDown : WalletItemDropDownView!
    
    let topView  = UIView()
    var availableBalanceTitle : UILabel!
    var availableBalanceValue : UILabel!
    var walletHistoryData:TransactionWalletData?
    private let historyTableView : UITableView = {
        let table = UITableView()
        table.register(WalletHistoryTableViewCell.self, forCellReuseIdentifier: WalletHistoryTableViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    init(walletViewModel : WalletViewModelImpl,txnViewmodelImpl:TransactionViewModelImpl){
        self.walletViewModel = walletViewModel
        self.transactionViewModel = txnViewmodelImpl
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        walletHistoryData = walletViewModel.userWalletHistory
        print("wallet history is  \(walletViewModel.userWalletHistory)")
        getUserWalletHistory()
        setUpNav()
        initView()
    }
    func getTransactionHistory(){
        self.transactionViewModel.getTransactions(accountNumber: "2012233126",completion: nil)
    }
    func getUserWalletHistory(){
        print("get wallet history is \(walletViewModel.selectedWallet.accountNo)")
        walletViewModel.getWalletHistory(accountNumber: walletViewModel.selectedWallet.accountNo)
        historyTableView.reloadData()
    }
    private func setUpNav(){
        
        let title = "\(walletViewModel.selectedWallet.accountNo)\n\(walletViewModel.selectedWallet.acct_name)"
        navigationItem.titleView = navTitleWithImageAndText(titleText: title, imageName: "menu-icon-scan")
        navigationController?.navigationBar.tintColor = UIColor(named: "toolbar-color-secondary")
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.layoutIfNeeded()
        
        let  rightBarButton =  UIBarButtonItem.init(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(didTapDropDown))
        
        rightBarButton.tintColor = UIColor(named: "toolbar-color-secondary")
        
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func initView(){
        historyTableView.dataSource = self
        historyTableView.delegate = self
        availableBalanceValue = libreTextBold22(text: "N\(walletViewModel.selectedWallet.balance)", textSize: 24, color : UIColor(named: "toolbar-color-secondary") ?? .gray)
        availableBalanceTitle = libreTextRegular22(text: "Available Balance", textSize: 13, color :  UIColor(named: "toolbar-color-primary") ?? .gray)
        noHistorylabel = libreTextRegular22(text: "No wallet history", textSize: 13, color : .gray)
        noHistorylabel.textAlignment = .left
        let topViewStack = verticalStack(spacing: 2)
        topViewStack.addArrangedSubview(availableBalanceTitle)
        topViewStack.addArrangedSubview(availableBalanceValue)
        topViewStack.alignment = .center
        
        topView.addSubview(topViewStack)
        topViewStack.anchor(top: topView.topAnchor, leading: nil, bottom: nil, trailing: nil)
        topViewStack.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true
        
        let sideImage = UIImageView(image:  UIImage(named: "eccentric-line"))
        topView.addSubview(sideImage)
        sideImage.anchor(top: topView.topAnchor, leading: nil, bottom: topView.bottomAnchor, 
                         trailing: topView.trailingAnchor,
                         padding: UIEdgeInsets(top: 9, left: 0, bottom: 0, right: 0))
        
        
        view.addSubview(topView)
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, 
                       bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 47, left: 0, bottom: 0, right: 0)
        )
        topView.heightAnchor.constraint(equalToConstant: 84).isActive = true
      
        let shadowView = UIView()
        shadowView.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.3)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 0.4
        
        view.addSubview(shadowView)
        shadowView.anchor(top: topView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        shadowView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
        let walletHistoryLabel = libreTextBold22(text: "Wallet History", textSize: 16)
        view.addSubview(walletHistoryLabel)
        walletHistoryLabel.anchor(top: shadowView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 47, left: 16, bottom: 0, right: 0))
        
        view.addSubview(historyTableView)
        historyTableView.anchor(top: walletHistoryLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 17, bottom: 10, right: 17))
        
        view.addSubview(noHistorylabel)
        noHistorylabel.anchor(top: walletHistoryLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 20, left: 17, bottom: 10, right: 17))
        
       
        if (walletHistoryData != nil){
            checkIfHistoryIsEmpty()
        }
        
    }
    func checkIfHistoryIsEmpty(){
        if (walletHistoryData?.transactionHistory?.count)! < 1  || walletHistoryData == nil{
            noHistorylabel.alpha = 1
            historyTableView.alpha = 0
        }else{
            noHistorylabel.alpha = 0
            historyTableView.alpha = 1
        }
    }
    @objc func didTapDropDown(){
        if self.transparentBackground == nil{
            self.transparentBackground = UIView(frame: UIScreen.main.bounds)
            self.transparentBackground.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissWalletDropDownPopUp(_:)))
            tap.numberOfTapsRequired = 1
            self.transparentBackground.addGestureRecognizer(tap)
            self.transparentBackground.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.addSubview(self.transparentBackground)
            walletItemDropDown = setupOpaqueView()
            walletItemDropDown.translatesAutoresizingMaskIntoConstraints = false
            transparentBackground.addSubview(walletItemDropDown)
            walletItemDropDown.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            walletItemDropDown.trailingAnchor.constraint(equalTo: transparentBackground.trailingAnchor, constant: -17).isActive = true
            walletItemDropDown.heightAnchor.constraint(equalToConstant: 140).isActive = true
            walletItemDropDown.widthAnchor.constraint(equalToConstant: 260).isActive = true
            walletItemDropDown.isUserInteractionEnabled = true
            UIApplication.shared.keyWindow!.bringSubviewToFront(self.transparentBackground)
            self.view.bringSubviewToFront(self.transparentBackground)
            print("The default walllet \(walletViewModel.selectedWallet.datumDefault)")
            if walletViewModel.selectedWallet.datumDefault == true{
                walletItemDropDown.defaultWaletUISwitch.setOn(true, animated: false)
            }
            walletItemDropDown.defaultWaletUISwitch.addTarget(self, action: #selector(makeWalletDefaultWalletSwitch(_:)), for: .valueChanged)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }
    
    func setupOpaqueView() -> WalletItemDropDownView{
        let view = WalletItemDropDownView(frame: CGRect(x: 0, y: 0, width: 260, height: 140))
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
        
    }
    
    @objc func dismissWalletDropDownPopUp(_ sender: UITapGestureRecognizer? = nil){
        UIView.animate(withDuration: 0.3, animations: {
            self.transparentBackground.alpha = 0
        }) {  done in
            self.transparentBackground.removeFromSuperview()
            self.transparentBackground = nil
        }
    }
    
    @objc func makeWalletDefaultWalletSwitch(_ sender: UISwitch){
        if sender.isOn{
            // make wallet default 
            setDefaultWallet()
        } else{
            // disabled turned off because it cannot be turned off 
            sender.setOn(true, animated: true)
        }
    }
    
    func setDefaultWallet(){
        LoadingView.show()
        walletViewModel.setDefaultWallet(accountNumber: walletViewModel.selectedWallet.accountNo) {[weak self] (result) in
            LoadingView.hide()
            switch result{
                case .success(_):
                    break
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                    // return wallet back to false
                    self?.walletItemDropDown.defaultWaletUISwitch.setOn(false, animated: true)

            }
        }
    }
    
}

extension WalletItemDetailViewController  : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return walletHistoryData?.transactionHistory?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  historyTableView.dequeueReusableCell(withIdentifier: WalletHistoryTableViewCell.identifier) as! WalletHistoryTableViewCell
        cell.selectionStyle = .none
        cell.configureWithWalletHistory(txnWalletResp: (walletHistoryData?.transactionHistory?[indexPath.row])!)
    
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let size = CGSize(width: view.frame.width - 34, height: 1000)
//        let attributes = [NSAttributedString.Key.font: UIFont(name: "Lato-Regular", size: 16)]
//        let comment = comments[indexPath.row].comment
//        let estimatedFrame = NSString(string: comment).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes as [NSAttributedString.Key : Any], context: nil)
//        let height = estimatedFrame.height + 130
//        return height
//    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
}
