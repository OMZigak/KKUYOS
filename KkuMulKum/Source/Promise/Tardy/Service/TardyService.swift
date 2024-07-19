//
//  TardyService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/14/24.
//

import Foundation

protocol TardyServiceType {
    func fetchTardyInfo(with promiseID: Int) async throws -> ResponseBodyDTO<TardyInfoModel>?
    func updatePromiseCompletion(with promiseID: Int) async throws -> ResponseBodyDTO<EmptyModel>?
}

extension PromiseService: TardyServiceType {
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
}

final class MockTardyService: TardyServiceType {
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
}
