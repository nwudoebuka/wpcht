//
//  TabBarControllerDelegate.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/7/21.
//
protocol DashBoardCoordinator: class {
    var toogleMenu: (() -> Void)? { get set }
    var navToSettings: ((SettingsView?) -> Void)? { get set}
    var navToTransactions:(() -> Void)? {get set}
    
}
