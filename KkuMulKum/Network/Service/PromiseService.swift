//
//  PromiseService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/18/24.
//

import Foundation

import Moya

final class PromiseService {
    let provider: MoyaProvider<PromiseTargetType>
    
    init(provider: MoyaProvider<PromiseTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])
    ) {
        self.provider = provider
    }
}
