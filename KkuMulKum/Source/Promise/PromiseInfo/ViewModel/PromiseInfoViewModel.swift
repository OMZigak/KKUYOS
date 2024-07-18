//
//  PromiseInfoViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/17/24.
//

import Foundation

class PromiseInfoViewModel {
    
    let promiseID: Int
    
    let participantsInfo = ObservablePattern<[Participant]?>(nil)
    let promiseInfo = ObservablePattern<PromiseInfoModel?>(nil)
    
    /// 굳이 서비스 하나 더 만들 필요 없을 것 같아서 같은 API 사용하는 ReadyStatusServiceType 가져옴
    private let promiseInfoService: ReadyStatusServiceType
    
    init(promiseID: Int, promiseInfoService: ReadyStatusServiceType) {
        self.promiseID = promiseID
        self.promiseInfoService = promiseInfoService
    }
}

extension PromiseInfoViewModel {
    func fetchPromiseParticipantList() {
        Task {
            do {
                
                let responseBody = try await promiseInfoService.fetchPromiseParticipantList(with: promiseID)
                
                guard let success = responseBody?.success, success == true else {
                    return
                }
                
                participantsInfo.value = responseBody?.data?.participants
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}
