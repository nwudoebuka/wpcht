//
//  AppDIContainer.swift
//  Waya PayChat 2.0
//
//  Created by Dayo Banjo on 3/26/21.
//

import Foundation

final class AppDIContainer {
    
    func makeWayagramViewModel() -> WayagramViewModelImpl{
        return WayagramViewModelImpl()
    }
}
