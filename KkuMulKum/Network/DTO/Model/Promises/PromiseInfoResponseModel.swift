//
//  PromiseInfoResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//

import Foundation


// MARK: 약속 상세 정보 조회

struct PromiseInfoModel: ResponseModelType {
    let promiseID: Int
    let promiseName, placeName, address, roadAddress, time, dressUpLevel, penalty: String
    
    enum CodingKeys: String, CodingKey {
        case promiseID = "promiseId"
        case promiseName
        case placeName
        case address
        case roadAddress
        case time
        case dressUpLevel
        case penalty
    }
}
