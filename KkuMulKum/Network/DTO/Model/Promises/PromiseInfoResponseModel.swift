//
//  PromiseInfoResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//


// MARK: 약속 상세 정보 조회

import Foundation

struct PromiseInfoModel: ResponseModelType {
    let placeName, address, roadAddress, time, dressUpLevel, penalty: String
}
