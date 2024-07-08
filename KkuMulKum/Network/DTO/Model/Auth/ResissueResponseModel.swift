//
//  ResissueResponseModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/8/24.
//

import Foundation

struct ReissueModel: ResponseModelType {
    let accessToken, refreshToken: String?
}
