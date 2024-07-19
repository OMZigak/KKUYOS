//
//  MakeMeetingsResponseModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/8/24.
//

import Foundation

/// 모임 생성 (Response)
struct MakeMeetingsResponseModel: ResponseModelType {
    let meetingID: Int
    let invitationCode: String
    
    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case invitationCode
    }
}
