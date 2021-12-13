//
//  VerifyPinView.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 3/9/21.
//

protocol VerifyPinView : BaseView{
    var onPinSuccessful: ((_ pin: String?) -> Void)? { get set} // we are returning the pin to a change pin flow
    var forgotPin : ((() -> Void))? { get set }
}
