//
//  SocialLoginResponceModle.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/8/24.
//

import Foundation

struct UserData: ResponseModelType {
    let name: String?
    let jwtTokenDto: JwtTokenDto

    enum CodingKeys: String, CodingKey {
        case name
        case jwtTokenDto // 서버 응답과
    }
}

struct JwtTokenDto: Codable {
    let accessToken: String
    let refreshToken: String
}
