//
//  CreateMeetingService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import Foundation

protocol CreateMeetingServiceType {
    func postMeetingName(with data: MakeMeetingsRequestModel) -> MakeMeetingsResponseModel?
}

final class MockCreateMeetingService: CreateMeetingServiceType {
    func postMeetingName(with data: MakeMeetingsRequestModel) -> MakeMeetingsResponseModel? {
        let mockData = MakeMeetingsResponseModel(invitationCode: "MICHIN")
        
        return mockData
    }
}

