//
//  UITextField.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/4/21.
//

import Foundation

extension UITextField{
    
//    public func underline(with color: UIColor? = nil, lineWidth: CGFloat? = 1) {
//        borderStyle = .none
//        let border = CALayer()
//        border.borderColor = color?.cgColor ??  UIColor(hex: "#C4C4C4").cgColor
//        border.borderWidth = lineWidth ?? 1
//        border.frame = CGRect(x: 0, y: self.frame.size.height + 1, width: self.frame.size.width, height: 2)
//        self.layer.addSublayer(border)
//        self.layer.masksToBounds = true
//    }
//    
    func textFieldShouldReturn() -> Bool {
        let nextTag = self.tag + 1
        
        if let nextResponder = self.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            self.resignFirstResponder()
        }
        
        return true
    }
    
    
}


extension UITextView {

    func centerVertically() {
        self.textAlignment = .center
        let fitSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fitSize)
        let calculate = (bounds.size.height - size.height * zoomScale) / 2
        let offset = max(1, calculate)
        contentOffset.y = -offset
    }
}

class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
