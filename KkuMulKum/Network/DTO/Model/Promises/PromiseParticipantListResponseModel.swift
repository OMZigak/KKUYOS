//
//  PromiseParticipantListResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//


// MARK: 약속 참여자 목록

import Foundation

struct PromiseParticipantListResponseModel: Codable {
    let participants: [Participant]
}

struct Participant: Codable {
    let id: Int
    let name, profileImage, state: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImage = "profileImg"
        case state
    }
}
