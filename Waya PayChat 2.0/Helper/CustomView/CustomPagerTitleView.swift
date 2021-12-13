//
//  CustomPagerTitleView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/19/21.
//

protocol CustomPagerTitleDelegate {
    func selectedIndex(_ index:Int)
}

class CustomPagerTitleView : NSObject {

    var stack : UIStackView? = nil
    var delegate : PageControlDelegate?
    let screenWidth = UIScreen.main.bounds.width
    
    var title1 : UILabel  = {
        let label = UILabel()
        label.textColor = UIColor(named: "color-gray1")
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    let titleLine1 : UIView = {
        let line = UIView()
        line.frame.size = CGSize(width: UIScreen.main.bounds.width/4, height: 1)
        line.backgroundColor =  UIColor(named: "color-gray1")
        return line
    }()
    
    let titleLine2 : UIView = {
        let line = UIView()
        line.frame.size = CGSize(width: UIScreen.main.bounds.width/4, height: 1)
        line.backgroundColor =  UIColor(named: "color-gray1")
        return line
    }()
    
    let titleLine3 : UIView = {
        let line = UIView()
        line.frame.size = CGSize(width: UIScreen.main.bounds.width/4, height: 1)
        line.backgroundColor =  UIColor(named: "color-gray1")
        return line
    }()
    
    let titleLine4 : UIView = {
        let line = UIView()
        line.frame.size = CGSize(width: UIScreen.main.bounds.width/4, height: 1)
        line.backgroundColor =  UIColor(named: "color-gray1")
        return line
    }()

    
    var title2 : UILabel  = {
        let label = UILabel()
        label.textColor = UIColor(named: "color-gray1")
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    var title3 : UILabel  = {
        let label = UILabel()
        label.textColor = UIColor(named: "color-gray1")
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    var title4 : UILabel  = {
        let label = UILabel()
        label.textColor = UIColor(named: "color-gray1")
        label.font = UIFont(name: "Lato-Regular", size: 16)
        return label
    }()
    
    var titleStack  : UIStackView = {
       let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillProportionally
        return stack 
    }()
    
    var titleStack2  : UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillProportionally
        return stack  
    }()
    
    var titleStack3  : UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillProportionally
        return stack  
    }()

    var titleStack4  : UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 12
        stack.distribution = .fillProportionally
        return stack 
    }()
    
    var mainStack : UIStackView = {
       let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        stack.distribution = .fillEqually
       return stack 
    }()
    
    init(numberOfPages : Int) {        
        
        super.init()
        
        titleStack.addArrangedSubview(title1)
        title1.frame.size.height = 2
        titleStack.addArrangedSubview(titleLine1)

        titleStack2.addArrangedSubview(title2)
        titleStack2.addArrangedSubview(titleLine2)

        titleStack3.addArrangedSubview(title3)
        titleStack3.addArrangedSubview(titleLine3)

        titleStack4.addArrangedSubview(title4)
        titleStack4.addArrangedSubview(titleLine4)
        
        mainStack.addArrangedSubview(titleStack)
        mainStack.addArrangedSubview(titleStack2)
        mainStack.addArrangedSubview(titleStack3)
        mainStack.addArrangedSubview(titleStack4)
        
    }
    
    func selectIndex(_ index:Int){
        switch index {
            case 0:
                title1.textColor = UIColor(named: "toolbar-color-secondary")
                title2.textColor = UIColor(named: "color-gray1")
                title3.textColor = UIColor(named: "color-gray1")
                title4.textColor = UIColor(named: "color-gray1")
                
                titleLine1.backgroundColor = UIColor(named: "toolbar-color-secondary")
                titleLine2.backgroundColor = UIColor(named: "color-gray1")
                titleLine3.backgroundColor = UIColor(named: "color-gray1")
                titleLine4.backgroundColor = UIColor(named: "color-gray1")
                
            case 1:
                title1.textColor = UIColor(named: "color-gray1")
                title2.textColor =  UIColor(named: "toolbar-color-secondary")
                title3.textColor = UIColor(named: "color-gray1")
                title4.textColor = UIColor(named: "color-gray1")
                
                titleLine1.backgroundColor = UIColor(named: "color-gray1")
                titleLine2.backgroundColor = UIColor(named: "toolbar-color-secondary")
                titleLine3.backgroundColor = UIColor(named: "color-gray1")
                titleLine4.backgroundColor = UIColor(named: "color-gray1")
            case 2: 
                title1.textColor = UIColor(named: "color-gray1")
                title2.textColor = UIColor(named: "color-gray1")
                title3.textColor =  UIColor(named: "toolbar-color-secondary")
                title4.textColor = UIColor(named: "color-gray1")
                
                titleLine1.backgroundColor = UIColor(named: "color-gray1")
                titleLine2.backgroundColor = UIColor(named: "color-gray1")
                titleLine3.backgroundColor = UIColor(named: "toolbar-color-secondary")
                titleLine4.backgroundColor = UIColor(named: "color-gray1")
            case 3:
                title1.textColor = UIColor(named: "color-gray1")
                title2.textColor = UIColor(named: "color-gray1")
                title3.textColor = UIColor(named: "color-gray1")
                title4.textColor = UIColor(named: "toolbar-color-secondary")
                
                titleLine1.backgroundColor = UIColor(named: "color-gray1")
                titleLine2.backgroundColor = UIColor(named: "color-gray1")
                titleLine3.backgroundColor = UIColor(named: "color-gray1")
                titleLine4.backgroundColor = UIColor(named: "toolbar-color-secondary")
            default:
                break
        }
    }
    
    
}
