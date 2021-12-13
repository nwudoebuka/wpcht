//
//  ContactsRepoImpl.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 31/05/2021.
//

import Foundation

protocol ContactRepo {
    func checkWayaContacts(contacts: [[String: String]], completion: @escaping Handler)
}

class ContactsRepoImpl: ContactRepo {
    func checkWayaContacts(contacts: [[String: String]], completion: @escaping Handler) {
        let request = NetworkRequest(
            endpoint: .contact(.filterContact),
            method: .post,
            encoding: .json,
            body: ["contacts" : contacts]
        )
        
        Request.shared.fetch(request) { (status, _ response: Response<AuthContactResponse>?) in
            print("response: \(response)")
            
        }
    }
}
