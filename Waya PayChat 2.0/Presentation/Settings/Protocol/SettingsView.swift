//
//  SettingsView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 15/07/2021.
//

import UIKit

protocol SettingsView: Presentable {
    var onBack: ((Bool) -> Void)? { get set }
    var optionSelected: ((SettingsView?) -> Void)? { get set}
//    var option: UserSetting { get set }
//    var option: Options { get set }
    var present: ((UIViewController) -> Void)? { get set }
}
