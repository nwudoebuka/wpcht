//
//  PickerView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 03/06/2021.
//

import UIKit


protocol PickerDelegate: class {
    func didTapDone(picker: Picker)
}

class Picker: UIPickerView {

    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: PickerDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        self.showsSelectionIndicator = true
        self.backgroundColor = .white
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.tintColor = .black
        
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))

        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone(picker: self)
    }
}
