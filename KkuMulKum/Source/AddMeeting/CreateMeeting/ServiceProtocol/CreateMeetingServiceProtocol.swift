//
//  CreateMeetingServiceProtocol.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import Foundation

import Moya

protocol CreateMeetingServiceProtocol {
    func createMeeting(
        request: MakeMeetingsRequestModel
    ) async throws -> ResponseBodyDTO<MakeMeetingsResponseModel>?
}
