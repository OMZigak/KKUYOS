//
//  MeetingInfoPromiseModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 8/22/24.
//

import Foundation

struct MeetingInfoPromiseModel {
    let state: MeetingPromiseCell.State
    let promiseID: Int
    let name: String
    let dDayText: String
    let dateText: String
    let timeText: String
    let placeName: String
}
