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
    ) async throws -> ResponseBodyDTO<EmptyModel>?
}

extension MeetingService: InviteCodeServiceType {
    func joinMeeting(with request: RegisterMeetingsModel) async throws -> ResponseBodyDTO<EmptyModel>? {
        return try await self.request(
            with: .joinMeeting(
                request: request
            )
        )
    }
}

final class MockInviteCodeService: InviteCodeServiceType {
    func joinMeeting(with request: RegisterMeetingsModel) -> ResponseBodyDTO<EmptyModel>? {
        let mockData = EmptyModel()
        
        return ResponseBodyDTO<EmptyModel>.init(
            success: true,
            data: mockData,
            error: nil
        )
    }
}
