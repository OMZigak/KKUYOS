//
//  InviteCodeService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import Foundation

protocol InviteCodeServiceType {
    func postMeetingInviteCode(with registerMeetingsModel: RegisterMeetingsModel) -> EmptyModel
}

final class MockInviteCodeService: InviteCodeServiceType {
    func postMeetingInviteCode(with registerMeetingsModel: RegisterMeetingsModel) -> EmptyModel {
        let mockData = EmptyModel()
        
        return mockData
    }
    
    
}

