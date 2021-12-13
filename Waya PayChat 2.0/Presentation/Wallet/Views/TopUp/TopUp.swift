//
//  TopUp.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 02/08/2021.
//

import Foundation
import Signals

protocol TopUpView: UIView {
    var onError: Signal<(String)> { get set}
}

protocol BankTopUp: TopUpView {
    var allowedBanks: [Bank] { get set}
    var userBanks: [Bank] {get set}
    var onContinue: ((Bank, String) -> Void)? { get set}
    func refresh()
}

protocol CardTopUp: TopUpView {
    var cards: [CardResponse] { get set}
    var onContinue: Signal<(CardResponse, String)> {get set}
}
