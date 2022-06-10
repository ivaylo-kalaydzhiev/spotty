//
//  KeychainManager.swift
//  spotty
//
//  Created by Ivaylo Kalaydzhiev on 10.06.22.
//

import Foundation

/// Provides an interface to interact with the Keychain Storage.
struct KeychainManager {
    
    struct Services {
        
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let expirationDate = "expirationDate"
    }
    
    struct Accounts {
        
        static let spotify = "spotify"
    }
    
    
    /// Persist item in the Keychain and if an item with such Identifiery already exists it updates its value.
    /// - Parameters:
    ///   - data: The Item you want to persist.
    ///   - service: Identifier.
    ///   - account: The account to which this item relates.
    static func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        // If item already exists, update it.
        if status == errSecDuplicateItem {
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    /// Read item from the Keychain.
    /// - Parameters:
    ///   - service: Identifier.
    ///   - account: The account to which this item relates.
    /// - Returns: The item from the Keychain if one was found.
    static func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
}
