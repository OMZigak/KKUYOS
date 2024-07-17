//
//  MeetingListResponseModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/8/24.
//

import Foundation

/// 가입한 모임 목록 조회 (Response)
struct MeetingListModel: ResponseModelType {
    let count: Int
    let meetings: [Meeting]
}

struct Meeting: Codable {
    let meetingID: Int
    let name: String
    let memberCount: Int
    
    enum CodingKeys: String, CodingKey {
        case meetingID = "meetingId"
        case name
        case memberCount
    }
}
