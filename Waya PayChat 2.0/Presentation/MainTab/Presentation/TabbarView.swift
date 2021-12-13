//
//  TabView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/3/21.
//

protocol TabbarView: class {
 
    var onViewDidLoad: ((UINavigationController) -> ())? { get set }
    var onHomeFlowSelect: ((UINavigationController) -> ())? { get set }
    var onDiscoverFlowSelect: ((UINavigationController) -> ())? { get set }
    var onWalletFlowSelect: ((UINavigationController) -> ())?{ get set }
    var onChatFlowSelect: ((UINavigationController) -> ())? { get set }
    var onNotificationFlowSelect: ((UINavigationController) -> ())? { get set }
    var onLogoutTap: (()-> Void)?{get set}
    func toogleNavigationMenu()
    
    var onSettingsTap: ((SettingsView?) -> Void)? { get set}
}

