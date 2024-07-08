//
//  AddPromiseRequestModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//


// MARK: 약속 추가

import Foundation

struct AddPromiseRequestModel: Codable {
    let name, placeName, x, y, address, roadAddress, time, dressUpLevel, penalty: String
    let id: Int
    let participants: [Int]
}
