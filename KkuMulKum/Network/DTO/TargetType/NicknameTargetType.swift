//
//  LoginTatgetType.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/16/24.
//

import Foundation

import Moya

enum NicknameTargetType {
    case updateName(name: String)
}

extension NicknameTargetType: TargetType {
    
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
        case .updateName:
            return "/api/v1/users/me/name"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateName:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .updateName(let name):
            return .requestParameters(parameters: ["name": name], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        guard let token = DefaultKeychainService.shared.accessToken else {
            fatalError("No access token available")
        }
        return ["Content-Type": "application/json", "Authorization": "Bearer \(token)"]
    }
}
