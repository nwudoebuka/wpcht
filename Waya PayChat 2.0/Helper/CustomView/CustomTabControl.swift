//
//  CustomTabControl.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/19/21.
//


class CustomTabControl: UIControl {

    let  screenWidth = UIScreen.main.bounds.width
    private var items  = [CustomLabelWithLine]()
    var itemsText : [String] = ["People", "Interests", "Pages", "Groups"]{
        didSet{
            setupView()
        }
    }
    
    func updateView(){
        
    }
    
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    func setupLabels(){
        
        for item in items {
            item.removeFromSuperview()
        }
        
        items.removeAll(keepingCapacity: true)
        
        for index in 1...itemsText.count {
            
            let view = CustomLabelWithLine(frame: CGRect(x: 0, y: 0, width: Int(screenWidth)/itemsText.count, height: 60))
            view.titleLabel.text = itemsText[index - 1]
            view.backgroundColor = UIColor.clear
            view.titleLabel.textAlignment = .center
            view.titleLabel.textColor = index == 1 ? UIColor(named: "toolbar-color-secondary") : UIColor(named: "color-gray1")
            view.titleLine.backgroundColor = index == 1 ? UIColor(named: "toolbar-color-secondary") : UIColor(named: "color-gray1")?.withAlphaComponent(0.3)
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            items.append(view)
        }
        
    }
    
    func setupView(){
        
        layer.cornerRadius = 0
        
        backgroundColor = .white
        
        setupLabels()   
        
        addIndividualItemConstraints(items: items, mainView: self, padding: 0)

    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        var selectFrame = self.bounds
//        let newWidth = selectFrame.width / CGFloat(itemsText.count)
//        selectFrame.size.width = newWidth
//        
//        displayNewSelectedIndex()
//        
//    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        print("is touch  \(String(describing: index))")

        var calculatedIndex : Int?
        for (index, item) in items.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
                print("Was touched \(index)")
            }
            print("Was reached \(index)")

        }
        
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    func displayNewSelectedIndex(){
        for (_, item) in items.enumerated() {
            item.titleLabel.textColor = UIColor(named: "color-gray1")
            item.titleLine.backgroundColor = UIColor(named: "color-gray1")?.withAlphaComponent(0.3)

        }
        
        items[selectedIndex ].titleLabel.textColor =  UIColor(named: "toolbar-color-secondary")
        items[selectedIndex ].titleLine.backgroundColor =  UIColor(named: "toolbar-color-secondary")?.withAlphaComponent(0.3)
        
    }
    
    
    func addIndividualItemConstraints(items: [UIView], mainView: UIView, padding: CGFloat) {
        
        _ = mainView.constraints
        
        for (index, button) in items.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == items.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: -padding)
                
            }else{
                
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nextButton, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: -padding)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: mainView, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: padding)
                
            }else{
                
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: prevButton, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: firstItem, attribute: .width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    

}
