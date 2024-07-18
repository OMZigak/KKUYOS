//
//  SetReadyInfoViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/15/24.
//

import Foundation

final class SetReadyInfoViewModel {
    let promiseID: Int
    let promiseTime: String
    
    let isValid = ObservablePattern<Bool>(false)
    let errMessage = ObservablePattern<String>("")
    
    let readyHour = ObservablePattern<String>("")
    let readyMinute = ObservablePattern<String>("")
    let moveHour = ObservablePattern<String>("")
    let moveMinute = ObservablePattern<String>("")
    let isSucceedToSave = ObservablePattern<Bool>(false)
    
    var readyTime: Int = 0
    var moveTime: Int = 0
    
    private let service: SetReadyStatusInfoServiceType
    
    init(
        promiseID: Int,
        promiseTime: String,
        service: SetReadyStatusInfoServiceType
    ) {
        self.promiseID = promiseID
        self.promiseTime = promiseTime
        self.service = service
    }
    
    private func validTime(time: Int, range: ClosedRange<Int>, defaultValue: String) -> String {
        if range.contains(time) {
            return String(time)
        } else {
            errMessage.value = "시간은 23시간 59분까지만 입력할 수 있어요!"
            return defaultValue
        }
    }
    
    private func calculateTimes() {
        let readyHours = Int(readyHour.value) ?? 0
        let readyMinutes = Int(readyMinute.value) ?? 0
        let moveHours = Int(moveHour.value) ?? 0
        let moveMinutes = Int(moveMinute.value) ?? 0
        
        readyTime = readyHours * 60 + readyMinutes
        moveTime = moveHours * 60 + moveMinutes
    }
    
    func updateTime(textField: String, time: String) {
        guard let time = Int(time) else { return }
        
        switch textField {
        case "readyHour":
            readyHour.value = validTime(time: time, range: 0...23, defaultValue: "23")
        case "readyMinute":
            readyMinute.value = validTime(time: time, range: 0...59, defaultValue: "59")
        case "moveHour":
            moveHour.value = validTime(time: time, range: 0...23, defaultValue: "23")
        case "moveMinute":
            moveMinute.value = validTime(time: time, range: 0...59, defaultValue: "59")
        default:
            break
        }
        
        calculateTimes()
    }
    
    func checkValid(
        readyHourText: String,
        readyMinuteText: String,
        moveHourText: String,
        moveMinuteText: String
    ) {
        if !readyHourText.isEmpty && !readyMinuteText.isEmpty
            && !moveHourText.isEmpty && !moveMinuteText.isEmpty {
            isValid.value = true
        } else {
            isValid.value = false
        }
    }
    
    func updateReadyInfo() {
        // 확인 버튼이 눌렸을 때
        // 1. 로컬 알림 만들기
        // 2. 서버에 입력받은 거 전송하기
        // TODO: 지훈이가 만들어준 로컬 알림 만드는 객체에 요청하기 <- 객체가 필요 <- 생성자 주입
        /// 생성자 또는 메서드 전달인자 - promiseID, promiseTime, readyTime, moveTime
        
        Task {
            let model = MyPromiseReadyInfoModel(
                preparationTime: readyTime,
                travelTime: moveTime
            )
            
            do {
                guard let responseBody = try await service.updateMyPromiseReadyStatus(
                    with: promiseID,
                    requestModel: model
                ) else {
                    isSucceedToSave.value = false
                    return
                }
                isSucceedToSave.value = responseBody.success
            } catch {
                print(">>> \(error.localizedDescription) : \(#function)")
            }
        }
    }
}
