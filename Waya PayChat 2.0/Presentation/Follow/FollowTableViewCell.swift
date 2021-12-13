//
//  FollowTableViewCell.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 06/09/2021.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    var nameLabel : UILabel!
    var userNameLabel : UILabel!
    var followBtn: UIButton = {
        let btn = UI.button(title: "Follow", icon: nil, style: .secondary, state: .active)
        btn.layer.borderWidth = 1.3
        btn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btn.layer.borderColor = Colors.orange.cgColor
        return btn
    }()
    var profileImageView : UIImageView!
    var txnWalletResp : TransactionWalletHistory!
    
    static let identifier = "followViewCell"
    
 
    var nameStack : UIStackView!
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
        userNameLabel = latoTextRegular(text: "12:00 PM", textColor: UIColor(named: "tab-item_default-color") ?? .black)
        
        nameStack = generateStackView(axis: .vertical)
        nameStack.spacing = 4
        nameStack.addArrangedSubview(nameLabel)
        nameStack.addArrangedSubview(userNameLabel)
        profileImageView = generateProfileImageView()
        generalStack = generateStackView()
        generalStack.distribution = .equalSpacing
        generalStack.addArrangedSubview(nameStack)
        generalStack.addArrangedSubview(followBtn)
        //
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0), size: CGSize(width: 42, height: 42))
        addSubview(generalStack)
        generalStack.anchor(top: topAnchor, leading: profileImageView.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: UIEdgeInsets(top: 20, left: 12, bottom: 0, right: 0))

        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil,padding: UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0), size: CGSize(width: 42, height: 42))

    }
    
    func configure(){
//        self.txnWalletResp = txnWalletResp
//        self.nameLabel.text = txnWalletResp.tranId
//        self.amountLabel.text = "N "+String(format: "%.1f", txnWalletResp.tranAmount!)
//        self.timLabel.text = txnWalletResp.tranDate
//        let status = txnWalletResp.del_flg
//        if status!{
//            self.statuslabel.text = "Received"
//            self.statuslabel.textColor = .green
//        }else{
//            self.statuslabel.text = "Sent"
//        }
        
    }

}
