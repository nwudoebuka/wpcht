//
//  WayaPayChat.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 23/08/2021.
//

import Foundation
import Signals

class WayaPayChat: UIApplication {

    static let activityBegan = Signal<()>()

    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        if let touches = event.allTouches {
            for touch in touches where touch.phase == .began {
                WayaPayChat.activityBegan => ()
            }
        }
    }
}
