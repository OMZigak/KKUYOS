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
    case fetchMeetingPromiseList(meetingID: Int)
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
        guard let privacyInfo = Bundle.main.privacyInfo,
              let urlString = privacyInfo["BASE_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("Invalid BASE_URL in PrivacyInfo.plist")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .fetchTodayNextPromise:
            return "/api/v1/promises/today/next"
        case .fetchUpcomingPromiseList:
            return "/api/v1/promises/upcoming"
        case .updatePreparationStatus(let promiseID):
            return "/api/v1/promises/\(promiseID)/preparation"
        case .updateDepartureStatus(let promiseID):
            return "/api/v1/promises/\(promiseID)/departure"
        case .updateArrivalStatus(let promiseID):
            return "/api/v1/promises/\(promiseID)/arrival"
        case .fetchMeetingPromiseList(let meetingID):
            return "/api/v1/meetings/\(meetingID)/promises"
        case .addPromise(let meetingID, _):
            return "/api/v1/meetings/\(meetingID)/promises"
        case .fetchPromiseInfo(let promiseID):
            return "/api/v1/promises/\(promiseID)"
        case .fetchMyReadyStatus(let promiseID):
            return "/api/v1/promises/\(promiseID)/status"
        case .fetchPromiseParticipantList(let promiseID):
            return "/api/v1/promises/\(promiseID)/participants"
        case .updateMyPromiseReadyStatus(let promiseID):
            return "/api/v1/promises/\(promiseID)/times"
        case .fetchTardyInfo(let promiseID):
            return "/api/v1/promises/\(promiseID)/tardy"
        case .updatePromiseCompletion(let promiseID):
            return "/api/v1/promises/\(promiseID)/completion"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchTodayNextPromise, .fetchUpcomingPromiseList, .fetchMeetingPromiseList, 
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
                .fetchTardyInfo, .updatePromiseCompletion, .fetchMeetingPromiseList:
            return .requestPlain
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

