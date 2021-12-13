//
//  CustomizeHomePageView.swift
//  Waya PayChat 2.0
//
//  Created by Home on 3/6/21.
//

protocol SelectLandingPageView : BaseView {
    var finishAuthFlow :(() -> Void)?{ get set}
}
