//
//  AuthServiceType.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/14/24.
//

import Foundation

protocol AuthServiceType {
    func saveAccessToken(_ token: String)
    func saveRefreshToken(_ token: String)
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func clearTokens()
}

class AuthService: AuthServiceType {
    private var keychainService: KeychainService
    
    init(keychainService: KeychainService = DefaultKeychainService.shared) {
        self.keychainService = keychainService
    }
    
    func saveAccessToken(_ token: String) {
        keychainService.accessToken = token
    }
    
    func saveRefreshToken(_ token: String) {
        keychainService.refreshToken = token
    }
    
    func getAccessToken() -> String? {
        return keychainService.accessToken
    }
    
    func getRefreshToken() -> String? {
        return keychainService.refreshToken
    }
    
    ///앱잼내 구현 X
    func clearTokens() {
//        keychainService.accessToken = nil
//        keychainService.refreshToken = nil
    }
}
