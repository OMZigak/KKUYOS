//
//  SocialLoginResponceModle.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/8/24.
//

import Foundation

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
