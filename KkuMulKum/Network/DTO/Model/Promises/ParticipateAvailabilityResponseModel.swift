//
//  ParticipateAvailabilityResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/26/24.
//

import Foundation

// MARK: 약속 참여 가능자 목록

struct ParticipateAvailabilityResponseModel: ResponseModelType {
    let members: [AvailableMember]
}

struct AvailableMember: Codable {
    let memberID: Int
    let name: String?
    let profileImageURL: String?
    var isParticipant: Bool
    
    enum CodingKeys: String, CodingKey {
        case memberID = "memberId"
        case name
        case profileImageURL = "profileImg"
        case isParticipant
    }
}
