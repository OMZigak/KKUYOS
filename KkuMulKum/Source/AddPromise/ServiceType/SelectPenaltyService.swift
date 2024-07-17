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
    ) -> ResponseBodyDTO<AddPromiseResponseModel>
}

final class MockSelectPenaltyService: SelectPenaltyServiceType {
    func requestAddingNewPromise(
        with requestModel: AddPromiseRequestModel,
        meetingID: Int
    ) -> ResponseBodyDTO<AddPromiseResponseModel> {
        return ResponseBodyDTO<AddPromiseResponseModel>(success: true, data: nil, error: nil)
    }
}
