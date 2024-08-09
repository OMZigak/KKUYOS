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
    
    private let service: InviteCodeServiceProtocol
    
    
    // MARK: - LifeCycle

    init(service: InviteCodeServiceProtocol) {
        self.service = service
    }
}


// MARK: - Extension

extension InviteCodeViewModel {
    func updateInviteCode(_ code: String) {
        self.inviteCode.value = code
    }
    
    func validateInviteCode() {
        if inviteCode.value.isEmpty {
            inviteCodeState.value = .empty
        } else if inviteCode.value.count == 6 {
            inviteCodeState.value = .valid
        } else {
            inviteCodeState.value = .invalid
        }
    }
    
    func joinMeeting() {
        Task {
            do {
                let request = RegisterMeetingsModel(invitationCode: inviteCode.value)
                let responseBody = try await service.joinMeeting(with: request)
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    handleError(errorResponse: responseBody?.error)
                    return
                }
                
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
