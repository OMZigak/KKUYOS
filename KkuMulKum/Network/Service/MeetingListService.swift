//
//  MeetingListService.swift
//  KkuMulKum
//
//  Created by 예삐 on 8/26/24.
//

import Foundation

import Moya

final class MeetingListService {
    let provider: MoyaProvider<MeetingListTargetType>
    
    init(provider: MoyaProvider<MeetingListTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func request<T: ResponseModelType>(
        with request: MeetingListTargetType
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

extension MeetingListService: MeetingListServiceProtocol {
    func fetchLoginUser() async throws -> ResponseBodyDTO<LoginUserModel>? {
        return try await request(with: .fetchLoginUser)
    }
    
    func fetchMeetingList() async throws -> ResponseBodyDTO<MeetingListModel>? {
        return try await request(with: .fetchMeetingList)
    }
}

final class MockMeetingListService: MeetingListServiceProtocol {
    func fetchLoginUser() async throws -> ResponseBodyDTO<LoginUserModel>? {
        let mockData = ResponseBodyDTO<LoginUserModel>(
            success: true,
            data: LoginUserModel(
                userID: 1,
                name: "꾸물리안",
                level: 4,
                promiseCount: 8,
                tardyCount: 2,
                tardySum: 72,
                profileImageURL: ""
            ),
            error: nil
        )
        return mockData
    }
    
    func fetchMeetingList() async throws -> ResponseBodyDTO<MeetingListModel>? {
        let mockData = ResponseBodyDTO<MeetingListModel>(
            success: true,
            data: MeetingListModel(
                count: 6,
                meetings: [
                    Meeting(meetingID: 1, name: "꾸물이들", memberCount: 14),
                    Meeting(meetingID: 2, name: "아요레디", memberCount: 28),
                    Meeting(meetingID: 3, name: "안드가자", memberCount: 26),
                    Meeting(meetingID: 4, name: "난이서버", memberCount: 30),
                    Meeting(meetingID: 5, name: "캔디팟", memberCount: 24),
                    Meeting(meetingID: 6, name: "열기팟", memberCount: 24)
                ]
            ),
            error: nil
        )
        return mockData
    }
}
