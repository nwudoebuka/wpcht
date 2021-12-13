//
//  TabBarOutput.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/18/21.
//
import UIKit

protocol TabBarCoordinatorOutput: class {
    var finishFlow: (() -> Void)? { get set }
    // this can be expanded to present anything later, for now, we are simply using it to display a detached settings UI
    var present: ((SettingsView?) -> Void)? { get set}
}
