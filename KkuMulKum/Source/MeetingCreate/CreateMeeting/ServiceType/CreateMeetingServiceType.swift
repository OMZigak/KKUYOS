//
//  MeetingService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import Foundation

import Moya

protocol CreateMeetingServiceType {
    func createMeeting(
        request: MakeMeetingsRequestModel
    ) async throws -> ResponseBodyDTO<MakeMeetingsResponseModel>?
}

extension MeetingService: CreateMeetingServiceType {
    func createMeeting(
        request: MakeMeetingsRequestModel
    ) async throws -> ResponseBodyDTO<MakeMeetingsResponseModel>? {
        return try await self.request(
            with: .createMeeting(
                request: request
            )
        )
    }
}
