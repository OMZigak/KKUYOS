//
//  PromiseService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/18/24.
//

import Foundation

import Moya

final class PromiseService {
    let provider: MoyaProvider<PromiseTargetType>
    
    init(provider: MoyaProvider<PromiseTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
    
    func request<T: ResponseModelType>(
        with request: PromiseTargetType
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

extension PromiseService: PromiseServiceProtocol {
    func fetchTardyInfo(with promiseID: Int) async throws -> ResponseBodyDTO<TardyInfoModel>? {
        return try await request(
            with: .fetchTardyInfo(
                promiseID: promiseID
            )
        )
    }
    
    func updatePromiseCompletion(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>? {
        return try await request(
            with: .updatePromiseCompletion(
                promiseID: promiseID
            )
        )
    }
    
    func fetchPromiseInfo(with promiseId: Int) async throws -> ResponseBodyDTO<PromiseInfoModel>? {
        return try await request(
            with: .fetchPromiseInfo(
                promiseID: promiseId
            )
        )
    }
    
    func updatePreparationStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>? {
        return try await request(
            with: .updatePreparationStatus(
                promiseID: promiseID
            )
        )
    }
    
    func updateDepartureStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>? {
        return try await request(
            with: .updateDepartureStatus(
                promiseID: promiseID
            )
        )
    }
    
    func updateArrivalStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>? {
        return try await request(
            with: .updateArrivalStatus(
                promiseID: promiseID
            )
        )
    }
    
    func fetchMyReadyStatus(with promiseID: Int) async throws -> ResponseBodyDTO<MyReadyStatusModel>? {
        return try await request(
            with: .fetchMyReadyStatus(
                promiseID: promiseID
            )
        )
    }
    
    func fetchPromiseParticipantList(with promiseID: Int) async throws -> ResponseBodyDTO<PromiseParticipantListModel>? {
        return try await request(
            with: .fetchPromiseParticipantList(
                promiseID: promiseID
            )
        )
    }
}

final class MockPromiseService: PromiseServiceProtocol {
    func fetchPromiseInfo(with promiseId: Int) async throws -> ResponseBodyDTO<PromiseInfoModel>? {
        let mockData = PromiseInfoModel(
            promiseID: 1,
            promiseName: "냐미",
            placeName: "우리집 앞",
            address: "경기도 용인시 수지구 대지로 72",
            roadAddress: "경기도 용인시 수지구 대지로 72",
            time: "2024년 7월 24일 오후 10시 30분",
            dressUpLevel: "LV 2. 냐미",
            penalty: "냐미"
        )
        
        return ResponseBodyDTO<PromiseInfoModel>.init(
            success: true,
            data: mockData,
            error: nil
        )
    }
    
    func fetchTardyInfo(with promiseID: Int) -> ResponseBodyDTO<TardyInfoModel>? {
        let mockData = TardyInfoModel(
            penalty: "티라미수 케익 릴스",
            isPastDue: true,
            lateComers: [Comer(
                participantId: 1,
                name: "유짐이",
                profileImageURL: ""
            ),
                         Comer(
                            participantId: 1,
                            name: "유짐이",
                            profileImageURL: ""
                         ),
                         Comer(
                            participantId: 1,
                            name: "유짐이",
                            profileImageURL: ""
                         ),
                         Comer(
                            participantId: 1,
                            name: "유짐이",
                            profileImageURL: ""
                         ),
                         Comer(
                            participantId: 1,
                            name: "유짐이",
                            profileImageURL: ""
                         )]
        )
        
        return ResponseBodyDTO<TardyInfoModel>.init(
            success: true,
            data: mockData,
            error: nil
        )
    }
    
    func updatePromiseCompletion(with promiseID: Int) -> ResponseBodyDTO<EmptyModel>? {
        let mockData = EmptyModel()
        
        return ResponseBodyDTO<EmptyModel>.init(
            success: true,
            data: mockData,
            error: nil
        )
    }
    
    func getPromiseTardyInfo(with promiseID: Int) -> ResponseBodyDTO<TardyInfoModel>? {
        let mockData = TardyInfoModel(
            penalty: "티라미수 케익 릴스",
            isPastDue: true,
            lateComers: [Comer(
                participantId: 1,
                name: "유짐이",
                profileImageURL: ""
            )]
        )
        
        return ResponseBodyDTO<TardyInfoModel>.init(
            success: true,
            data: mockData,
            error: nil
        )
    }
    
    func updatePromiseCompletion(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>? {
        let mockData = EmptyModel()
        
        return ResponseBodyDTO(
            success: true,
            data: mockData,
            error: nil
        )
    }
    
    func updatePreparationStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>? {
        let mockData = EmptyModel()
        
        return ResponseBodyDTO(
            success: true,
            data: mockData,
            error: nil
        )
    }
    
    func updateDepartureStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>? {
        let mockData = EmptyModel()
        
        return ResponseBodyDTO(
            success: true,
            data: mockData,
            error: nil
        )
    }
    
    func updateArrivalStatus(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>? {
        let mockData = EmptyModel()
        
        return ResponseBodyDTO(
            success: true,
            data: mockData,
            error: nil
        )
    }
    
    func fetchMyReadyStatus(with promiseID: Int) -> ResponseBodyDTO<MyReadyStatusModel>? {
        let mockData = MyReadyStatusModel(
            promiseTime: "",
            preparationTime: 300,
            travelTime: 230,
            preparationStartAt: "AM 11:00",
            departureAt: "PM 1:30",
            arrivalAt: "PM 2:00"
        )
        
        return ResponseBodyDTO<MyReadyStatusModel>.init(
            success: true,
            data: mockData,
            error: nil
        )
    }
    
    func fetchPromiseParticipantList(with promiseID: Int) -> ResponseBodyDTO<PromiseParticipantListModel>? {
        let mockData = PromiseParticipantListModel(
            participantCount: 3,
            participants: [
                Participant(
                    participantId: 1,
                    memberId: 3,
                    name: "안꾸물이",
                    state: "도착",
                    profileImageURL: nil
                ),
                Participant(
                    participantId: 2,
                    memberId: 4,
                    name: "꾸우우우웅물이",
                    state: "도착",
                    profileImageURL: nil
                ),
                Participant(
                    participantId: 3,
                    memberId: 5,
                    name: "꾸물이",
                    state: "이동중",
                    profileImageURL: nil
                )
            ]
        )
        
        return ResponseBodyDTO<PromiseParticipantListModel>.init(
            success: true,
            data: mockData,
            error: nil
        )
    }
}
