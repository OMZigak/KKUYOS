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

    let meetingID = ObservablePattern<Int?>(nil)
    let inviteCode = ObservablePattern<String>("")
    let errorDescription = ObservablePattern<String>("")
    let inviteCodeState = ObservablePattern<InviteCodeState>(.empty)
    let isNextButtonEnabled = ObservablePattern<Bool>(false)
    
    private let service: InviteCodeServiceProtocol
    
    // MARK: Initialize

    init(service: InviteCodeServiceProtocol) {
        self.service = service
    }
}


// MARK: - Extension

extension InviteCodeViewModel {
    func validateCode(_ code: String) {
        inviteCode.value = code
        
        if code.isEmpty {
            inviteCodeState.value = .empty
            isNextButtonEnabled.value = false
        } else if code.count == 6 {
            inviteCodeState.value = .valid
            isNextButtonEnabled.value = true
        } else {
            inviteCodeState.value = .invalid
            isNextButtonEnabled.value = false
        }
    }
    
    func joinMeeting(inviteCode: String) {
        Task {
            do {
                let request = RegisterMeetingsModel(invitationCode: inviteCode)
                let responseBody = try await service.joinMeeting(with: request)
                
                /// 네트워크 자체가 성공인가..
                guard let success = responseBody?.success,
                      success == true
                else {
                    handleError(errorResponse: responseBody?.error)
                    return
                }
                
                /// 성공인 경우
                meetingID.value = responseBody?.data?.meetingID
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}

private extension InviteCodeViewModel {
    func handleError(errorResponse: ErrorResponse?) {
        guard let error = errorResponse else {
            errorDescription.value = "알 수 없는 에러입니다."
            return
        }
        
        errorDescription.value = error.message
    }
}
