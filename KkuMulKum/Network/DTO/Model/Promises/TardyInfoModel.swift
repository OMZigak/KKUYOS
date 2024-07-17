//
//  PromiseLateInfoResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//

import Foundation


// MARK: 약속 지각 상세 조회

struct TardyInfoModel: ResponseModelType {
    let penalty: String
    let isPastDue: Bool
    let lateComers: [Comer]
}

struct Comer: Codable {
    let participantId: Int
    let name, profileImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case participantId
        case name
        case profileImageURL = "profileImg"
    }
}
