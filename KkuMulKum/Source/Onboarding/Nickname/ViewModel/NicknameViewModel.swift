//
//  NicknameViewModel.swift
//  KkuMulKum
//
//  Created by 이지훈 on 7/10/24.
//

import Foundation

enum NicknameState {
    case empty
    case valid
    case invalid
}

class NicknameViewModel {
    let nickname = ObservablePattern<String>("")
    let nicknameState = ObservablePattern<NicknameState>(.empty)
    let errorMessage = ObservablePattern<String?>("")
    let isNextButtonEnabled = ObservablePattern<Bool>(false)
    let characterCount = ObservablePattern<String>("0/5")
    
    private let nicknameRegex = "^[가-힣a-zA-Z0-9]{1,5}$"
    
    func validateNickname(_ name: String) {
        nickname.value = name
        characterCount.value = "\(name.count)/5"
        
        if name.isEmpty {
            nicknameState.value = .empty
            errorMessage.value = nil
            isNextButtonEnabled.value = false
        } else if name.range(of: nicknameRegex, options: .regularExpression) != nil {
            nicknameState.value = .valid
            errorMessage.value = nil
            isNextButtonEnabled.value = true
        } else {
            nicknameState.value = .invalid
            errorMessage.value = "한글, 영문, 숫자만을 사용해 총 5자 이내로 입력해주세요."
            isNextButtonEnabled.value = false
        }
    }
}
