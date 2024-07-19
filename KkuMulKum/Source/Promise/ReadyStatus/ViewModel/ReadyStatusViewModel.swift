//
//  ReadyStatusViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/15/24.
//

import Foundation

class ReadyStatusViewModel {
    // 서버 통신을 위한 promiseID
    let promiseID: Int
    
    /// 단순히 값을 전달만 하기 위한 코드
    /// 준비 현황 입력하기 버튼을 눌렀을 때
    /// promiseName.value.isEmpty로 분기처리 1차 (실패 시 버튼 입력 안되게)
    /// bind를 사용하라는 말이 아님
    let promiseName = ObservablePattern<String>("")
    
    // 준비 정보가 입력되었는지 여부
//    let isReadyInfoEntered = ObservablePattern<Bool>(false)
    
    /// 나의 준비현황이 담긴 정보
    /// 설령 데이터가 없다하더라도 약속 시간은 담겨있음.
    let myReadyStatus = ObservablePattern<MyReadyStatusModel?>(nil)
    
    // 현재 준비 상태에 대한 버튼 처리
    let myReadyProgressStatus = ObservablePattern<ReadyProgressStatus>(.none)
    
    // 꾸물거림 여부
    let isLate = ObservablePattern<Bool>(false)
    
    // 우리들의 준비 현황 스택 뷰에 들어갈 정보들
    let participantInfos = ObservablePattern<[Participant]>([])
    
    // 서비스 객체
    private let readyStatusService: ReadyStatusServiceType
    
    // 현재 시간 받아오기 위한 dateFormatter 구헌
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "a hh:mm"
        $0.amSymbol = "AM"
        $0.pmSymbol = "PM"
    }
    
    // 초기화
    init(readyStatusService: ReadyStatusServiceType, promiseID: Int) {
        self.readyStatusService = readyStatusService
        self.promiseID = promiseID
    }
    
    // 우리들의 준비 현황 변동되었을 때
    func participantInfosDidChanged(infos: [Participant]) {
        participantInfos.value = infos
    }
    
    // 준비 현황 버튼 클릭했을 때
    func updateReadyStatusTime() -> String {
        let currentTimeString = dateFormatter.string(from: Date())
        
        return currentTimeString
    }
}

extension ReadyStatusViewModel {
    func fetchMyReadyStatus() {
        Task {
            do {
                let responseBody = try await readyStatusService.fetchMyReadyStatus(with: promiseID)
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
                myReadyStatus.value = responseBody?.data
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    func fetchPromiseParticipantList() {
        Task {
            do {
                let responseBody = try await readyStatusService.fetchPromiseParticipantList(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true,
                      let participants = responseBody?.data?.participants
                else {
                    participantInfos.value = []
                    return
                }
                participantInfos.value = participants
            }
        }
    }
}
