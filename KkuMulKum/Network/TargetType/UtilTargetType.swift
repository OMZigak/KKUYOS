//
//  UtilTargetType.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/18/24.
//

import Foundation

import Moya

enum UtilTargetType {
    case searchPlaceList(keyword: String)
}

extension UtilTargetType: TargetType {
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
        case .searchPlaceList(let keyword):
            return "/api/v1/locations?q=\(keyword)"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        .requestPlain
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
