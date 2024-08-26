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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        guard let token = DefaultKeychainService.shared.accessToken else {
            fatalError("No access token available")
        }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
}
