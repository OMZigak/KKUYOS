//
//  PromiseTargetType.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/17/24.
//

import Foundation

import Moya

enum PromiseTargetType {
    case fetchTodayNextPromise
    case fetchUpcomingPromiseList
    case updatePreparationStatus(promiseID: Int)
    case updateDepartureStatus(promiseID: Int)
    case updateArrivalStatus(promiseID: Int)
    case fetchmeetingPromiseList(meetingID: Int, request: PromiseInfoModel)
    case addPromise(meetingID: Int, request: AddPromiseRequestModel)
    case fetchPromiseInfo(promiseID: Int)
    case fetchMyReadyStatus(promiseID: Int)
    case fetchPromiseParticipantList(promiseID: Int)
    case updateMyPromiseReadyStatus(promiseID: Int)
    case fetchTardyInfo(promiseID: Int)
    case updatePromiseCompletion(promiseID: Int)
}

extension PromiseTargetType: TargetType {
    var baseURL: URL {
        guard let baseURL = URL(string: "/api/v1/promises") else {
            fatalError("Error: Invalid Meeting BaseURL")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .fetchTodayNextPromise:
            return "/today/next"
        case .fetchUpcomingPromiseList:
            return "/upcoming"
        case .updatePreparationStatus(let promiseID):
            return "/\(promiseID)/preparation"
        case .updateDepartureStatus(let promiseID):
            return "/\(promiseID)/departure"
        case .updateArrivalStatus(let promiseID):
            return "/\(promiseID)/arrival"
        case .fetchmeetingPromiseList(let meetingID, _):
            return "/\(meetingID)/promises"
        case .addPromise(let meetingID, _):
            return "/\(meetingID)/promises"
        case .fetchPromiseInfo(let promiseID):
            return "/\(promiseID)"
        case .fetchMyReadyStatus(let promiseID):
            return "/\(promiseID)/status"
        case .fetchPromiseParticipantList(let promiseID):
            return "/\(promiseID)/participants"
        case .updateMyPromiseReadyStatus(let promiseID):
            return "/\(promiseID)/times"
        case .fetchTardyInfo(let promiseID):
            return "/\(promiseID)/tardy"
        case .updatePromiseCompletion(let promiseID):
            return "/\(promiseID)/completion"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchTodayNextPromise, .fetchUpcomingPromiseList, .fetchmeetingPromiseList, 
                .fetchPromiseInfo, .fetchMyReadyStatus, .fetchPromiseParticipantList,
                .fetchTardyInfo:
            return .get
        case .addPromise:
            return .post
        case .updateDepartureStatus, .updatePreparationStatus, .updateArrivalStatus,
                .updateMyPromiseReadyStatus, .updatePromiseCompletion:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .fetchTodayNextPromise, .fetchUpcomingPromiseList, .updatePreparationStatus,
                .updateDepartureStatus, .updateArrivalStatus, .fetchPromiseInfo,
                .fetchMyReadyStatus, .fetchPromiseParticipantList, .updateMyPromiseReadyStatus,
                .fetchTardyInfo, .updatePromiseCompletion:
            return .requestPlain
        case .fetchmeetingPromiseList(_, let request):
            return .requestJSONEncodable(request)
        case .addPromise(_, let request):
            return .requestJSONEncodable(request)
        }
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

