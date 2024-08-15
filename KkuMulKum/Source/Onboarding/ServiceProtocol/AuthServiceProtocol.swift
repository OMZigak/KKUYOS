//
//  AuthServiceType.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/15/24.
//

import Foundation

protocol AuthServiceType {
    func saveAccessToken(_ token: String) -> Bool
    func saveRefreshToken(_ token: String) -> Bool
    func getAccessToken() -> String?
    func getRefreshToken() -> String?
    func clearTokens() -> Bool
    func performRequest<T: ResponseModelType>(_ target: AuthTargetType) async throws -> T
}

