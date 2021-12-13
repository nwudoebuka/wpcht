//
//  ChatVIew.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/7/21.
//

protocol ChatView : BaseView {
    var onNavToogle: (() -> Void)? { get set }
}
