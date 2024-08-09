//
//  PromiseViewModel.swift
//  KkuMulKum
//
//  Created by YOUJIM on 7/9/24.
//

import Foundation

class PromiseViewModel {
    
    
    // MARK: Property

    /// 서버 통신을 위해 생성자로 주입받을 약속 ID
    let promiseID: Int
    
    /// 현재 페이지 인덱스
    let currentPageIndex = ObservablePattern<Int>(0)
    
    /// 약속 정보
    let promiseInfo = ObservablePattern<PromiseInfoModel?>(nil)
    
    /// 우리들의 준비 현황 스택 뷰에 들어갈 정보들
    let participantsInfo = ObservablePattern<[Participant]?>(nil)
   
    /// 나의 준비현황이 담긴 정보
    /// 설령 데이터가 없다하더라도 약속 시간은 담겨있음.
    let myReadyStatus = ObservablePattern<MyReadyStatusModel?>(nil)
    
    /// 현재 준비 상태에 대한 버튼 처리
    let myReadyProgressStatus = ObservablePattern<ReadyProgressStatus>(.none)
    
    /// 준비 시작 시간
    var readyStartTime = ObservablePattern<String>("")
    
    /// 준비 소요 시간
    var readyDuration = ObservablePattern<String>("")
    
    /// 이동 시작 시간
    var moveStartTime = ObservablePattern<String>("")
    
    /// 이동 소요 시간
    var moveDuration = ObservablePattern<String>("")
    
    /// 꾸물거림 여부
    var isLate = ObservablePattern<Bool>(false)
    
    /// 지각자 유무 여부
    var hasTardy: ObservablePattern<Bool> = ObservablePattern<Bool>(false)
    
    /// 약속 시간 지났는지 여부
    var isPastDue: ObservablePattern<Bool> = ObservablePattern<Bool>(false)
    
    /// 벌칙 정보
    var penalty: ObservablePattern<String> = ObservablePattern<String>("")
    
    /// 지각자 목록
    var comers: ObservablePattern<[Comer]> = ObservablePattern<[Comer]>([])
    
    /// 서버로부터 받아올 에러 메시지
    var errorMessage: ObservablePattern<String> = ObservablePattern<String>("")
    
    /// 현재 시간 받아오기 위한 dateFormatter 구헌
    private let dateFormatter = DateFormatter().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.timeZone = TimeZone(identifier: "Asia/Seoul")
        $0.amSymbol = "AM"
        $0.pmSymbol = "PM"
    }
    
    private let service: PromiseServiceProtocol
    
    
    // MARK: Initialize

    init(promiseID: Int, service: PromiseServiceProtocol) {
        self.service = service
        self.promiseID = promiseID
    }
}


// MARK: - Extension

extension PromiseViewModel {
    /// segmentedControl 인덱스 바뀌었을 때 호출되는 함수
    func segmentIndexDidChange(index: Int) {
        currentPageIndex.value = index
    }
    
    /// 우리들의 준비 현황 변동되었을 때 호출되는 함수
    func participantInfosDidChanged(infos: [Participant]) {
        participantsInfo.value = infos
    }
    
    /// 준비 현황 버튼 클릭했을 때 현재 시간 반환하는 함수
    func updateReadyStatusTime() -> String {
        dateFormatter.dateFormat = "a hh:mm"
        
        return dateFormatter.string(from: Date())
    }
    
    /// 꾸물거릴 시간이 없어요 팝업 표시를 위해 지각 여부를 판단하는 함수
    func checkLate(settingTime: String, arriveTime: String) {
        dateFormatter.dateFormat = "HH시 mm분"
        
        let readyStartDate = dateFormatter.date(from: settingTime)
        
        dateFormatter.dateFormat = "a h:mm"
        
        let preparationStartDate = dateFormatter.date(from: arriveTime)
        
        if let readyStartDate = readyStartDate, let preparationStartDate = preparationStartDate {
            self.isLate.value = preparationStartDate.compare(readyStartDate) == .orderedDescending
        }
    }
    
    /// 준비 or 이동 소요 시간 계산하는 함수
    func calculateDuration() {
        let preparationHours = (self.myReadyStatus.value?.preparationTime ?? 0) / 60
        let preparationMinutes = (self.myReadyStatus.value?.preparationTime ?? 0) % 60
        
        readyDuration.value = preparationHours == 0 ? "\(preparationMinutes)분" : "\(preparationHours)시간 \(preparationMinutes)분"
        
        let travelHours = (self.myReadyStatus.value?.travelTime ?? 0) / 60
        let travelMinutes = (self.myReadyStatus.value?.travelTime ?? 0) % 60
        
        moveDuration.value = travelHours == 0 ? "\(travelMinutes)분" : "\(travelHours)시간 \(travelMinutes)분"
    }
    
    /// 준비 or 이동 시작 시간 계산하는 함수
    func calculateStartTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
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
    
    /// 약속 상세 정보 조회 API 구현 함수
    func fetchPromiseInfo(promiseID: Int) {
        Task {
            do {
                let result = try await service.fetchPromiseInfo(with: promiseID)
                
                guard let success = result?.success,
                        success == true
                else {
                    return
                }
                
                promiseInfo.value = result?.data
            }
        }
    }
    
    /// 약속 참여자 목록 API 구현 함수
    func fetchPromiseParticipantList() {
        Task {
            do {
                let responseBody = try await service.fetchPromiseParticipantList(with: promiseID)
                
                guard let success = responseBody?.success, 
                        success == true
                else {
                    return
                }
                
                participantsInfo.value = responseBody?.data?.participants
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 내 준비 현황 API 구현 함수
    func fetchMyReadyStatus() {
        Task {
            do {
                let responseBody = try await service.fetchMyReadyStatus(with: promiseID)
                
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
    
    /// 준비 시작 업데이트 API 구현 함수
    func updatePreparationStatus() {
        Task {
            do {
                let responseBody = try await service.updatePreparationStatus(
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
                        arriveTime: self.myReadyStatus.value?.departureAt ?? ""
                    )
                }
            }
        }
    }
    
    /// 이동 시작 업데이트 API 구현 함수
    func updateDepartureStatus() {
        Task {
            do {
                let responseBody = try await service.updateDepartureStatus(
                    with: promiseID
                )
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
                DispatchQueue.main.async {
                    self.checkLate(
                        settingTime: self.moveDuration.value,
                        arriveTime: self.myReadyStatus.value?.preparationStartAt ?? ""
                    )
                }
            }
        }
    }
    
    /// 도착 완료 업데이트 API 구현 함수
    func updateArrivalStatus() {
        Task {
            do {
                let responseBody = try await service.updateArrivalStatus(
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
    
    /// 약속 지각 상세 조회 API 구현 함수
    func fetchTardyInfo() {
        Task {
            do {
                let responseBody = try await
                service.fetchTardyInfo(with: promiseID)
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    return
                }
                
                guard let data = responseBody?.data else {
                    return
                }
                
                hasTardy.value = data.lateComers.isEmpty
                isPastDue.value = data.isPastDue
                penalty.value = data.penalty
                comers.value = data.lateComers
                
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
    
    /// 약속 완료 API 구현 함수
    func updatePromiseCompletion() {
        Task {
            do {
                let responseBody = try await service.updatePromiseCompletion(with: promiseID)
                
                guard let success = responseBody?.success,
                      success == true
                else {
                    handleError(errorResponse: responseBody?.error)
                    
                    return
                }
            } catch {
                print(">>>>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}

private extension PromiseViewModel {
    func handleError(errorResponse: ErrorResponse?) {
        guard let error = errorResponse else {
            errorMessage.value = "알 수 없는 에러"
            return
        }
        
        switch error.code {
        case 40051:
            errorMessage.value = "도착하지 않은 참여자가 있습니다."
            
        default:
            errorMessage.value = "알 수 없는 에러"
        }
    }
}
