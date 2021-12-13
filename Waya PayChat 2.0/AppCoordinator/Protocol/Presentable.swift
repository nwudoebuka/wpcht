//
//  Presentable.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/2/21.
//


protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    
    func toPresent() -> UIViewController? {
        return self
    }
}
