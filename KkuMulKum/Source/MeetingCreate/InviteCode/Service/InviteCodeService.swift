//
//  InviteCodeService.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/13/24.
//

import Foundation

protocol InviteCodeServiceType {
    func postMeetingInviteCode(with registerMeetingsModel: RegisterMeetingsModel) -> ResponseBodyDTO<EmptyModel>?
}

final class MockInviteCodeService: InviteCodeServiceType {
    func postMeetingInviteCode(with registerMeetingsModel: RegisterMeetingsModel) -> ResponseBodyDTO<EmptyModel>? {
        let mockData = EmptyModel()
        
        return ResponseBodyDTO<EmptyModel>.init(
            success: true,
            data: mockData,
            error: nil
        )
    }
    
    
}

