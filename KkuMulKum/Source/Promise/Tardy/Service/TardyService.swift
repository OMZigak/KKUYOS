//
//  TardyService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/14/24.
//

import Foundation

protocol TardyServiceType {
    func getPromiseTardyInfo(with promiseID: Int) -> ResponseBodyDTO<TardyInfoModel>?
}

final class MockTardyService: TardyServiceType {
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
