//
//  ContactViewModel.swift
//  Waya PayChat 2.0
//
//  Created by Mark Boleigha on 31/05/2021.
//

import Foundation
import Contacts

protocol ContactsViewModel {
    
}

class ContactViewModelImpl {
    var contacts = [Contact]()
    var filteredContacts = [Contact]()
    var wayaContacts = [Contact]()
    let contactRepo = ContactsRepoImpl()
    
    func loadContacts(completion: @escaping (Bool, String?) -> Void) {
        let permission = CNContactStore.authorizationStatus(for: .contacts)
        if permission == .authorized {
            let keys = [CNContactPhoneNumbersKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
            do {
                try CNContactStore().enumerateContacts(with: request) { [weak self]  (contact, stop) in
                    var _contact = Contact(phone: [], name: "", image: "", wayaUser: false)
                    for phoneNumber in contact.phoneNumbers {
                        let number = phoneNumber.value
                        let formated = self?.formatNumber(number: number.stringValue)
                        _contact.phone.append(formated!)
                    }
                }
                
                completion(true, nil)
            } catch {
                completion(false, "unable to fetch contacts")
            }
        } else {
            completion(false, "Please allow access to contacts")
        }
    }
    
    func requestContactAccess(completion: @escaping (Bool, String?) -> Void) {
        let permission = CNContactStore.authorizationStatus(for: .contacts)
        switch permission {
        case .authorized:
            completion(true, nil)
        case .notDetermined:
            CNContactStore().requestAccess(for: .contacts) { (granted, error) in
                completion(granted, nil)
            }
        case .restricted, .denied:
            completion(false, "Access to Contacts is denied")
        }
    }
    
    func filter(nameOrPhone: String , completion: @escaping () -> Void) {
        self.filteredContacts = self.contacts.filter { $0.phone.contains(nameOrPhone)}
    }
    
    private func formatNumber(number: String) -> String {
        
        var number_sanitized = number.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "+", with: "")
        if number_sanitized.hasPrefix("0") {
            number_sanitized = "234" + number_sanitized.substring(1)
        } else if number_sanitized.hasPrefix("234") {
            return number_sanitized
        }
        
        return number_sanitized
    }
    
    func checkForWayaUsers(completion: (() -> Void)? = nil) {
        var list = [Dictionary<String, String>]()
        contacts.forEach { (contact) in
            for number in contact.phone {
                list.append(["phone" : number])
            }
        }
        
        contactRepo.checkWayaContacts(contacts: list) { (result) in
            switch result {
            case .success(let contacts):
                print("contact result: \(contacts)")
            case .failure(let error):
                print("failure: \(error.localizedDescription)")
            }
        }
    }
}
