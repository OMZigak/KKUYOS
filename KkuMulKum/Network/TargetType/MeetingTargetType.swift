//
//  MeetingTargetType.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/17/24.
//

import Foundation

import Moya

enum MeetingTargetType {
    case createMeeting(request: MakeMeetingsRequestModel)
    case joinMeeting(request: RegisterMeetingsModel)
    case fetchMeetingList
    case fetchMeetingInfo(meetingID: Int)
    case fetchMeetingMember(meetingID: Int)
    case fetchMeetingPromiseList(meetingID: Int)
    case fetchParticipatedPromiseList(meetingID: Int, isParticipant: Bool)
    case exitMeeting(meetingID: Int)
}

extension MeetingTargetType: TargetType {
    var baseURL: URL {
        guard let url = Bundle.main.baseURL else {
            fatalError("Invalid BASE_URL in PrivacyInfo.plist")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .createMeeting:
            return "/api/v1/meetings"
        case .joinMeeting:
            return "/api/v1/meetings/register"
        case .fetchMeetingList:
            return "/api/v1/meetings"
        case  .fetchMeetingInfo(let meetingID):
            return "/api/v1/meetings/\(meetingID)"
        case .fetchMeetingMember(let meetingID):
            return "/api/v1/meetings/\(meetingID)/members"
        case .fetchMeetingPromiseList(let meetingID), .fetchParticipatedPromiseList(let meetingID, _):
            return "/api/v1/meetings/\(meetingID)/promises"
        case .exitMeeting(let meetingID):
            return "/api/v1/meetings/\(meetingID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createMeeting, .joinMeeting:
            return .post
        case .fetchMeetingList, .fetchMeetingInfo, .fetchMeetingMember, .fetchMeetingPromiseList, .fetchParticipatedPromiseList:
            return .get
        case .exitMeeting:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .createMeeting(let request):
            return .requestJSONEncodable(request)
        case .joinMeeting(let request):
            return .requestJSONEncodable(request)
        case .fetchMeetingList, .fetchMeetingInfo, .fetchMeetingMember, .exitMeeting:
            return .requestPlain
        case .fetchMeetingPromiseList:
            let parameters: [String: Any] = [
                "done": "false"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .fetchParticipatedPromiseList(_, let isParticipant):
            let parameters: [String: Any] = [
                "done": "false",
                "isParticipant": isParticipant
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
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
