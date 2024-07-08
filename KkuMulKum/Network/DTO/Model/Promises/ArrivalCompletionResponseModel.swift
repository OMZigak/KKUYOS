//
//  ArrivalCompletionResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//


// MARK: 도착 완료 업데이트
// TODO: 서버에서 정확한 API 맞는지 답변 필요 (질문해둠)

import Foundation

struct ArrivalCompletionResponseModel: Codable {
    let name, profileImage: String
    let level, promiseCount, tardyCount, tardySum: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImage = "profileImg"
        case level
        case promiseCount
        case tardyCount
        case tardySum
    }
}
