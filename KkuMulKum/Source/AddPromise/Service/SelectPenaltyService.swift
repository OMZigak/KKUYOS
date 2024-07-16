//
//  SelectPenaltyService.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/17/24.
//

import Foundation

protocol SelectPenaltyServiceType {
    func requestCreateNewPromise(with requestModel: AddPromiseModel) -> ResponseBodyDTO<EmptyModel>
}

final class MockSelectPenaltyService {}

extension MockSelectPenaltyService: SelectPenaltyServiceType {
    func requestCreateNewPromise(
        with requestModel: AddPromiseModel
    ) -> ResponseBodyDTO<EmptyModel> {
        return ResponseBodyDTO<EmptyModel>(success: true, data: nil, error: nil)
    }
}
