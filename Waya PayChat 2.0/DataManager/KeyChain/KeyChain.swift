//
//  KeyChain.swift
//  Waya PayChat 2.0
//
//  Created by Nwudo Anthony Chukwuebuka on 1/20/21.
//

import Foundation

class SecurityManager{
    
    static func deleteKeyChain(query: [String: Any]) -> Bool{
        let result = SecItemDelete(query as CFDictionary)
        
        return result == errSecSuccess
    }
    
    static func deleteUserPassword(email: String, password : String) -> Bool{
        
        let pwData = password.data(using: .utf8)!        
        let _query : [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: email        ]
        
        
        return deleteKeyChain(query: _query)
        
    }
    
    static func updateKeyChain(query: [String: Any],
                               attrs : [String: Any]) -> Bool{
        let result = SecItemUpdate(query as CFDictionary, attrs as CFDictionary)
        
        return result == errSecSuccess
    }
    
    static func updateUserPassword(email: String, password : String) -> Bool{
        
        let pwData = password.data(using: .utf8)!        
        let _query : [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: email        ]
        
        let attr : [String : Any] = [
            kSecValueData as String: pwData
        ]
        
        
        return updateKeyChain(query: _query, attrs: attr)
        
    }
    static func findInKeyChain(query : [String :Any]) -> String?{
        var item : CFTypeRef?
        let result = SecItemCopyMatching(query as CFDictionary, &item)
        guard result == errSecSuccess else{ return nil}
        
   
        
        guard  let theItem = item as? [String: Any],
               let pwData = theItem[kSecValueData as String] as? Data,
               let password = String(data: pwData, encoding: .utf8),
               let account = theItem[kSecAttrAccount as String] as? String 
        else { return nil}
        
        return password
        
    }

    
    static func addToKeyChain(query: [String : Any]) -> Bool{
        
        let result = SecItemAdd(query as CFDictionary, nil)
      
        
        return result == errSecSuccess
    }
    
    static func storePassword(email: String, password: String) -> Bool{
        
        // Store Username and Passowrd in Keychain
        let pwData = password.data(using: .utf8)!        
        let _query : [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: email,
                                       kSecValueData as String: pwData
        ]
        
        return addToKeyChain(query: _query)
    }
    
    /**
            Store user pin in keychain
     */
    static func storePin(firstName: String, pin: String) -> Bool{
        
        // Store FirstName and Pin in Keychain
        let pwData = pin.data(using: .utf8)!        
        let _query : [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: firstName,
                                       kSecValueData as String: pwData
        ]
        
        return addToKeyChain(query: _query)
    }
    
    
    static func retrievePassword(email : String) -> String?{
        let _query : [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: email,
                                       kSecReturnAttributes as String : true,
                                       kSecReturnData as String: true 
        ]
        
        return findInKeyChain(query: _query)
    }
    
    /*retrieve user pin
     **/
    static func retrievePin(firstName : String) -> String?{
        let _query : [String : Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: firstName,
                                       kSecReturnAttributes as String : true,
                                       kSecReturnData as String: true 
        ]
        
        return findInKeyChain(query: _query)
    }
}
