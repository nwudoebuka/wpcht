//
//  NotificationVIew.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/7/21.
//

protocol NotificationView : BaseView{
    var onNavToogle: (() -> Void)? { get set }
}
