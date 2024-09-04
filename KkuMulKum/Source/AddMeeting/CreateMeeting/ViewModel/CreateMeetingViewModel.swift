//
//  CreateMeetingViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/12/24.
//

import Foundation

enum NameState {
    case empty
    case valid
    case invalid
}

class CreateMeetingViewModel {
    
    
    // MARK: Property
    
    let meetingName = ObservablePattern<String>("")
    let inviteCode = ObservablePattern<String>("")
    let characterCount = ObservablePattern<String>("0/10")
    let inviteCodeState = ObservablePattern<NameState>(.empty)
    let createMeetingService: CreateMeetingServiceProtocol
    
    var createMeetingResponse = ObservablePattern<MakeMeetingsResponseModel?>(nil)
    
    private (set) var meetingID: Int = 0
    
    
    // MARK: Initialize

    init(createMeetingService: CreateMeetingServiceProtocol) {
        self.createMeetingService = createMeetingService
    }
}


// MARK: - Extension

extension CreateMeetingViewModel {
    func validateName() {
        let regex = "^[가-힣a-zA-Z0-9 ]{1,10}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        
        switch meetingName.value.count {
        case 0:
            inviteCodeState.value = .empty
        case 1...10:
            inviteCodeState.value = predicate.evaluate(with: meetingName.value) ? .valid : .invalid
        default:
            inviteCodeState.value = .invalid
        }
    }
    
    /// 모임 생성 네트워크 통신
    func createMeeting(name: String) {
        Task {
            do {
                let request = MakeMeetingsRequestModel(name: name)
                
                createMeetingResponse.value = try await createMeetingService.createMeeting(request: request)?.data
                
                guard let code = self.createMeetingResponse.value?.invitationCode else {
                    return
                }
                guard let meetingID = self.createMeetingResponse.value?.meetingID else {
                    return
                }
                
                inviteCode.value = code
                self.meetingID = meetingID
            }
            catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}
