//
//  EditPromiseServiceProtocol.swift
//  KkuMulKum
//
//  Created by YOUJIM on 8/26/24.
//

import Foundation

protocol EditPromiseServiceProtocol {
    /// 약속 수정
    func fetchPromiseAvailableMember(with promiseID: Int) async throws -> ResponseBodyDTO<ParticipateAvailabilityResponseModel>?
    func putPromiseInfo(with promiseID: Int, request: EditPromiseRequestModel) async throws -> ResponseBodyDTO<AddPromiseResponseModel>?
}
