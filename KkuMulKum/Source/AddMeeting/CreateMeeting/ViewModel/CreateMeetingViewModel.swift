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
    
    
    // MARK: Property
    
    let meetingName = ObservablePattern<String>("")
    let inviteCode = ObservablePattern<String>("")
    let characterCount = ObservablePattern<String>("0/10")
    let inviteCodeState = ObservablePattern<MeetingNameState>(.empty)
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
    func validateName(_ name: String) {
        meetingName.value = name
        characterCount.value = String(name.count)
        
        switch name.count {
        case 0:
            inviteCodeState.value = .empty
        case 1...10:
            inviteCodeState.value = .valid
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
