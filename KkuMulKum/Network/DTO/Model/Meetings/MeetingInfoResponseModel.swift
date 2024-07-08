//
//  MeetingInfoResponseModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/8/24.
//

import Foundation

struct MeetingInfoResponseModel: Codable {
    let id: Int
    let name, createdAt: String
    let metCount: Int
    let invitationCode: String
}
