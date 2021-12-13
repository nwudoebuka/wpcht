//
//  SettingsViewModel.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 23/08/2021.
//

import Foundation

class SettingsViewModel {
    let repo = SettingsRepositoryImpl()
    
    func toggleSmsAlert(completion: @escaping Handler) {
        repo.toggleSmsAlert { (result) in
            switch result {
            case .success(let status):
                completion(.success(status))
            case .failure(let error):
                completion(.failure(.custom(message: error.localizedDescription)))
            }
        }
    }
}
