//
//  RegisterMeetingsResponseModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/8/24.
//

import Foundation

/// 모임 가입 (Request)
struct RegisterMeetingsModel: RequestModelType {
    let invitationCode: String
}
