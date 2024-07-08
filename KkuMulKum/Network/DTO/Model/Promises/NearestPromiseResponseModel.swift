//
//  NearestPromiseResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//


// MARK: 오늘 가장 가까운 약속 조회 (1개)

import Foundation

struct NearestPromiseResponseModel: Codable {
    let id, dDay: Int
    let name, meetingName, dressUpLevel, date, time, placeName: String
}
