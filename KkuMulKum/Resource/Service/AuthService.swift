//
//  AuthServiceType.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/14/24.
//

import Foundation

protocol AuthServiceType {
    func saveAccessToken(_ token: String) -> Bool
    func saveRefreshToken(_ token: String) -> Bool
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func clearTokens() -> Bool
}

class AuthService: AuthServiceType {
    private var keychainService: KeychainService
    
    init(keychainService: KeychainService = DefaultKeychainService.shared) {
        self.keychainService = keychainService
    }
    
    func saveAccessToken(_ token: String) -> Bool {
        keychainService.accessToken = token
        return keychainService.accessToken == token
    }
    
    func saveRefreshToken(_ token: String) -> Bool {
        keychainService.refreshToken = token
        return keychainService.refreshToken == token
    }
    
    func getAccessToken() -> String? {
        return keychainService.accessToken
    }
    
    func getRefreshToken() -> String? {
        return keychainService.refreshToken
    }
    
    func clearTokens() -> Bool {
        keychainService.accessToken = nil
        keychainService.refreshToken = nil
        return keychainService.accessToken == nil && keychainService.refreshToken == nil
    }
}
