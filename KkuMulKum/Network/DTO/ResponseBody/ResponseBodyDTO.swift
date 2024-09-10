//
//  ResponseBodyDTO.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/8/24.
//

import Foundation

/// 제네릭 ResponseBody 구조체 정의
struct ResponseBodyDTO<T: ResponseModelType>: Codable {
    let success: Bool
    let data: T?
    let error: ErrorResponse?
}

/// 에러 응답 구조체 정의
struct ErrorResponse: Codable {
    let code: Int
    let message: String
}
