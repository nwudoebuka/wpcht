//
//  LoginUpdateProfileVIew.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/10/21.
//

enum ProfileUpdateDisplayMode {
    case login
    case register
}

protocol LoginUpdateProfileView : BaseView {
    var onUpdateComplete : (() -> Void)?{get set}
    var onCancelTapped: (() -> Void)?{ get set}
    var displayMode: ProfileUpdateDisplayMode {get set}
}
