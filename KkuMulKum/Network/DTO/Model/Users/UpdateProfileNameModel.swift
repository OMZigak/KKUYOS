//
//  UpdateProfileNameModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/8/24.
//

import Foundation

/// 사용자 프로필 이름 수정 (Request, Response)
struct UpdateProfileNameModel: RequestModelType, ResponseModelType {
    let name: String
}
