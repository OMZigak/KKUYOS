//
//  MeetingListModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/12/24.
//

import UIKit

struct MeetingDummyModel {
    let name: String
    let count: Int
}

extension MeetingDummyModel {
    static func dummy() -> [MeetingDummyModel] {
            return [
                MeetingDummyModel(name: "꾸물이들", count: 14),
                MeetingDummyModel(name: "꾸물이들", count: 14),
                MeetingDummyModel(name: "꾸물이들", count: 14),
                MeetingDummyModel(name: "꾸물이들", count: 14),
                MeetingDummyModel(name: "꾸물이들", count: 14),
                MeetingDummyModel(name: "꾸물이들", count: 14),
                MeetingDummyModel(name: "꾸물이들", count: 14),
                MeetingDummyModel(name: "꾸물이들", count: 14),
                MeetingDummyModel(name: "꾸물이들", count: 14)
            ]
        }
}
