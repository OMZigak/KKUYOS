//
//  LoginUserResponseModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/8/24.
//

import Foundation

struct LoginUserResponseModel: Codable {
    let name: String
    let level: Int
    let promiseCount: Int
    let tardyCount: Int
    let tardySum: Int
    let profileImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case level
        case promiseCount
        case tardyCount
        case tardySum
        case profileImageURL = "profileImg"
    }
}
