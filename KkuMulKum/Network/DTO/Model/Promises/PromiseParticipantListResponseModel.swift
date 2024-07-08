//
//  PromiseParticipantListResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//

import Foundation


// MARK: 약속 참여자 목록

struct PromiseParticipantListModel: ResponseModelType {
    let participants: [Participant]
}

struct Participant: Codable {
    let id: Int
    let name, profileImageURL, state: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageURL = "profileImg"
        case state
    }
}
