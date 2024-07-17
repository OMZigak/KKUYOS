//
//  PlaceModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/8/24.
//

import Foundation

struct PlaceModel: ResponseModelType {
    let places: [Place]
}

struct Place: Codable {
    let location: String
    let address: String?
    let roadAddress: String?
    let x: Double
    let y: Double
}
