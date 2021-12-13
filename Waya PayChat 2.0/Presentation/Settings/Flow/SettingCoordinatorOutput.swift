//
//  SettingCoordinatorOutput.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 16/07/2021.
//

import Foundation

protocol SettingsCoordinatorOutput: class {
    var finishFlow: (() -> Void)? { get set}
}
