//
//  AuthError.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/19/24.
//

import Foundation

enum NetworkError: Error {
    case invalidImageFormat
    case imageSizeExceeded
    case userNotFound
    case decodingError
    case networkError
    case unknownError(String)
    
    var message: String {
        switch self {
        case .invalidImageFormat:
            return "이미지 확장자는 jpg, png, webp만 가능합니다."
        case .imageSizeExceeded:
            return "이미지 사이즈는 5MB를 넘을 수 없습니다."
        case .userNotFound:
            return "유저를 찾을 수 없습니다."
        case .decodingError:
            return "데이터 디코딩 중 오류가 발생했습니다."
        case .networkError:
            return "네트워크 오류가 발생했습니다."
        case .unknownError(let message):
            return message
        }
    }
}
