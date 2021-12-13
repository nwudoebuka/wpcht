//
//  PinStackView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/5/21.
//
protocol OTPDelegate: class {
    //always triggers when the OTP field is valid
    func didChangeValidity(isValid: Bool)
}

enum PinInputStyle {
    case underline
    case bordered
}

class PinStackView: UIStackView {
    
    //Customise the OTPField here
    var numberOfFields: Int!
    var textFieldsCollection: [OTPTextField] = []
    weak var delegate: OTPDelegate?
    var showsWarningColor = false
    var secured: Bool! = true
    var style: PinInputStyle = .bordered
    
    //Colors
    let inactiveFieldBorderColor = UIColor(named: "color-gray1")?.withAlphaComponent(0.3)
    let textBackgroundColor = UIColor.white
    let activeFieldBorderColor = UIColor(named: "color-primary")?.withAlphaComponent(0.6)
    var remainingStrStack: [String] = []
    
    convenience init(frame: CGRect, fields: Int, style: PinInputStyle? = .bordered, secure: Bool? = true) {
        self.init(frame: frame)
        self.secured = secure!
        self.style = style!
        numberOfFields = fields
        setupStackView()
        addOTPFields()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    //Customisation and setting stackView
    private final func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = (numberOfFields == 4) ? 32 : 12
    }
    
    //Adding each OTPfield to stack view
    private final func addOTPFields() {
        self.removeAllArrangedSubviews()
        if textFieldsCollection.count > 0 {
            textFieldsCollection.removeAll()
        }
        for index in 0..<numberOfFields{
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (textFieldsCollection[index-1].nextTextField = field) : ()
        }
        textFieldsCollection[0].becomeFirstResponder()
    }
    
    //Customisation and setting OTPTextFields
    private final func setupTextField(_ textField: OTPTextField){
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addArrangedSubview(textField)
//        textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.12 ).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.backgroundColor = textBackgroundColor
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont(name: "Lato-Regular", size: 16)
        textField.textColor = UIColor(named: "slivergray")?.withAlphaComponent(0.3)
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = inactiveFieldBorderColor?.cgColor
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .yes
        textField.isSecureTextEntry = self.secured
        if #available(iOS 12.0, *) {
            textField.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        
        if self.style == .bordered {
            textField.layer.borderWidth = 1.5
        } else {
            textField.addBorder(.bottom, color: .black, thickness: 0.8)
        }
    }
    
    //checks if all the OTPfields are filled
    private final func checkForValidity(){
        for fields in textFieldsCollection{
            if (fields.text == ""){
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }
    
    //gives the OTP text
    final func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection{
            OTP += textField.text ?? ""
        }
        return OTP
    }
    
    final func clear() {
        textFieldsCollection.forEach({ $0.text = ""})
    }
    //set isWarningColor true for using it as a warning color
    final func setAllFieldColor(isWarningColor: Bool = false, color: UIColor){
        for textField in textFieldsCollection{
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }
    
    //autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap{String($0)}
        for textField in textFieldsCollection {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
        remainingStrStack = []
    }    
}

//MARK: - TextField Handling
extension PinStackView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
            setAllFieldColor(color: inactiveFieldBorderColor ?? UIColor.gray)
            showsWarningColor = false
        }
        textField.layer.borderColor = activeFieldBorderColor?.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
        textField.layer.borderColor = inactiveFieldBorderColor?.cgColor ?? UIColor.gray.cgColor
    }
    
    //switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0){
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                }else{
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
    
}

