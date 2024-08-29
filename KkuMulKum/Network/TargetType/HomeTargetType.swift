//
//  HomeTargetType.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/17/24.
//

import Foundation

import Moya

enum HomeTargetType {
    case fetchLoginUser
    case fetchNearestPromise
    case fetchUpcomingPromise
    case updatePreparationStatus(promiseID: Int)
    case updateDepartureStatus(promiseID: Int)
    case updateArrivalStatus(promiseID: Int)
    case fetchMyReadyStatus(promiseID: Int)
}

extension HomeTargetType: TargetType {
    var baseURL: URL {
        guard let url = Bundle.main.baseURL else {
            fatalError("Invalid BASE_URL in PrivacyInfo.plist")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchLoginUser:
            return "/api/v1/users/me"
        case .fetchNearestPromise:
            return "/api/v1/promises/today/next"
        case .fetchUpcomingPromise:
            return "/api/v1/promises/upcoming"
        case .updatePreparationStatus(let promiseID):
            return "/api/v1/promises/\(promiseID)/preparation"
        case .updateDepartureStatus(let promiseID):
            return "/api/v1/promises/\(promiseID)/departure"
        case .updateArrivalStatus(let promiseID):
            return "/api/v1/promises/\(promiseID)/arrival"
        case .fetchMyReadyStatus(let promiseID):
            return "/api/v1/promises/\(promiseID)/status"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchLoginUser, .fetchNearestPromise, .fetchUpcomingPromise, .fetchMyReadyStatus:
            return .get
        case .updatePreparationStatus, .updateDepartureStatus, .updateArrivalStatus:
            return .patch
        }
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
