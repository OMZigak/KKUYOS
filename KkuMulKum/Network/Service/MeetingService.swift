//
//  MeetingService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/18/24.
//

import Foundation

import Moya

final class MeetingService {
    let provider: MoyaProvider<MeetingTargetType>
    
    init(provider: MoyaProvider<MeetingTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func request<T: ResponseModelType>(
        with request: MeetingTargetType
    ) async throws -> ResponseBodyDTO<T>? {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(request) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedData = try JSONDecoder().decode(
                            ResponseBodyDTO<T>.self,
                            from: response.data
                        )
                        continuation.resume(returning: decodedData)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension MeetingService: CreateMeetingServiceProtocol {
    func createMeeting(
        request: MakeMeetingsRequestModel
    ) async throws -> ResponseBodyDTO<MakeMeetingsResponseModel>? {
        return try await self.request(with: .createMeeting(request: request))
    }
}

extension MeetingService: InviteCodeServiceProtocol {
    func joinMeeting(
        with request: RegisterMeetingsModel
    ) async throws -> ResponseBodyDTO<RegisterMeetingsResponseModel>? {
        return try await self.request(with: .joinMeeting(request: request))
    }
}

final class MockInviteCodeService: InviteCodeServiceProtocol {
    func joinMeeting(with request: RegisterMeetingsModel) -> ResponseBodyDTO<RegisterMeetingsResponseModel>? {
        let mockData = RegisterMeetingsResponseModel(
            meetingID: 1
        )
        
        return ResponseBodyDTO<RegisterMeetingsResponseModel>.init(success: true, data: mockData, error: nil)
    }
}
