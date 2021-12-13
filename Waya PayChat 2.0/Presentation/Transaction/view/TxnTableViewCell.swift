//
//  TxnTableViewCell.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 31/08/2021.
//

import UIKit

class TxnTableViewCell: UITableViewCell {
    
    var nameLabel : UILabel!
    var amountLabel : UILabel!
    var timLabel : UILabel!
    var statuslabel : UILabel!
    var profileImageView : UIImageView!
    var txnResp : TransactionResponse!
    
    static let identifier = "TxnHistoryViewCell"
    
 
    var nameStack : UIStackView!
    var amountStack : UIStackView!
    var generalStack : UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:\(coder)) has not been implemented")
    }

    private func setUpView(){
        nameLabel = latoTextRegular(text: "Ebuka",textColor: .black)
        timLabel = latoTextRegular(text: "12:00 PM", textColor: UIColor(named: "tab-item_default-color") ?? .black)
        amountLabel = latoTextRegular(text: "N 10,000")
        amountLabel.textAlignment = .right
        statuslabel = latoTextRegular(text: "Pending Approval",textColor: .red)
        statuslabel.textAlignment = .right
        
        nameStack = generateStackView(axis: .vertical)
        nameStack.spacing = 4
        nameStack.addArrangedSubview(nameLabel)
        nameStack.addArrangedSubview(timLabel)
        amountStack = generateStackView(axis: .vertical)
        amountStack.alignment = .trailing
        amountStack.addArrangedSubview(amountLabel)
        amountStack.addArrangedSubview(statuslabel)
        profileImageView = generateProfileImageView()
        generalStack = generateStackView()
        generalStack.distribution = .equalSpacing
        generalStack.addArrangedSubview(nameStack)
        generalStack.addArrangedSubview(amountStack)
        //
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0), size: CGSize(width: 42, height: 42))
        addSubview(generalStack)
        generalStack.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: UIEdgeInsets(top: 20, left: 12, bottom: 0, right: 0))

        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0), size: CGSize(width: 42, height: 60))

    }
    
    func configureWithWalletHistory(txnResp : TransactionResponse){
        self.txnResp = txnResp
        self.nameLabel.text = txnResp.accountNo
        self.amountLabel.text = "N "+String(format: "%.1f", txnResp.tranAmount!)
        self.timLabel.text = txnResp.transactionTime
        let status = txnResp.debitCredit
       if status == "DEBIT"{
            self.statuslabel.text = status
            self.statuslabel.textColor = .red
            self.amountLabel.text = "- N "+String(format: "%.1f", txnResp.tranAmount!)
            self.amountLabel.textColor = .red
        }else{
            self.statuslabel.text = status
            self.statuslabel.textColor = UIColor(named: "color-green")
            self.amountLabel.text = "+ N "+String(format: "%.1f", txnResp.tranAmount!)
            self.amountLabel.textColor = UIColor(named: "color-green")
        }
        
    }
}

