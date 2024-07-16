//
//  KeychainWrapper.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/15/24.
//

import Foundation
import SwiftKeychainWrapper

protocol KeychainAccessible {
    func saveToken(_ key: String, _ value: String)
    func saveExpiresIn(_ key: String, _ value: Int)
    func getToken(_ key: String) -> String?
    func getExpiresIn(_ Key: String) -> Int?
    func remove(_ key: String)
    func removeAll()
}

class DefaultKeychainAccessible: KeychainAccessible {
    private let keychain = KeychainWrapper.standard
    
    func saveToken(_ key: String, _ value: String) {
        keychain.set(value, forKey: key)
    }
    
    func saveExpiresIn(_ key: String, _ value: Int) {
        keychain.set(value, forKey: key)
    }
    
    func getToken(_ key: String) -> String? {
        keychain.string(forKey: key)
    }
    
    func getExpiresIn(_ Key: String) -> Int? {
        keychain.integer(forKey: Key)
    }
    
    func remove(_ key: String) {
        keychain.removeObject(forKey: key)
    }
    
    func removeAll() {
        keychain.removeAllKeys()
    }
}
