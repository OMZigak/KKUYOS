//
//  SocialLoginResponceModle.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/8/24.
//

import Foundation

struct SocialLoginResponseModel: ResponseModelType {
    let name, accessToken, refreshToken: String?
}
