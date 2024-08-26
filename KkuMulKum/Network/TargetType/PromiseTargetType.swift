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
    case fetchMeetingMemberExcludeMe(meetingID: Int)
    case fetchMeetingPromiseList(meetingID: Int)
    case addPromise(meetingID: Int, request: AddPromiseRequestModel)
    case fetchPromiseInfo(promiseID: Int)
    case fetchMyReadyStatus(promiseID: Int)
    case fetchPromiseParticipantList(promiseID: Int)
    case updateMyPromiseReadyStatus(
        promiseID: Int,
        requestModel: MyPromiseReadyInfoModel
    )
    case fetchTardyInfo(promiseID: Int)
    case updatePromiseCompletion(promiseID: Int)
    case fetchPromiseAvailableMember(promiseID: Int)
    case putPromiseInfo(promiseID: Int, request: EditPromiseRequestModel)
    case deletePromise(promiseID: Int)
    case exitPromise(promiseID: Int)
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
        case .fetchMeetingMemberExcludeMe(let meetingID):
            return "/api/v1/meetings/\(meetingID)/members"
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
        case .updateMyPromiseReadyStatus(let promiseID, _):
            return "/api/v1/promises/\(promiseID)/times"
        case .fetchTardyInfo(let promiseID):
            return "/api/v1/promises/\(promiseID)/tardy"
        case .updatePromiseCompletion(let promiseID):
            return "/api/v1/promises/\(promiseID)/completion"
        case .fetchPromiseAvailableMember(let promiseID):
            return "/api/v1/promises/\(promiseID)/members"
        case .putPromiseInfo(promiseID: let promiseID):
            return "/api/v1/promises/\(promiseID)"
        case .deletePromise(promiseID: let promiseID):
            return "/api/v1/promises/\(promiseID)"
        case .exitPromise(promiseID: let promiseID):
            return "/api/v1/promises/\(promiseID)/leave"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchTodayNextPromise, .fetchUpcomingPromiseList, .fetchMeetingMemberExcludeMe,
                .fetchMeetingPromiseList, .fetchPromiseInfo, .fetchMyReadyStatus,
                .fetchPromiseParticipantList, .fetchTardyInfo, .fetchPromiseAvailableMember:
            return .get
        case .addPromise:
            return .post
        case .updateDepartureStatus, .updatePreparationStatus, .updateArrivalStatus,
                .updateMyPromiseReadyStatus, .updatePromiseCompletion:
            return .patch
        case .putPromiseInfo:
            return .put
        case .deletePromise, .exitPromise:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .fetchTodayNextPromise, .fetchUpcomingPromiseList, .updatePreparationStatus,
                .updateDepartureStatus, .updateArrivalStatus, .fetchPromiseInfo,
                .fetchMyReadyStatus, .fetchPromiseParticipantList,
                .fetchTardyInfo, .updatePromiseCompletion, .fetchMeetingPromiseList, .fetchPromiseAvailableMember, .deletePromise, .exitPromise:
            return .requestPlain
        case .updateMyPromiseReadyStatus(_, let request):
            return .requestJSONEncodable(request)
        case .addPromise(_, let request):
            return .requestJSONEncodable(request)
        case .putPromiseInfo(_, let request):
            return .requestJSONEncodable(request)
        case .fetchMeetingMemberExcludeMe:
            return .requestParameters(
                parameters: ["exclude": "me"],
                encoding: URLEncoding.queryString
            )
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

