//
//  KeychainWrapper.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/15/24.

import Foundation
import SwiftKeychainWrapper

protocol KeychainAccessible {
    func saveToken(_ key: String, _ value: String) -> Bool
    func saveExpiresIn(_ key: String, _ value: Int) -> Bool
    func getToken(_ key: String) -> String?
    func getExpiresIn(_ Key: String) -> Int?
    func remove(_ key: String) -> Bool
    func removeAll() -> Bool
}

class DefaultKeychainAccessible: KeychainAccessible {
    private var keychain = KeychainWrapper.standard
    
    func saveToken(_ key: String, _ value: String) -> Bool {
        let result = keychain.set(value, forKey: key, withAccessibility: .afterFirstUnlock)
        return result
    }
    
    func getToken(_ key: String) -> String? {
        let token = keychain.string(forKey: key)
        return token
    }
    
    func saveExpiresIn(_ key: String, _ value: Int) -> Bool {
        return keychain.set(value, forKey: key, withAccessibility: .afterFirstUnlockThisDeviceOnly)
    }
    
    
    
    func getExpiresIn(_ Key: String) -> Int? {
        return keychain.integer(forKey: Key)
    }
    
    func remove(_ key: String) -> Bool {
        return keychain.removeObject(forKey: key)
    }
    
    func removeAll() -> Bool {
        return keychain.removeAllKeys()
    }
}
