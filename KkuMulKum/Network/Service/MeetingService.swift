//
//  MeetingService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/18/24.
//

import Foundation

import Moya
import RxSwift
import RxMoya

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


// MARK: - MeetingInfoServiceProtocol

extension MeetingService: MeetingInfoServiceProtocol {
    func fetchMeetingInfo(with meetingID: Int) async throws -> ResponseBodyDTO<MeetingInfoModel>? {
        return try await request(with: .fetchMeetingInfo(meetingID: meetingID))
    }
    
    func fetchMeetingMemberList(with meetingID: Int) async throws -> ResponseBodyDTO<MeetingMembersModel>? {
        return try await request(with: .fetchMeetingMember(meetingID: meetingID))
    }
    
    func fetchMeetingPromiseList(with meetingID: Int) -> Single<ResponseBodyDTO<MeetingPromisesModel>> {
        return provider.rx.request(.fetchMeetingPromiseList(meetingID: meetingID))
            .map(ResponseBodyDTO<MeetingPromisesModel>.self)
            .catch { error in
                print(">>> 에러 발생: \(error.localizedDescription) : \(#function) : \(Self.self)")
                return .error(error)
            }
    }
    
    func fetchParticipatedPromiseList(
        with meetingID: Int,
        isParticipant: Bool
    ) -> Single<ResponseBodyDTO<MeetingPromisesModel>> {
        return provider.rx.request(.fetchParticipatedPromiseList(meetingID: meetingID, isParticipant: isParticipant))
            .map(ResponseBodyDTO<MeetingPromisesModel>.self)
            .catch { error in
                print(">>> 에러 발생: \(error.localizedDescription) : \(#function) : \(Self.self)")
                return .error(error)
            }
    }
    
    func exitMeeting(with meetingID: Int) -> Single<ResponseBodyDTO<EmptyModel>> {
        return provider.rx.request(.exitMeeting(meetingID: meetingID))
            .filterSuccessfulStatusCodes()
            .map(ResponseBodyDTO<EmptyModel>.self)
            .catch { error in
                print("에러 발생: \(error.localizedDescription)")
                throw error
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
