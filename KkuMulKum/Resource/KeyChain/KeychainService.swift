//
//  KeychainService.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/15/24.
//

import Foundation
import SwiftKeychainWrapper
import Security

protocol KeychainService {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }
    func removeAllTokens()
    func verifyKeychainAccess()
}

class DefaultKeychainService: KeychainService {
    static let shared = DefaultKeychainService()
    
    private let keychain: KeychainWrapper
    
    private struct Key {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }
    
    init() {
        let serviceName = Bundle.main.privacyInfo?["ServiceName"] as? String ?? Bundle.main.bundleIdentifier ?? "DefaultServiceName"
        self.keychain = KeychainWrapper(serviceName: serviceName)
        print("Keychain initialized with service name: \(serviceName)")
    }
    
    var accessToken: String? {
        get {
            let token = keychain.string(forKey: Key.accessToken)
            print("Reading Access Token: \(token ?? "nil")")
            return token
        }
        set {
            if let newValue = newValue {
                let success = keychain.set(newValue, forKey: Key.accessToken)
                print("Setting Access Token: \(newValue)")
                if success {
                    print("Access Token saved successfully")
                    // 저장 후 즉시 읽어 확인
                    if let savedToken = keychain.string(forKey: Key.accessToken) {
                        print("Verified Access Token: \(savedToken)")
                    } else {
                        print("Failed to verify Access Token after saving")
                    }
                } else {
                    print("Failed to save Access Token")
                    printKeychainError(forKey: Key.accessToken)
                }
            } else {
                let success = keychain.removeObject(forKey: Key.accessToken)
                print(success ? "Access Token removed successfully" : "Failed to remove Access Token")
            }
        }
    }
    
    var refreshToken: String? {
        get {
            let token = keychain.string(forKey: Key.refreshToken)
            print("Reading Refresh Token: \(token ?? "nil")")
            return token
        }
        set {
            if let newValue = newValue {
                let success = keychain.set(newValue, forKey: Key.refreshToken)
                print("Setting Refresh Token: \(newValue)")
                if success {
                    print("Refresh Token saved successfully")
                    // 저장 후 즉시 읽어 확인
                    if let savedToken = keychain.string(forKey: Key.refreshToken) {
                        print("Verified Refresh Token: \(savedToken)")
                    } else {
                        print("Failed to verify Refresh Token after saving")
                    }
                } else {
                    print("Failed to save Refresh Token")
                    printKeychainError(forKey: Key.refreshToken)
                }
            } else {
                let success = keychain.removeObject(forKey: Key.refreshToken)
                print(success ? "Refresh Token removed successfully" : "Failed to remove Refresh Token")
            }
        }
    }
    
    func removeAllTokens() {
        keychain.removeObject(forKey: Key.accessToken)
        keychain.removeObject(forKey: Key.refreshToken)
        print("All tokens removed from keychain")
    }
    
    func verifyKeychainAccess() {
        let testKey = "TestKeychainAccess"
        let testValue = "TestValue"
        
        // 키체인에 테스트 값 저장
        let saveSuccess = keychain.set(testValue, forKey: testKey)
        if saveSuccess {
            print("Test value saved to keychain successfully")
            
            // 저장된 값 읽기
            if let retrievedValue = keychain.string(forKey: testKey) {
                print("Test value retrieved successfully: \(retrievedValue)")
            } else {
                print("Failed to retrieve test value")
            }
            
            // 테스트 값 삭제
            let removeSuccess = keychain.removeObject(forKey: testKey)
            print(removeSuccess ? "Test value removed successfully" : "Failed to remove test value")
        } else {
            print("Failed to save test value to keychain")
            printKeychainError(forKey: testKey)
        }
    }
    
    private func printKeychainError(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecAttrService as String: keychain.serviceName,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        print("Keychain error for key '\(key)': \(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString)")
    }
}
