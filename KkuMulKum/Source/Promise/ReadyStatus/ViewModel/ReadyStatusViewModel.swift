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
    
    /// 나의 준비현황이 담긴 정보
    /// 설령 데이터가 없다하더라도 약속 시간은 담겨있음.
    let myReadyStatus = ObservablePattern<MyReadyStatusModel?>(nil)
    
    // 준비 시작 시간
    var readyStartTime = ObservablePattern<String>("")
    
    // 준비 소요 시간
    var readyTime = ObservablePattern<String>("")
    
    // 이동 시작 시간
    var moveStartTime = ObservablePattern<String>("")
    
    // 이동 소요 시간
    var moveTime = ObservablePattern<String>("")
    
    // 현재 준비 상태에 대한 버튼 처리
    let myReadyProgressStatus = ObservablePattern<ReadyProgressStatus>(.none)
    
    // 꾸물거림 여부
    var isLate = ObservablePattern<Bool>(false)
    
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
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a h:mm"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        let currentTimeString = dateFormatter.string(from: Date())
        
        return currentTimeString
    }
}

extension ReadyStatusViewModel {
    func convertMinute() {
        let preparationHours = (self.myReadyStatus.value?.preparationTime ?? 0) / 60
        let preparationMinutes = (self.myReadyStatus.value?.preparationTime ?? 0) % 60
        
        readyTime.value = preparationHours == 0 ? "\(preparationMinutes)분" : "\(preparationHours)시간 \(preparationMinutes)분"
        
        let travelHours = (self.myReadyStatus.value?.travelTime ?? 0) / 60
        let travelMinutes = (self.myReadyStatus.value?.travelTime ?? 0) % 60
        
        moveTime.value = travelHours == 0 ? "\(travelMinutes)분" : "\(travelHours)시간 \(travelMinutes)분"
    }
    
    func calculatePrepareTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let promiseTime = self.myReadyStatus.value?.promiseTime ?? ""
        let readyTime = self.myReadyStatus.value?.preparationTime ?? 0
        let moveTime = self.myReadyStatus.value?.travelTime ?? 0
        
        
        guard let promiseDate = dateFormatter.date(from: promiseTime) else {
            print("Invalid date format: \(promiseTime)")
            return
        }
        
        let totalPrepTime = TimeInterval((readyTime + moveTime) * 60)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH시 mm분"
        timeFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        print("약속 시간: \(timeFormatter.string(from: promiseDate))")
        print("준비 시간: \(readyTime) 분")
        print("이동 시간: \(moveTime) 분")
        print("총 준비 시간: \(totalPrepTime / 60) 분")
        
        let readyStartTime = promiseDate.addingTimeInterval(-TimeInterval(readyTime + moveTime + 10) * 60)
        let moveStartTime = promiseDate.addingTimeInterval(-TimeInterval(moveTime + 10) * 60)
        
        self.readyStartTime.value = timeFormatter.string(from: readyStartTime)
        print("준비 시작 시간: \(self.readyStartTime.value)")

        self.moveStartTime.value = timeFormatter.string(from: moveStartTime)
        print("이동 시작 시간: \(self.moveStartTime.value)")
    }

    func checkLate(settingTime: String, realTime: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "HH시 mm분"
        
        let readyStartDate = dateFormatter.date(from: settingTime)
        
        dateFormatter.dateFormat = "a h:mm"
        
        let preparationStartDate = dateFormatter.date(from: realTime)

        if let readyStartDate = readyStartDate, let preparationStartDate = preparationStartDate {
            if preparationStartDate.compare(readyStartDate) == .orderedDescending {
                self.isLate.value = true
            } else {
                self.isLate.value = true
            }
        } else {
            self.isLate.value = false
        }
    }

    
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
    
    func updatePreparationStatus() {
        Task {
            do {
                let responseBody = try await readyStatusService.updatePreparationStatus(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
                DispatchQueue.main.async {
                    self.checkLate(
                        settingTime: self.moveStartTime.value,
                        realTime: self.myReadyStatus.value?.departureAt ?? ""
                    )
                }
            }
        }
    }
    
    func updateDepartureStatus() {
        Task {
            do {
                let responseBody = try await readyStatusService.updateDepartureStatus(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
                DispatchQueue.main.async {
                    self.checkLate(
                        settingTime: self.moveTime.value,
                        realTime: self.myReadyStatus.value?.preparationStartAt ?? ""
                    )
                }
            }
        }
    }
    
    func updateArrivalStatus() {
        Task {
            do {
                let responseBody = try await readyStatusService.updateArrivalStatus(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
            }
        }
    }
}
