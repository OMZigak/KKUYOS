//
//  InviteCodeService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import Foundation

protocol InviteCodeServiceType {
    func joinMeeting(
        with request: RegisterMeetingsModel
    ) async throws -> ResponseBodyDTO<RegisterMeetingsResponseModel>?
}

extension MeetingService: InviteCodeServiceType {
    func joinMeeting(
        with request: RegisterMeetingsModel
    ) async throws -> ResponseBodyDTO<RegisterMeetingsResponseModel>? {
        return try await self.request(
            with: .joinMeeting(
                request: request
            )
        )
    }
}

final class MockInviteCodeService: InviteCodeServiceType {
    func joinMeeting(with request: RegisterMeetingsModel) -> ResponseBodyDTO<RegisterMeetingsResponseModel>? {
        let mockData = RegisterMeetingsResponseModel(
            meetingID: 1
        )
        
        return ResponseBodyDTO<RegisterMeetingsResponseModel>.init(
            success: true,
            data: mockData,
            error: nil
        )
    }
}
