//
//  RegisterMeetingsResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/19/24.
//

import Foundation

/// 모임 가입 (Response)
struct RegisterMeetingsResponseModel: ResponseModelType {
    let meetingID: Int
    
    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
    }
}
