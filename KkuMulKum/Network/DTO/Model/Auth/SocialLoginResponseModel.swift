//
//  SocialLoginResponceModle.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/8/24.
//

import Foundation

struct SocialLoginResponseModel: ResponseModelType {
    let success: Bool
    let data: LoginData?
    let error: ErrorData?
}

struct LoginData: Codable {
    let name: String?
    let jwtTokenDto: JwtTokenDto
}

struct JwtTokenDto: Codable {
    let accessToken: String
    let refreshToken: String
}

struct ErrorData: Codable {
    let code: Int
    let message: String
}
