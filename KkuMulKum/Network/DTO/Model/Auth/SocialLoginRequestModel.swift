//
//  AuthTemp.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/8/24.
//

import Foundation

struct SocialLoginRequestModel: RequestModelType {
    let provider: String?
    let fcmToken: String

}
