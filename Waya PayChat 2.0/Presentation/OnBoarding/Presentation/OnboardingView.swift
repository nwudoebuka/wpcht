//
//  OnboardingView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/3/21.
//

protocol OnboardingView: BaseView {
    var onFinish: (() -> Void)? { get set }
}
