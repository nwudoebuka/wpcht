//
//  SettingsRepositoryImpl.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 23/08/2021.
//

import Foundation

class SettingsRepositoryImpl {
    
    func toggleSmsAlert(completion: @escaping Handler) {
        let trimPhone = (auth.data.profile!.phoneNumber.starts(with: "+")) ? auth.data.profile!.phoneNumber.substring(1) : auth.data.profile!.phoneNumber
        let request = NetworkRequest(endpoint: .profile(.smsAlertConfig), method: .post, encoding: .json, body: ["phoneNumber" : trimPhone])
        Request.shared.fetch(request) { (status, _ response: Response<SMSAlertConfigResponse>?) in
            switch status {
            case .success:
                if let response = response {
                    if response.status == true {
                        completion(.success(response.data?.active))
                    } else {
                        completion(.failure(.custom(message: response.message!)))
                    }
                }
            case .failed(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
}
