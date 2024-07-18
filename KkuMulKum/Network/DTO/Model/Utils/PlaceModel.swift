//
//  PlaceModel.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/8/24.
//

import Foundation

/// 네이버 지역 검색 API (Response)
struct PlaceModel: ResponseModelType {
    let places: [Place]
    
    enum CodingKeys: String, CodingKey {
        case places = "locations"
    }
}

struct Place: Codable {
    let location: String
    let address: String?
    let roadAddress: String?
    let x: Double
    let y: Double
}
