//
//  Keychain.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/16/24.
//

import Foundation
import Security

protocol KeychainService {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
}

class DefaultKeychainService: KeychainService {
    static let shared = DefaultKeychainService()
    
    private init() {}
    
    private func save(_ data: Data, forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    private func load(forKey key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        return result as? Data
    }
    
    var accessToken: String? {
        get {
            guard let data = load(forKey: "accessToken") else { return nil }
            return String(data: data, encoding: .utf8)
        }
        set {
            guard let newValue = newValue else {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: "accessToken"
                ]
                SecItemDelete(query as CFDictionary)
                return
            }
            save(Data(newValue.utf8), forKey: "accessToken")
        }
    }
    
    var refreshToken: String? {
        get {
            guard let data = load(forKey: "refreshToken") else { return nil }
            return String(data: data, encoding: .utf8)
        }
        set {
            guard let newValue = newValue else {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: "refreshToken"
                ]
                SecItemDelete(query as CFDictionary)
                return
            }
            save(Data(newValue.utf8), forKey: "refreshToken")
        }
    }
}
