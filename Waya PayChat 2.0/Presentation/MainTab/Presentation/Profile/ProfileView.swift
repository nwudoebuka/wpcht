//
//  ProfileView.swift
//  Waya PayChat 2.0
//
//  Created by Chukwuebuka Nwudo on 06/09/2021.
//

import Foundation

protocol ProfileView : BaseView{
    var navToFollowing : (() -> Void)? { get set }
}
