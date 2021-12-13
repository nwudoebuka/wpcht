//
//  UIStyleGuide.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 18/05/2021.
//

import UIKit

enum TextStyle {
    case normal
    case bold
    
}

enum TextColor {
    case primary
    case white
    case gray
    case blue
    
    var dark: UIColor {
        switch self{
        case .primary:
            return UIColor(named: "toolbar-color-secondary")!
        case .white:
            return .white
        case .gray:
            return Colors.lighterText
        case .blue:
            return UIColor(hex: "#064A72")
        }
    }
}

struct UI {
    
    static func text(string: String?, style: TextStyle? = .normal, color: TextColor? = .primary) -> UILabel {
        let text = UILabel()
        let font: UIFont = ((style == .normal) ? UIFont(name: "Lato-Regular", size: 14)! : UIFont(name: "Lato-Bold", size: 14))!
        text.text = string
        text.font = font
        text.textColor = color?.dark
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }
    
    static func textField(label: String? = nil, placeholder: String? = nil) -> TextInput {
        let textField = TextInput(label: label, placeHolder: placeholder, errorLabel: nil)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    static func button(title: String?, icon: UIImage? = nil, style: ButtonStyle? = .primary, state: ButtonState? = .active) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont(name: "Lato-Regular", size: 16)
        button.backgroundColor = style?.bg_color
        button.setTitleColor(style?.text_color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if(state == .inactive) {
            button.alpha = 0.3
            button.isEnabled = false
        }
        if icon != nil {
            button.setImage(icon?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.imageView?.tintColor = style?.text_color ?? .black
        }
        return button
    }
}

enum ButtonState {
    case active, inactive
}

enum ButtonStyle {
    case primary
    case secondary
    case icon
    case small
    case destructive
    case none
    
    var bg_color: UIColor {
        switch self {
        case .primary:
            return UIColor(hex: "#FF6634")
        case .secondary, .icon, .small, .destructive, .none:
            return .clear
        }
    }
    
    var text_color: UIColor {
        switch self {
        case .primary:
            return .white
        case .secondary, .small:
            return UIColor(hex: "#FF6634")
        case .destructive:
            return Colors.crimson
        case .icon:
            return .black
        case .none:
            return UIColor(hex: "064A72")
        }
    }
}
