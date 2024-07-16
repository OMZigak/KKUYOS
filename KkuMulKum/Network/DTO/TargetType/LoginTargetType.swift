//
//  LoginService.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/15/24.
//

import Foundation

import Moya

enum LoginTargetType {
    case appleLogin(identityToken: String, fcmToken: String)
    case kakaoLogin(accessToken: String, fcmToken: String)
    case refreshToken(refreshToken: String)
}

extension LoginTargetType: TargetType {
    
    var method: Moya.Method {
        .post
    }
    
    var baseURL: URL {
        guard let privacyInfo = Bundle.main.privacyInfo,
              let urlString = privacyInfo["BASE_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("Invalid BASE_URL in PrivacyInfo.plist")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .appleLogin, .kakaoLogin:
            return "/api/v1/auth/signin"
        case .refreshToken:
            return "/api/v1/auth/reissue"
        }
    }
    
    var task: Task {
        switch self {
        case let .appleLogin(_, fcmToken):
            return .requestParameters(
                parameters: ["provider": "APPLE", "fcmToken": fcmToken],
                encoding: JSONEncoding.default
            )
        case let .kakaoLogin(_, fcmToken):
            return .requestParameters(
                parameters: ["provider": "KAKAO", "fcmToken": fcmToken],
                encoding: JSONEncoding.default
            )
        case .refreshToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .appleLogin(let identityToken, _):
            return ["Authorization": identityToken, "Content-Type": "application/json"]
        case .kakaoLogin(let accessToken, _):
            return ["Authorization": accessToken, "Content-Type": "application/json"]
        case .refreshToken(let refreshToken):
            return ["Authorization": refreshToken, "Content-Type": "application/json"]
        }
    }
}
