//
//  NavView.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 25/05/2021.
//

import Foundation
protocol NavView: UIView {
    var onBack: (() -> Void)? {get set}
}
