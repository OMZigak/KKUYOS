//
//  ServiceProtocol.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import Foundation

protocol MyPageUserServiceType {
    func getUserInfo() async throws -> LoginUserModel
    func performRequest<T: ResponseModelType>(_ target: UserTargetType) async throws -> T
}
