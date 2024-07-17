//
//  UpcomingPromiseListResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//

import Foundation


// MARK: 다가올 약속 목록 조회 (4개)

struct UpcomingPromiseListModel: ResponseModelType {
    let promises: [UpcomingPromise]
}

struct UpcomingPromise: Codable {
    let promiseID, dDay: Int
    let name, meetingName, dressUpLevel, date, time, placeName: String
    
    enum CodingKeys: String, CodingKey {
        case promiseID = "promiseId"
        case dDay
        case name
        case meetingName
        case dressUpLevel
        case date
        case time
        case placeName
    }
}
