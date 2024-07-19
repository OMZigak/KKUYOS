//
//  SocialLoginResponceModle.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/8/24.
//

import Foundation

/// 소셜 로그인 (Response)
struct SocialLoginResponseModel: ResponseModelType {
    let name: String?
    let jwtTokenDTO: JwtTokenDTO

    enum CodingKeys: String, CodingKey {
        case name
        case jwtTokenDTO = "jwtTokenDto"
    }
}

struct JwtTokenDTO: Codable {
    let accessToken: String
    let refreshToken: String
}

struct RefreshTokenResponseModel: ResponseModelType {
    let accessToken: String
    let refreshToken: String
}

struct UserInfoModel: ResponseModelType {
    let userId: Int
    let name: String
    let level: Int
    let promiseCount: Int
    let tardyCount: Int
    let tardySum: Int
    let profileImg: String?
}
