//
//  SelectPenaltyService.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/17/24.
//

import Foundation
import Moya

protocol SelectPenaltyServiceType {
    func requestAddingNewPromise(
        with requestModel: AddPromiseRequestModel,
        meetingID: Int
    ) async throws -> ResponseBodyDTO<AddPromiseResponseModel>?
}

extension PromiseService: SelectPenaltyServiceType {
    func requestAddingNewPromise(
        with requestModel: AddPromiseRequestModel,
        meetingID: Int
    ) async throws -> ResponseBodyDTO<AddPromiseResponseModel>? {
        return try await request(
            with: .addPromise(
                meetingID: meetingID,
                request: requestModel
            )
        )
    }
}

final class MockSelectPenaltyService: SelectPenaltyServiceType {
    func requestAddingNewPromise(
        with requestModel: AddPromiseRequestModel,
        meetingID: Int
    ) async throws -> ResponseBodyDTO<AddPromiseResponseModel>? {
        let mockData = AddPromiseResponseModel(
            promiseID: 1,
            placeName: "홍대입구",
            address: "주소",
            roadAddress: "도로명주소",
            time: "",
            dressUpLevel: "",
            penalty: ""
        )
        return ResponseBodyDTO<AddPromiseResponseModel>(success: true, data: mockData, error: nil)
    }
}
