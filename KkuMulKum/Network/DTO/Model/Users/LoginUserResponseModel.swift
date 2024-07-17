//
//  LoginUserResponseModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/8/24.
//

import Foundation

/// 현재 로그인된 유저의 정보를 조회 (Response)
struct LoginUserModel: ResponseModelType {
    let userID: Int
    let name: String?
    let level: Int
    let promiseCount: Int
    let tardyCount: Int
    let tardySum: Int
    let profileImageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case name
        case level
        case promiseCount
        case tardyCount
        case tardySum
        case profileImageURL = "profileImg"
    }
}
