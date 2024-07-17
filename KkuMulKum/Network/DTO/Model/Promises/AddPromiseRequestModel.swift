//
//  AddPromiseRequestModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//


// MARK: 약속 추가

import Foundation

struct AddPromiseRequestModel: RequestModelType {
    let name, placeName, address, roadAddress, time, dressUpLevel, penalty: String
    let x, y: Double
    let id: Int
    let participants: [Int]
}
