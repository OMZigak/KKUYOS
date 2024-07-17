//
//  UtilService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/18/24.
//

import Foundation

import Moya

final class UtilService {
    let provider: MoyaProvider<UtilTargetType>
    
    init(provider: MoyaProvider<UtilTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])
    ) {
        self.provider = provider
    }
}
