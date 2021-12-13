//
//  UIButtonExtension.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//

extension UIButton{

    
    func transparentButton(){
        self.layer.cornerRadius = 4
        self.backgroundColor = UIColor.clear
        self.layer.borderColor = UIColor(named: "primary-button-color")?.cgColor.copy(alpha: 0.2)
        
        self.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        self.setTitleColor(UIColor.init(named: "primary-button-color"), for: .normal) 
        self.layer.borderWidth = 1.0
    }
    
    func  setLeftImageAlignment() {
        if self.imageView != nil{
            self.imageEdgeInsets = UIEdgeInsets(top: 0,left: -20,bottom: 0,right: 0)
            self.titleEdgeInsets = UIEdgeInsets(top: 0,left: -10, bottom: 0 , right: 0)

        }

    }
}
