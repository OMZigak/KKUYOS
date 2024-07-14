//
//  CreateMeetingViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import Foundation

enum MeetingNameState {
    case empty
    case valid
    case invalid
}

class CreateMeetingViewModel {
    let meetingName = ObservablePattern<String>("")
    let inviteCodeState = ObservablePattern<MeetingNameState>(.empty)
    let inviteCode = ObservablePattern<String>("")
    let isNextButtonEnabled = ObservablePattern<Bool>(false)
    let characterCount = ObservablePattern<String>("0/5")
    
    private let service: CreateMeetingServiceType
    
    init(service: CreateMeetingServiceType) {
        self.service = service
    }
    
    func validateName(_ name: String) {
        meetingName.value = name
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

