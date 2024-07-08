//
//  MyReadyStatusResponseModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/8/24.
//


// MARK: 내 준비 현황

import Foundation

struct MyReadyStatusModel: ResponseModelType {
    let preparationTime, travelTime: Int
    let preparationStartAt, departureAt, arrivalAt: String
}
