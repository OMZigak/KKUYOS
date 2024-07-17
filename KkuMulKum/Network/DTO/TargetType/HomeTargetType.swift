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
}

extension HomeTargetType: TargetType {
    var baseURL: URL {
        guard let baseURL = URL(string: "/api/v1") else {
            fatalError("Error: Invalid Meeting BaseURL")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .fetchLoginUser:
            return "/users/me"
        case .fetchNearestPromise:
            return "/promises/today/next"
        case .fetchUpcomingPromise:
            return "/promises/upcoming"
        case .updatePreparationStatus(let promiseID):
            return "/promises/\(promiseID)/preparation"
        case .updateDepartureStatus(let promiseID):
            return "/promises/\(promiseID)/departure"
        case .updateArrivalStatus(let promiseID):
            return "/promises/\(promiseID)/arrival"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchLoginUser, .fetchNearestPromise, .fetchUpcomingPromise:
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
