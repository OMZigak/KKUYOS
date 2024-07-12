//
//  MeetingPromisesModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/10/24.
//

import Foundation

struct MeetingPromisesModel: ResponseModelType {
    let promises: [MeetingPromise]
}

struct MeetingPromise: Codable {
    let id: Int
    let name: String
    let dDay: Int
    let date: String
    let time: String
    let placeName: String
}
