//
//  ReissueModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/8/24.
//

import Foundation

/// 토큰 재발급 (Response)
struct ReissueModel: ResponseModelType {
    let accessToken, refreshToken: String
}
