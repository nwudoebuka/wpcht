//
//  ChatVIew.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/7/21.
//

protocol ChatView : BaseView {
    var onNavToogle: (() -> Void)? { get set }
}
