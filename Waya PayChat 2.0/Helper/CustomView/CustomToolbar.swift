//
//  CustomToolbar.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/19/21.
//


class CustomToolbar: UIView {

    let backButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back-arrow"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var titleLabel : UILabel = {
        let label = UI.text(string: "")
        label.textAlignment = .center
        label.font = UIFont(name: "LibreBaskerville-Bold", size: 16)
        return label
    }()
    
    var rightItems: [UIView]? {
        didSet {
            self.setNeedsDisplay()
            self.setNeedsLayout()
        }
    }
    var leftItems: [UIView]? {
        didSet {
            self.setNeedsDisplay()
            self.setNeedsLayout()
        }
    }
    
    convenience init(rightItems: [UIView]? = nil, leftItems: [UIView]? = nil) {
        self.init()
        self.rightItems = rightItems
        self.leftItems = leftItems
        self.initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        if self.subviews.count > 0 {
            self.subviews.forEach{ $0.removeFromSuperview() }
        }
        self.backgroundColor = .white
        addSubviews([backButton, titleLabel])
        
        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 33),
        ])
        
        if self.rightItems != nil {
            self.rightItems?.forEach{ (button) in
                button.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(button)
                button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                
                if self.rightItems!.count > 1 {
                    button.widthAnchor.constraint(equalToConstant: 40).isActive = true
                    button.heightAnchor.constraint(equalToConstant: 40).isActive = true
                } else {
                    button.widthAnchor.constraint(equalToConstant: 85).isActive = true
                    button.heightAnchor.constraint(equalToConstant: 24).isActive = true
                }
            }
            
            NSLayoutConstraint.activate([
                titleLabel.trailingAnchor.constraint(equalTo: self.rightItems!.first!.leadingAnchor, constant: -2),
                self.rightItems!.last!.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
            ])
            
        } else {
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
        }
        
        
//        titleLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -2),
//        rightButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//        rightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
//        rightButton.heightAnchor.constraint(equalToConstant: 24),
//        rightButton.widthAnchor.constraint(equalToConstant: 81)
    }
   
}
