//
//  RegisterView.swift
//  Waya PayChat 2.0 
//
//  Created by Home on 3/3/21.
//

protocol RegisterView : BaseView {
    
    var onNextButtonTap : ((_ authViewModel : AuthViewModelImpl) -> Void)? { get set}
    var onBackButtonPressed : (() -> Void )? { get set}
    var selected: AccountType {get set}
}
