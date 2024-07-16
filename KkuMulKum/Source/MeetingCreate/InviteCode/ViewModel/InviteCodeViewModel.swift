//
//  InviteCodeViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import Foundation

enum InviteCodeState {
    case empty
    case success
    case valid
    case invalid
}

class InviteCodeViewModel {
    
    
    // MARK: Property

    let inviteCode = ObservablePattern<String>("")
    let inviteCodeState = ObservablePattern<InviteCodeState>(.empty)
    let isNextButtonEnabled = ObservablePattern<Bool>(false)
    
    private let service: InviteCodeServiceType
    
    
    // MARK: Initialize

    init(service: InviteCodeServiceType) {
        self.service = service
    }
}


// MARK: - Extension

private extension InviteCodeViewModel {
    func validateCode(_ code: String) {
        inviteCode.value = code
        
        if code.isEmpty {
            inviteCodeState.value = .empty
            isNextButtonEnabled.value = false
        } else if code.count == 6 && code != "eeeeee" {
            inviteCodeState.value = .valid
            isNextButtonEnabled.value = true
        }
        // TODO: 서버 검증 성공했을 때 조건 변경
        else if code == "eeeeee" {
            inviteCodeState.value = .success
            isNextButtonEnabled.value = true
        } else {
            inviteCodeState.value = .invalid
            isNextButtonEnabled.value = false
        }
    }
}
