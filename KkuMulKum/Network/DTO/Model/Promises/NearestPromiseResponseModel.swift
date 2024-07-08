//
//  NearestPromiseResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//

import Foundation


// MARK: 오늘 가장 가까운 약속 조회 (1개)

struct NearestPromiseModel: ResponseModelType {
    let id, dDay: Int
    let name, meetingName, dressUpLevel, date, time, placeName: String
}
