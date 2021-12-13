//
//  TextInput.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 19/05/2021.
//

import UIKit
import SwiftValidator
import Signals

open class TextInput: UIView, Validatable {
    public var validationText: String {
        return input.text ?? ""
    }
    public var text: String {
        return input.text ?? ""
    }
    
    var lineColor = UIColor(hex: "#C4C4C4")
    var placeholderColor = UIColor(hex: "#828282")
    var placeHolder: String?
    var label: String?
    
    lazy var errorLabel: UILabel = {
        let txt = UI.text(string: "")
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.clipsToBounds = true
        txt.textColor = Colors.red
        txt.isHidden = true
        txt.numberOfLines = 0
        txt.font = UIFont(name: "Lato-Regular", size: 12)
        return txt
    }()
    
    lazy var input: UITextField = {
        let field = UITextField(frame: .zero)
        field.font = UIFont(name: "Lato-Regular", size: 16)
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    lazy var labelText: UILabel = {
        let txt = UI.text(string: "")
        txt.font = UIFont(name: "Lato-Regular", size: 14)?.semibold
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    convenience init(label: String? = nil, placeHolder: String? = nil, errorLabel: String? = nil) {
        self.init(frame: .zero)
        self.errorLabel.text = errorLabel
        self.label = label
        self.placeHolder = placeHolder
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setup() {
        input.autocorrectionType = .no
        input.autocapitalizationType = .none
        
        self.addSubview(errorLabel)
        if(label != nil) {
            labelText.text = label
            self.addSubviews([labelText, input])
            labelText.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
            labelText.heightAnchor.constraint(equalToConstant: 16).isActive = true
            input.anchor(top: labelText.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
        } else {
            self.addSubviews([input])
            input.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        }
        input.heightAnchor.constraint(equalToConstant: 30).isActive = true
        errorLabel.anchor(top: input.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0))
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.input.addBorder(.bottom, color: lineColor, thickness: 0.9)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func draw(_ rect: CGRect) {
        //Setting custom placeholder color
        if let strPlaceHolder: String = self.placeHolder {
            self.input.attributedPlaceholder = NSAttributedString(
                string:strPlaceHolder,
                attributes:[NSAttributedString.Key.foregroundColor:self.placeholderColor]
            )
       }
    }
    
    func addToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dismissPicker))
        toolbar.setItems([doneBtn], animated: true)
        self.input.inputAccessoryView = toolbar
    }
    
    @objc func dismissPicker() {
        self.input.resignFirstResponder()
    }
}
