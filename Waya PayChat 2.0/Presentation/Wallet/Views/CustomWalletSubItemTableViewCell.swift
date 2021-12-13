//
//  CustomWalletSubItemTableViewCell.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/12/21.
//

class CustomWalletSubItemTableViewCell: UITableViewCell {

    var action: (() -> Void)?
    static let identifier = "CustomWalletSubItemTableViewCell"
    
    let parentView : UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 10, width: Int(UIScreen.main.bounds.width) - 32, height: 80)) 
        view.layer.cornerRadius = 4
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: "color-gray3")?.withAlphaComponent(0.2).cgColor
        return view
    }()
     let walletImageView : UIImageView = {
        let imageView =  UIImageView()
        let w : CGFloat = 40
        imageView.frame.size.height = w
        imageView.frame.size.width = w
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 0.2
        return imageView
    }()
    
     let accountNumberLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "toolbar-color-secondary")
        label.font = UIFont(name: "Lato-Regular", size: 12)
        return label
    }()
    
     let balanceAmountLabel : UILabel = {
        let label = UILabel()
        label.text = ""
      //  label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "color-gray3")
        label.font = UIFont(name: "Lato-Regular", size: 12)
        return label
    }()
    
    let forwardButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "forward-arrow-light"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let numberStack = UIStackView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setUpView(){
        addSubview(parentView)
        numberStack.translatesAutoresizingMaskIntoConstraints = false
        
        numberStack.axis = .vertical
        numberStack.distribution = .fillEqually
        
        numberStack.addArrangedSubview(accountNumberLabel)
        numberStack.addArrangedSubview(balanceAmountLabel)
        
        parentView.addSubview(walletImageView)
        parentView.addSubview(forwardButton)
        //addSubview(balanceAmountLabel)
        //addSubview(forwardButton)
        parentView.addSubview(numberStack)
        
        walletImageView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        walletImageView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 20).isActive = true
        walletImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        walletImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        numberStack.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        numberStack.leadingAnchor.constraint(equalTo: walletImageView.trailingAnchor, constant: 14).isActive = true
        
        forwardButton.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
        forwardButton.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -34).isActive = true
    }
    
    func configureCell(headerTitle: String, subHeaderTitle: String, logo: UIImage? = nil){
        accountNumberLabel.text = headerTitle
        balanceAmountLabel.text = subHeaderTitle
        if logo != nil {
            walletImageView.image = logo
        }
    }

}
