//
//  MeetingListTargetType.swift
//  KkuMulKum
//
//  Created by 예삐 on 8/26/24.
//

import Foundation

import Moya

enum MeetingListTargetType {
    case fetchLoginUser
    case fetchMeetingList
}

extension MeetingListTargetType: TargetType {
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
        case .fetchLoginUser:
            return "/api/v1/users/me"
        case .fetchMeetingList:
            return "/api/v1/meetings"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        guard let token = DefaultKeychainService.shared.accessToken else {
            return ["Content-Type" : "application/json"]
        }
        
        return [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer \(token)"
        ]
    }
}
