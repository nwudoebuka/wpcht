protocol PageControlDelegate {
    func selectedIndex(_ index:Int)
}




class RectPageControl : NSObject {
    
    var stack : UIStackView? = nil
    var delegate : PageControlDelegate?
    
    var button1 : UIButton  = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "color-primary")?.withAlphaComponent(0.3)
        button.frame.size.width = 24
        button.frame.size.height = 2
        button.layer.cornerRadius = 2
        return button
    }()
    
    var button2 : UIButton  = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "color-primary")?.withAlphaComponent(0.3)
        button.frame.size.width = 24
        button.frame.size.height = 2
        button.layer.cornerRadius = 2
        return button
    }()
    
    var button3 : UIButton  = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: "color-primary")?.withAlphaComponent(0.3)
        button.frame.size.width = 24
        button.frame.size.height = 2
        button.layer.cornerRadius = 2
        return button
    }()
    
    init(numberOfPages : Int) {
        
        
        stack = UIStackView()
        stack?.spacing = 7
        stack?.axis = .horizontal
        stack?.distribution = .fillEqually
        stack?.alignment = .center
        stack?.backgroundColor = .white
        
        super.init()
        
        stack?.addArrangedSubview(button1)
        stack?.addArrangedSubview(button2)
        stack?.addArrangedSubview(button3)
    }
    
    func selectIndex(_ index:Int){
        switch index {
            case 0:
                button1.backgroundColor = UIColor(named: "color-primary")
                button2.backgroundColor = UIColor(named: "color-primary")?.withAlphaComponent(0.3)
                button3.backgroundColor = UIColor(named: "color-primary")?.withAlphaComponent(0.3)
            case 1:
                button1.backgroundColor = UIColor(named: "color-primary")?.withAlphaComponent(0.3)
                button2.backgroundColor = UIColor(named: "color-primary")
                button3.backgroundColor = UIColor(named: "color-primary")?.withAlphaComponent(0.3)
            case 2: 
                button1.backgroundColor = UIColor(named: "color-primary")?.withAlphaComponent(0.3)
                button2.backgroundColor = UIColor(named: "color-primary")?.withAlphaComponent(0.3)
                button3.backgroundColor = UIColor(named: "color-primary")
            default:
                break
        }
    }
    
    
}

