//
//  MeetingListResponseModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/8/24.
//

import Foundation

struct MeetingListModel: ResponseModelType {
    let count: Int
    let meetings: [Meeting]
}

struct Meeting: Codable {
    let id: Int
    let name: String
    let memberCount: Int
}
