//
//  MeetingInfoResponseModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/8/24.
//

import Foundation

/// 특정 모임 정보를 조회 (Response)
struct MeetingInfoModel: ResponseModelType {
    let meetingID: Int
    let name: String
    let createdAt: String
    let metCount: Int
    let invitationCode: String
    
    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case name
        case createdAt
        case metCount
        case invitationCode
    }
}
