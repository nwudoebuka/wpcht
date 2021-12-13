//
//  ComingSoonView.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 4/10/21.
//


class ComingSoonView: UIView {

    var backgroundImage = UIImageView(image: UIImage(named: "empty-manage-bank"))
    var titleLabel : UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        initView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView(){
        titleLabel = latoGrayTextBold(text: "Coming Soon", color:  UIColor(named: "dark-gray") ?? .gray, size: 24)
        addSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40).isActive = true
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 32).isActive = true
    }

}
