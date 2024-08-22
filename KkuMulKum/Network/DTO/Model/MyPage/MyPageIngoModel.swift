//
//  MyPageIngoModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import Foundation


struct MyPageUserInfo: ResponseModelType {
    let userId: Int
    let name: String?
    let level: Int
    let promiseCount: Int
    let tardyCount: Int
    let tardySum: Int
    let profileImg: String?
}
