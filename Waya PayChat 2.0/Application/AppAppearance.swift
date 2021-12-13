//
//  AppAppearance.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/3/21.
//

final class AppAppearance {
    
    static func setupAppearance() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = UIColor(named: "color-primary")
        UITabBar.appearance().tintColor = UIColor(named: "color-primary")
        
        
        let backButtonBackgroundImage = UIImage(named: "back-arrow")
        let barAppearance =
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UIViewController.self])
        barAppearance.setBackButtonBackgroundImage(backButtonBackgroundImage, for: .normal, barMetrics: .compact)
    }
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

