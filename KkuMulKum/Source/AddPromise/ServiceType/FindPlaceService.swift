//
//  FindPlaceService.swift
//  KkuMulKum
//
//  Created by 김진웅 on 7/15/24.
//

import Foundation

protocol FindPlaceServiceType {
    func fetchPlaceList(with input: String) -> ResponseBodyDTO<PlaceModel>
}

final class MockFindPlaceService: FindPlaceServiceType {
    func fetchPlaceList(with input: String) -> ResponseBodyDTO<PlaceModel> {
        let mockData: PlaceModel = PlaceModel(
            places: [
                Place(
                    location: "동국대학교 서울캠퍼스",
                    address: "서울 중구 필동3가 26-1",
                    roadAddress: "서울 중구 필동로1길 30",
                    x: 127.00090541880259,
                    y: 37.55808646250296
                ),
                Place(
                    location: "동국대학교 서울캠퍼스",
                    address: nil,
                    roadAddress: "서울 중구 필동로1길 30",
                    x: 127.00090541880259,
                    y: 37.55808646250296
                ),
                Place(
                    location: "동국대학교 서울캠퍼스",
                    address: "서울 중구 필동3가 26-1",
                    roadAddress: nil,
                    x: 127.00090541880259,
                    y: 37.55808646250296
                )
            ]
        )
        
        return ResponseBodyDTO(success: true, data: mockData, error: nil)
    }
}
