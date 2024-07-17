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
        guard let baseURL = URL(string: "/api/v1/meetings") else {
            print("Error: Invalid Meeting BaseURL")
        }
        return baseURL
    }
    
    var path: String {
        switch self {
        case .createMeeting:
            return ""
        case .joinMeeting:
            return "/register"
        case .fetchMeetingList:
            return ""
        case let .fetchMeetingInfo(meetingID):
            return "/\(meetingID)"
        case let .fetchMeetingMember(meetingID):
            return "/\(meetingID)/members"
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
        }
    }
    
    var headers: [String : String]? {
        
    }
}

