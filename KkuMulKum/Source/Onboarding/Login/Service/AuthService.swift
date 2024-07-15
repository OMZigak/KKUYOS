//
//  AuthServiceType.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/14/24.
//

import Foundation

protocol AuthServiceType {
    
    // TODO: 토큰 관리를 위한 메서드 (키체인 생성이후 구현예정)
    func saveToken(_ token: String)
    func getToken() -> String?
    func clearToken()
}

class AuthService: AuthServiceType {
    func saveToken(_ token: String) {
        
    }
    
    func getToken() -> String? {
        
        return nil
    }
    
    func clearToken() {
    }
    
}
