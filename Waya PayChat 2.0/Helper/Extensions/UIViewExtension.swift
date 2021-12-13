struct AnchoredConstraints {
    var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

class Border: UIView {
    var name: String!
    convenience init(name: String) {
        self.init(frame: .zero)
        self.name = name
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach({ self.addSubview($0) })
    }
    
    private class func viewInNibNamed<T: UIView>(_ nibNamed: String) -> T {
        return Bundle.main.loadNibNamed(nibNamed, owner: nil, options: nil)!.first as! T
    }
    
    class func nib() -> Self {
        return viewInNibNamed(nameOfClass)
    }
    
    class func nib(_ frame: CGRect) -> Self {
        let view = nib()
        view.frame = frame
        view.layoutIfNeeded()
        return view
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func cornerWithWhiteBg(_ radius : CGFloat = 4){
        layer.cornerRadius = radius
        backgroundColor = .white
    }
    
    func cornerRadius(_ radius : CGFloat = 4){
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func libreTextBold(text: String, textSize : CGFloat = 22) -> UILabel{
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "toolbar-color-secondary")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "LibreBaskerville-Bold", size: textSize)
        return label
    }
    
    func latoTextRegular(text: String, textSize : CGFloat = 16,
                         textColor : UIColor = UIColor(named: "color-gray1") ?? .black) -> UILabel{
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Lato-Regular", size: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = textColor
        return label
    }
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerInSuperview(size: CGSize = .zero, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func sizeAnchor(height : NSLayoutDimension? , width : NSLayoutDimension?, heightConstant: CGFloat?, widthConstant: CGFloat?){
        translatesAutoresizingMaskIntoConstraints = false
        if let height = height{
            heightAnchor.constraint(equalTo: height).isActive = true
        }
        
        if let width = width{
            widthAnchor.constraint(equalTo: width).isActive = true
        }
        
        if let heightConstant = heightConstant{
            heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
        
        if let widthConstant = widthConstant{
            widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
    }
    
    func latoGrayTextRegular(text: String, color : UIColor = UIColor(named: "color-black") ?? .black , size: CGFloat = 16) -> UILabel{
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Lato-Regular", size: size)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = color
        return label
    }
    
    func latoGrayTextBold(text: String, color : UIColor = UIColor(named: "color-black") ?? .black , size: CGFloat = 16) -> UILabel{
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "Lato-Regular", size: size)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = color
        return label
    }
    
    func generateStackView(axis: NSLayoutConstraint.Axis = .horizontal) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.axis = axis
        return stackView
    }
  
    
    func generatePrimaryButton(title : String) -> UIButton{
        let button = UI.button(title: title)
        return button
    } 
    
    func generateButton(title: String, textSize : CGFloat = 16, textAlignement : NSTextAlignment = .left,
                        textColor: UIColor = .white) -> UIButton{
        let button = UIButton()
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: textSize)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.textAlignment = textAlignement
        return button
    }
    
    func generateProfileImageView() ->  UIImageView{
        let imageV = UIImageView()
        imageV.image = UIImage(named: "profile-placeholder")
        imageV.frame = CGRect(x: 0, y: 0, width: 42 , height: 42)  
        imageV.circularImage()
        return imageV
    }
    
    func generateImageView() ->  UIImageView{
        let imageV = UIImageView()
        return imageV
    }
    
    func roundTopCorners(_ raduis: CGFloat){
        //topleft  layerMinXMinYCorner
        //bottomleft layerMinXMaxYCorner
        // topRight layerMaxXMinYCorner
        //bottomRight layerMaxXMaxYCorner
        
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.clipsToBounds = true
        layer.cornerRadius = raduis
    }
    
    func buttonWithImageRight(image : UIImage, text: String, size: CGFloat = 16)  -> UIButton{
        let button = UIButton()
        button.setImage(image, for: .normal) 
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: -20)
        button.semanticContentAttribute = .forceLeftToRight
        button.setTitle("    \(text)", for: .normal)
        button.setTitleColor(UIColor(named: "toolbar-color-primary"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: size)
        return button
    }
    
    func  generateLine() -> UIView{
        let line = UIView()
        line.backgroundColor =  UIColor(named: "sliver-gray")?.withAlphaComponent(0.3)
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }
    
    
    func willSetConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let subview = Border(name: "border")
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        self.addSubview(subview)
        switch edge {
        case .top, .bottom:
            subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            subview.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .top {
                subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            } else {
                subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            }
        case .left, .right:
            subview.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            subview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            subview.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            subview.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            if edge == .left {
                subview.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
            } else {
                subview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
            }
        default:
            break
        }
    }
    
    func removeBorders() {
        let borders = self.subviews.filter({
            if let border = $0 as? Border, border.name == "border" {
                return true
            } else {
                return false
            }
        })
        borders.forEach({ $0.removeFromSuperview() })
        
    }
    
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
}



