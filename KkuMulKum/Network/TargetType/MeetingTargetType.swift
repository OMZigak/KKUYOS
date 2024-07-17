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
}

extension MeetingTargetType: TargetType {
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
        case .createMeeting:
            return "/api/v1/meetings"
        case .joinMeeting:
            return "/api/v1/meetings/register"
        case .fetchMeetingList:
            return "/api/v1/meetings"
        case  .fetchMeetingInfo(meetingID: let meetingID):
            return "/api/v1/meetings/\(meetingID)"
        case .fetchMeetingMember(meetingID: let meetingID):
            return "/api/v1/meetings/\(meetingID)/members"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createMeeting, .joinMeeting:
            return .post
        case .fetchMeetingList, .fetchMeetingInfo, .fetchMeetingMember:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .createMeeting(request: let request):
            return .requestJSONEncodable(request)
        case .joinMeeting(request: let request):
            return .requestJSONEncodable(request)
        case .fetchMeetingList, .fetchMeetingInfo, .fetchMeetingMember:
            return .requestPlain
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
