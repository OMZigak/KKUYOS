//
//  AddPromiseResponseModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/17/24.
//

import Foundation

struct AddPromiseResponseModel: ResponseModelType {
    let promiseID: Int
    let placeName: String
    let address: String
    let roadAddress: String
    let time: String
    let dressUpLevel: String
    let penalty: String
    
    enum CodingKeys: String, CodingKey {
        case promiseID = "promiseId"
        case placeName
        case address
        case roadAddress
        case time
        case dressUpLevel
        case penalty
    }
}
