//
//  PromiseInfoResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//

import Foundation


// MARK: 약속 상세 정보 조회

struct PromiseInfoModel: ResponseModelType {
    let isParticipant: Bool
    let promiseID: Int
    let promiseName, placeName, time, dressUpLevel, penalty: String
    let address, roadAddress: String?
    let x, y: Double
    
    enum CodingKeys: String, CodingKey {
        case isParticipant
        case promiseID = "promiseId"
        case promiseName
        case placeName
        case x
        case y
        case address
        case roadAddress
        case time
        case dressUpLevel
        case penalty
    }
}
