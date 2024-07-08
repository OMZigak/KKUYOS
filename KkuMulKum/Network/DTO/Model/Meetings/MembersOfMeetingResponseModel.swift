//
//  MembersOfMeetingResponseModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/8/24.
//

import Foundation

struct MembersOfMeetingResponseModel: Codable {
    let memberCount: Int
    let members: [Member]
}

struct Member: Codable {
    let id: Int
    let name, profileImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageURL = "profileImg"
    }
}
