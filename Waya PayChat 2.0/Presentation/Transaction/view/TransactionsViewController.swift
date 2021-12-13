//
//  TransactionsViewController.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 31/08/2021.
//

import UIKit

class TransactionsViewController: UIViewController,TransactionView {
    var auth = AuthService.shared()
    var rightBarButton2 = UIBarButtonItem()
    var rightBarButton = UIBarButtonItem()
    private let historyTableView : UITableView = {
        let table = UITableView()
        table.register(TxnTableViewCell.self, forCellReuseIdentifier: TxnTableViewCell.identifier)
        table.separatorStyle = UITableViewCell.SeparatorStyle.none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    let transactionViewModel : TransactionViewModelImpl!
    lazy var noTxnLbl:UILabel = {
        let noTxnLbl = UILabel()
        noTxnLbl.text = "You currently have no transactions"
        noTxnLbl.textColor = .gray
        return noTxnLbl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNav()
        initView()
        self.transactionViewModel.getTransactions(accountNumber: "2012233126", completion: {_ in
            print("history is \(self.auth.data.txnHistory)")
            self.historyTableView.reloadData()
            })
        print("history now is \(self.auth.data.txnHistory)")
        self.historyTableView.reloadData()
    }
    init(transactionViewModel : TransactionViewModelImpl){
        self.transactionViewModel = transactionViewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init\(coder) has not been implemented")
    }
    func setUpNav(){
        title = "Transaction History"
        rightBarButton2.tintColor = UIColor(named: "toolbar-color-secondary")
        rightBarButton2 = UIBarButtonItem.init(image: UIImage(named: "searchtxn")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        rightBarButton.tintColor = UIColor(named: "toolbar-color-secondary")
        rightBarButton = UIBarButtonItem.init(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
 
        navigationItem.rightBarButtonItems = [rightBarButton, rightBarButton2]
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back-arrow")
        restoreNavLine()
        
        title = "Transactions"
        
        self.navigationItem.rightBarButtonItems = [rightBarButton, rightBarButton2]
    }

    
    func initView(){
        historyTableView.dataSource = self
        historyTableView.delegate = self
        view.addSubview(noTxnLbl)
        view.addSubview(historyTableView)
        historyTableView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor,padding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        noTxnLbl.centerInSuperview()
        noTxnLbl.alpha = 0
    }
    
}

extension TransactionsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionViewModel.txnResponse.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  historyTableView.dequeueReusableCell(withIdentifier: TxnTableViewCell.identifier) as! TxnTableViewCell
        cell.selectionStyle = .none
        cell.configureWithWalletHistory(txnResp: (transactionViewModel.txnResponse[indexPath.row]))
    print("seen cells")
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //for pagination
    }
    

    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
}
