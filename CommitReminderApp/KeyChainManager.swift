//
//  KeyChainManager.swift
//  CommitReminderApp
//
//  Created by Madhumitha on 10/06/25.
//

import Foundation
import Security

class KeychainManager {
    static let shared = KeychainManager()

    func save(service: String, account: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }

    func load(service: String, account: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    static func saveToken(_ token: String) {
           let data = token.data(using: .utf8)!
           let query: [String: Any] = [
               kSecClass as String: kSecClassGenericPassword,
               kSecAttrAccount as String: "githubToken",
               kSecValueData as String: data
           ]
           SecItemDelete(query as CFDictionary) // Remove existing
           SecItemAdd(query as CFDictionary, nil)
       }

       static func loadToken() -> String? {
           let query: [String: Any] = [
               kSecClass as String: kSecClassGenericPassword,
               kSecAttrAccount as String: "githubToken",
               kSecReturnData as String: true,
               kSecMatchLimit as String: kSecMatchLimitOne
           ]
           var result: AnyObject?
           if SecItemCopyMatching(query as CFDictionary, &result) == noErr,
              let data = result as? Data {
               return String(data: data, encoding: .utf8)
           }
           return nil
       }
}
