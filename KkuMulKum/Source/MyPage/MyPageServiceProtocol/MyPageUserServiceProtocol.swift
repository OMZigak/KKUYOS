//
//  MyPageUserServiceProtocol.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import Foundation

protocol MyPageUserServiceProtocol {
    func getUserInfo() async throws -> LoginUserModel
    func performRequest<T: ResponseModelType>(_ target: UserTargetType) async throws -> T
    func unsubscribe(authCode: String) async throws -> Void
}
