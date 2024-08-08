//
//  InviteCodeServiceProtocol.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import Foundation

protocol InviteCodeServiceProtocol {
    func joinMeeting(
        with request: RegisterMeetingsModel
    ) async throws -> ResponseBodyDTO<RegisterMeetingsResponseModel>?
}
