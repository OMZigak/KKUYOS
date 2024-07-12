//
//  InviteCodeViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import Foundation

enum InviteCodeState {
    case empty
    case selected
    case valid
    case invalid
}

class InviteCodeViewModel {
    let inviteCode = ObservablePattern<String>("")
    let inviteCodeState = ObservablePattern<InviteCodeState>(.empty)
    let codeErrorMessage = ObservablePattern<String?>(nil)
    let isNextButtonEnabled = ObservablePattern<Bool>(false)
    
    private let codeRegex = "{1,5}$"
    
    func validateCode(_ code: String) {
        inviteCode.value = code
        
        if code.isEmpty {
            inviteCodeState.value = .empty
            codeErrorMessage.value = nil
            isNextButtonEnabled.value = false
        } else if code.range(of: codeRegex, options: .regularExpression) != nil {
            inviteCodeState.value = .valid
            codeErrorMessage.value = nil
            isNextButtonEnabled.value = true
        } else {
            inviteCodeState.value = .invalid
            codeErrorMessage.value = "한글, 영문, 숫자만을 사용해 총 5자 이내로 입력해주세요."
            isNextButtonEnabled.value = false
        }
    }
}
