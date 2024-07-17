//
//  AuthTemp.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/8/24.
//

import Foundation

/// 소셜 로그인 (Request)
struct SocialLoginRequestModel: RequestModelType {
    let provider: String
    let fcmToken: String
}
