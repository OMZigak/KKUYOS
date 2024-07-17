//
//  HomeService.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/16/24.
//

import Foundation

import Moya

final class HomeService {
    let provider: MoyaProvider<HomeTargetType>
    
    init(provider: MoyaProvider<HomeTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
}
