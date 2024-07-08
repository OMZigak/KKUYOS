//
//  ResissueResponseModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/8/24.
//

import Foundation


// MARK: - ReissueResponseModel

struct ReissueResponseModel: Codable {
    let accessToken, refreshToken: String?
}
