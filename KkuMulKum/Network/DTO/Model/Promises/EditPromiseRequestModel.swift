//
//  EditPromiseRequestModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/26/24.
//

import Foundation


// MARK: 약속 정보 수정

struct EditPromiseRequestModel: RequestModelType {
    let name, placeName, address, roadAddress, time, dressUpLevel, penalty: String
    let x, y: Double
    let participants: [Int]
}
