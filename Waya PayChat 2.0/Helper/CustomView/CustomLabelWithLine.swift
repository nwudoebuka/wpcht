//
//  CustomLabelWithLine.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/19/21.
//


class CustomLabelWithLine: UIView {

    var titleLabel : UILabel  = {
        let label = UILabel()
        label.textColor = UIColor(named: "color-gray1")
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
 
    var titleLine : UIView  = {
        let line = UIView()
        line.frame.size = CGSize(width: UIScreen.main.bounds.width/4, height: 1)
        line.backgroundColor =  UIColor(named: "color-gray1")?.withAlphaComponent(0.3)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        
        addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
  
        
        addSubview(titleLine)
        titleLine.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLine.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        titleLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        self.isUserInteractionEnabled = false
        
    }
    
}
