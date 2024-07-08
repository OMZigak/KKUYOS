//
//  UpcomingPromiseListResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//


// MARK: 다가올 약속 목록 조회 (4개)

import Foundation

struct UpcomingPromiseListResponseModel: Codable {
    let promises: [UpcomingPromise]
}

struct UpcomingPromise: Codable {
    let id, dDay: Int
    let name, meetingName, dressUpLevel, date, time, placeName: String
}
