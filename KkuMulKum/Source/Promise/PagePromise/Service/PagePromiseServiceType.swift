//
//  PagePromiseServiceType.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/19/24.
//

import Foundation

protocol PagePromiseServiceType {
    func fetchPromiseInfo(with promiseId: Int) async throws -> ResponseBodyDTO<PromiseInfoModel>?
}

extension PromiseService: PagePromiseServiceType {
    func fetchPromiseInfo(with promiseId: Int) async throws -> ResponseBodyDTO<PromiseInfoModel>? {
        return try await request(
            with: .fetchPromiseInfo(
                promiseID: promiseId
            )
        )
    }
}
