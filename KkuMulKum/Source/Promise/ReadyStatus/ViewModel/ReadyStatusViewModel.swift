//
//  ReadyStatusViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/15/24.
//

import Foundation

class ReadyStatusViewModel {
    // 서비스 객체
    var readyStatusService: MockReadyStatusService
    
    // 준비 정보가 입력되었는지 여부
    var isReadyInfoEntered = ObservablePattern<Bool>(false)
    
    // 현재 준비 상태
    var myReadyStatus = ObservablePattern<ReadyStatus>(.none)
    
    // 우리들의 준비 현황 스택 뷰에 들어갈 정보들
    var participantInfos = ObservablePattern<[Participant]>([])
    
    // 현재 시간 받아오기 위한 dateFormatter 구헌
    private let dateFormatter = DateFormatter().then {
        $0.dateFormat = "a hh:mm"
        $0.amSymbol = "AM"
        $0.pmSymbol = "PM"
    }
    
    // 초기화
    init(readyStatusService: MockReadyStatusService) {
        self.readyStatusService = readyStatusService
        
        participantInfos.value = readyStatusService.getParticipantList(with: 1).participants 
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
