//
//  NotificationViewModel.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 30/07/2021.
//

import Foundation
import Signals

class NotificationViewModel {
    
    let notifications = Signal<([Notification]?, String?)>()
    
    func getAllNotifications() {
        let userId = String(auth.data.userId!)
        let request = NetworkRequest(endpoint: .notification(.getNotifications(userId: userId)), method: .get, encoding: .urlJson, body: [:])
        
        Request.shared.fetch(request) { (status, _ response: Response<NotificationsResponse>?) in
            switch status {
            case .success:
                guard let response = response?.data as? NotificationsResponse  else {
                    self.notifications => (nil, nil)
                    return
                }
                self.notifications => (response.notifications, nil)
            case .failed(let error):
                self.notifications => (nil, error.localizedDescription)
            }
        }
    }
}
