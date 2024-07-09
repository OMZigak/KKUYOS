//
//  UpcomingPromiseModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/10/24.
//

import UIKit

struct UpcomingPromiseModel {
    let name: String
    let meetingName: String
    let dDay: Int
    let date: String
    let time: String
    let placeName: String
}

extension UpcomingPromiseModel {
    static func dummy() -> [UpcomingPromiseModel] {
        return [
            UpcomingPromiseModel(name: "리프레쉬 데이", meetingName: "꾸물이들", dDay: 4, date: "2024.07.13", time: "PM 2:00", placeName: "어디가지"),
            UpcomingPromiseModel(name: "리프레쉬 데이", meetingName: "꾸물이들", dDay: 4, date: "2024.07.13", time: "PM 2:00", placeName: "어디가지"),
            UpcomingPromiseModel(name: "리프레쉬 데이", meetingName: "꾸물이들", dDay: 4, date: "2024.07.13", time: "PM 2:00", placeName: "어디가지"),
            UpcomingPromiseModel(name: "리프레쉬 데이", meetingName: "꾸물이들", dDay: 4, date: "2024.07.13", time: "PM 2:00", placeName: "어디가지")
        ]
    }
}
