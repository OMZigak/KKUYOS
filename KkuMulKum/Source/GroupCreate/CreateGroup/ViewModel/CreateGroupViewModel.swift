//
//  CreateGroupViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import Foundation

enum GroupNameState {
    case empty
    case valid
    case invalid
}

class CreateGroupViewModel {
    let groupName = ObservablePattern<String>("")
    let inviteCodeState = ObservablePattern<GroupNameState>(.empty)
    let inviteCode = ObservablePattern<String>("")
    let isNextButtonEnabled = ObservablePattern<Bool>(false)
    let characterCount = ObservablePattern<String>("0/5")
    
    func validateName(_ name: String) {
        groupName.value = name
        characterCount.value = "\(name.count)/10"
        
        if name.isEmpty {
            inviteCodeState.value = .empty
            isNextButtonEnabled.value = false
        } else if name.count > 10 {
            inviteCodeState.value = .invalid
            isNextButtonEnabled.value = false
        } else {
            inviteCodeState.value = .valid
            isNextButtonEnabled.value = true
        }
    }
}

