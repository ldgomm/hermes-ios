//
//  KeyChainHelper.swift
//  Hermes
//
//  Created by José Ruiz on 25/11/24.
//

import Foundation
import Security

class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    private init() {}
    
    func save(_ token: String, forKey key: String) {
        let tokenData = Data(token.utf8)
        
        // Create a query to add the data to Keychain
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: tokenData
        ]
        
        // First, delete any existing item if it exists
        SecItemDelete(query as CFDictionary)
        
        // Add new token to Keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to save token.")
    }
    
    func read(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
    
    func delete(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        assert(status == errSecSuccess, "Failed to delete token.")
    }
}
