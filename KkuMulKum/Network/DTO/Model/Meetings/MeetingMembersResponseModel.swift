//
//  MembersOfMeetingResponseModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/8/24.
//

import Foundation

/// 특정 모임 내 멤버 목록을 조회 (Response)
struct MeetingMembersModel: ResponseModelType {
    let memberCount: Int
    let members: [Member]
}

struct Member: Codable {
    let memberID: Int
    let name: String
    let profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case name
        case profileImageURL = "profileImg"
    }
}
