//
//  DropdownCell.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 24/06/2021.
//

import Foundation

class DropdownCell : UITableViewCell{
    static let identifier = "DropdownCell"
    
    lazy var logo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var title: UILabel = {
        let txt = UI.text(string: "")
        txt.numberOfLines = 0
        return txt
    }()
    
    lazy var subTitle: UILabel = {
        let txt = UI.text(string: "")
        txt.textColor = Colors.lighterText
        return txt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: DropdownCell.identifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override open var frame: CGRect {
//        get {
//            return super.frame
//        }
//        set (newFrame) {
//            var frame =  newFrame
//            frame.origin.y += 10
//            frame.origin.x += 10
//            frame.size.height -= 15
//            frame.size.width -= 2 * 10
//            super.frame = frame
//        }
//    }
//
//    override open func awakeFromNib() {
//        super.awakeFromNib()
////        layer.cornerRadius = 15
//        layer.masksToBounds = false
//    }
//
    func setup() {
        self.addSubviews([logo, title, subTitle])
        logo.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        logo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 48).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 48).isActive = true
        
        title.anchor(top: topAnchor, leading: logo.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 23, left: 14, bottom: 0, right: 12))
        
        subTitle.anchor(top: title.bottomAnchor, leading: logo.trailingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 3, left: 14, bottom: 0, right: 12))
        
        self.layoutIfNeeded()
    }
}
