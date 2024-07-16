//
//  PromiseParticipantListResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//

import Foundation


// MARK: 약속 참여자 목록

struct PromiseParticipantListModel: ResponseModelType {
    let participantCount: Int
    let participants: [Participant]
}

struct Participant: Codable {
    let participantId, memberId: Int
    let name, state: String
    let profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case participantId
        case memberId
        case name
        case state
        case profileImageURL = "profileImg"
    }
}
