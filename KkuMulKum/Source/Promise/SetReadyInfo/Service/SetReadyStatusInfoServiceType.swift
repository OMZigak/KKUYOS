//
//  SetReadyStatusInfoServiceType.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/19/24.
//

import Foundation

protocol SetReadyStatusInfoServiceType {
    func updateMyPromiseReadyStatus(
        with promiseID: Int,
        requestModel: MyPromiseReadyInfoModel
    ) async throws -> ResponseBodyDTO<EmptyModel>?
}

extension PromiseService: SetReadyStatusInfoServiceType {
    func updateMyPromiseReadyStatus(
        with promiseID: Int,
        requestModel: MyPromiseReadyInfoModel
    ) async throws -> ResponseBodyDTO<EmptyModel>? {
        return try await request(
            with: .updateMyPromiseReadyStatus(
                promiseID: promiseID,
                requestModel: requestModel
            )
        )
    }
}

final class MockSetReadyStatusInfoService: SetReadyStatusInfoServiceType {
    func updateMyPromiseReadyStatus(
        with promiseID: Int,
        requestModel: MyPromiseReadyInfoModel
    ) async throws -> ResponseBodyDTO<EmptyModel>? {
        return ResponseBodyDTO(success: true, data: nil, error: nil)
    }
}
