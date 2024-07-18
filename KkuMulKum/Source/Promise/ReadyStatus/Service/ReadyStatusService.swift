//
//  ReadyStatusService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/15/24.
//

import Foundation

protocol ReadyStatusServiceType {
    func fetchMyReadyStatus(with promiseID: Int) async throws -> ResponseBodyDTO<MyReadyStatusModel>?
    func fetchPromiseParticipantList(with promiseID: Int) async throws -> ResponseBodyDTO<PromiseParticipantListModel>?
}

extension PromiseService: ReadyStatusServiceType {
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

final class MockReadyStatusService: ReadyStatusServiceType {
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
