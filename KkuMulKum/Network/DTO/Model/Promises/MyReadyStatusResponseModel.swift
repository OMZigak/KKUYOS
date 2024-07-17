//
//  MyReadyStatusResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//

import Foundation


// MARK: 내 준비 현황

struct MyReadyStatusModel: ResponseModelType {
    let promiseTime: String
    let preparationTime: Int
    let travelTime: Int
    let preparationStartAt: String
    let departureAt: String
    let arrivalAt: String
}
