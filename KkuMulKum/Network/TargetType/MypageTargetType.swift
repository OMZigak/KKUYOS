//
//  MypageTargetType.swift
//  KkuMulKum
//
//  Created by 이지훈 on 8/22/24.
//

import Foundation

import Moya

enum UserTargetType {
    case getUserInfo
    case unsubscribe(authCode : String)
    case logout

}

extension UserTargetType: TargetType {
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
        case .getUserInfo:
            return "/api/v1/users/me"
        case .unsubscribe:
            return "/api/v1/auth/withdrawal"
        case .logout:
            return "/api/v1/auth/signout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        case .unsubscribe:
            return .delete
        case .logout:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        case .unsubscribe(let authCode):
            return .requestPlain
        case .logout:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        guard let token = DefaultKeychainService.shared.accessToken else {
            fatalError("No access token available")
        }
        var headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        if case .unsubscribe(let authCode) = self {
            headers["X-Apple-Code"] = authCode
        }
        
        return headers
    }
}
