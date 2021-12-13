//
//  PreferenceSettings.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 20/08/2021.
//
import UIKit
import ScrollableView
import Signals

fileprivate enum PreferenceOptions: CaseIterable {
    case fingerprint, sms, dark_mode, font_size, chat_notifications
    var title: String {
        switch self {
        case .fingerprint:
            return "Enable fingerprint ID"
        case .sms:
            return "Enable SMS"
        case .dark_mode:
            return "Enable dark mode"
        case .font_size:
            return "Font size"
        case .chat_notifications:
            return "Chat notifications"
        }
    }
}

fileprivate class PreferenceOption: UIView {
    var value: PreferenceOptions!
    let toggled = Signal<(PreferenceOptions, Bool)>()
    var toggle_switch: UISwitch?
    var selectPicker: UILabel?
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class PreferenceSettings: ScrollableView, SettingsView, Alertable {
    var onBack: ((Bool) -> Void)?
    
    var optionSelected: ((SettingsView?) -> Void)?
    
    var present: ((UIViewController) -> Void)?
    let viewModel = SettingsViewModel()
    
//    let font_sizes: [FontSize] = [
    lazy var font_picker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.shouldResignOnTouchOutsideMode = .enabled
        return picker
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = .white
        self.content.spacing = 5
        
        PreferenceOptions.allCases.forEach { (option) in
            let setting = self.createOption(option: option)
            setting.translatesAutoresizingMaskIntoConstraints = false
            self.addView(view: setting)
            setting.heightAnchor.constraint(equalToConstant: 41).isActive = true
            setting.toggled.subscribe(with: self) { (option, value) in
                if option == .font_size {
                    self.changeFont()
                } else {
                    self.change(option: option, value: value)
                }
            }
            switch setting.value {
            case .sms:
//                print("profile: \(auth.data.profile)")
                setting.toggle_switch?.isOn = auth.data.profile!.smsAlertConfig!
            case .fingerprint, .dark_mode, .font_size, .chat_notifications:
                break
            default:
                break
            }
        }
    }
    
    private func createOption(option: PreferenceOptions) -> PreferenceOption {
        let view = PreferenceOption()
        view.value = option
//        let toggle_switch: UIView
        let label = UI.text(string: option.title)
        label.font = UIFont(name: "Lato-Regular", size: 16)
        if option == .font_size {
            let font_size = auth.prefs.font_size
            view.selectPicker = UI.text(string: font_size.stringValue)
            view.addSubviews([label, view.selectPicker!])
            NSLayoutConstraint.activate([
                view.selectPicker!.heightAnchor.constraint(equalToConstant: 20),
                view.selectPicker!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23),
                view.selectPicker!.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            view.toggled.subscribe(with: self) { (option) in
                print("should change font title")
            }
            view.selectPicker!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeFont)))
        } else {
            view.toggle_switch = UISwitch()
            view.toggle_switch?.translatesAutoresizingMaskIntoConstraints = false
            view.addSubviews([label, view.toggle_switch!])
            NSLayoutConstraint.activate([
                view.toggle_switch!.heightAnchor.constraint(equalToConstant: 16),
                view.toggle_switch!.widthAnchor.constraint(equalToConstant: 33),
                view.toggle_switch!.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                view.toggle_switch!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -23)
            ])
            view.toggle_switch?.isUserInteractionEnabled = true
            view.toggle_switch?.onValueChanged.subscribe(with: self, callback: {
                view.toggled => (view.value, view.toggle_switch!.isOn)
            })
        }
        
        label.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0))
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        return view
    }
    
    
    @objc func changeFont() {
        font_picker.isHidden = false
    }
    
    private func change(option: PreferenceOptions, value: Bool) {
        switch option {
        case .sms:
            viewModel.toggleSmsAlert { (result) in
                switch result {
                case .success(_):
                    auth.refreshProfile()
                    break
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        default:
            break
        }
    }
}


extension PreferenceSettings: UIPickerViewDelegate, UIPickerViewDataSource {
//    func picke
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let fonts = FontSize.allCases
        auth.prefs.font_size = fonts[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return FontSize.allCases.count
    }
}
