//
//  MeetingService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/18/24.
//

import Foundation

import Moya

final class MeetingService {
    let provider: MoyaProvider<MeetingTargetType>
    
    init(provider: MoyaProvider<MeetingTargetType> = MoyaProvider(plugins: [MoyaLoggingPlugin()])) {
        self.provider = provider
    }
}
