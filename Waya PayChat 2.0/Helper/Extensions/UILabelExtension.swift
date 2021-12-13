//
//  UILabelExtension.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//

extension UILabel{
    
    func latoText16(){
        self.font = UIFont(name: "Lato-Regular", size: 16)
        if #available(iOS 11.0, *) {
            self.textColor = UIColor.init(named: "toolbar-color-primary")
        } else {
            // Fallback on earlier versions
        }
    }
  
    func libreText22(){
        self.font = UIFont(name: "LibreBaskerville-Regular", size: 22)
        if #available(iOS 11.0, *) {
            self.textColor = UIColor.init(named: "dark-cerulean")
        } else {
            // Fallback on earlier versions
        }
    }

    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    } 
    
    
}
