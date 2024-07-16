//
//  PromiseInfoService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/17/24.
//

import Foundation

protocol PromiseInfoServiceType {
    func getPromiseInfo(with promiseId: Int) -> PromiseInfoModel?
}

class PromiseInfoService: PromiseInfoServiceType {
    func getPromiseInfo(with promiseId: Int) -> PromiseInfoModel? {
        let mockData = PromiseInfoModel(
            promiseID: 1,
            placeName: "홍대입구",
            address: "대현동 90-35",
            roadAddress: "서울 서대문구 이화여대1길 28",
            time: "7월 19일 15:00",
            dressUpLevel: "Lv2. 꾸안꾸",
            penalty: "맛있는 카페 쏘기"
        )
        
        return mockData
    }
}
