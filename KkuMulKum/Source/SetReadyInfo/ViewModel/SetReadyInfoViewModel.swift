//
//  SetReadyInfoViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/15/24.
//

import Foundation
import UserNotifications

final class SetReadyInfoViewModel {
    let promiseID: Int
    let promiseName: String
    let promiseTime: String
    
    let isValid = ObservablePattern<Bool>(false)
    let errMessage = ObservablePattern<String>("")
    let isSucceedToSave = ObservablePattern<Bool>(false)
    

    var readyHour = ObservablePattern<String>("")
    var readyMinute = ObservablePattern<String>("")
    var moveHour = ObservablePattern<String>("")
    var moveMinute = ObservablePattern<String>("")
    
    var preparationTime = ObservablePattern<Int>(0)
    var travelTime = ObservablePattern<Int>(0)
    
    var storedReadyHour: Int = 0
    var storedReadyMinute: Int = 0
    var storedMoveHour: Int = 0
    var storedMoveMinute: Int = 0

    let bufferTime: TimeInterval = 10 * 60
    
    var readyTime: Int = 0
    var moveTime: Int = 0
    
    private let service: SetReadyStatusInfoServiceType
    private let notificationManager: LocalNotificationManager
    
    init(
        promiseID: Int,
        promiseTime: String,
        promiseName: String,
        service: SetReadyStatusInfoServiceType,
        notificationManager: LocalNotificationManager = LocalNotificationManager.shared
    ) {
        self.promiseID = promiseID
        self.promiseName = promiseName
        self.promiseTime = promiseTime
        self.service = service
        self.notificationManager = notificationManager
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
        let readyHours = Int(readyHour.value) ?? storedReadyHour
        let readyMinutes = Int(readyMinute.value) ?? storedReadyMinute
        let moveHours = Int(moveHour.value) ?? storedMoveHour
        let moveMinutes = Int(moveMinute.value) ?? storedMoveMinute
        
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
    
    func checkValid(readyHourText: String,
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
        calculateTimes()
        
        // 로컬 알림 설정
        scheduleLocalNotification()
        
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
    
    private func scheduleLocalNotification() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
       
        guard let promiseDate = dateFormatter.date(from: self.promiseTime) else {
            print("Invalid date format: \(self.promiseTime)")
            return
        }
        
        let totalPrepTime = TimeInterval((self.readyTime + self.moveTime) * 60)
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        timeFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        print("약속 시간: \(timeFormatter.string(from: promiseDate))")
        print("준비 시간: \(self.readyTime) 분")
        print("이동 시간: \(self.moveTime) 분")
        print("총 준비 시간: \(totalPrepTime / 60) 분")
        
        let readyStartTime = promiseDate.addingTimeInterval(-(totalPrepTime + bufferTime))
        let moveStartTime = promiseDate.addingTimeInterval(-(TimeInterval(self.moveTime * 60) + bufferTime))
        
        print("준비 시작 시간: \(timeFormatter.string(from: readyStartTime))")
        print("이동 시작 시간: \(timeFormatter.string(from: moveStartTime))")
        
        self.notificationManager.requestAuthorization { [weak self] granted in
            guard let self = self else { return }
            if granted {
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    print("현재 알림 설정: \(settings)")
                }
                
                self.notificationManager.removeAllPendingNotifications()
                
                self.notificationManager.scheduleNotification(
                    title: "준비 시작",
                    body: "\(self.promiseName) 약속 준비를 시작할 시간입니다!",
                    triggerDate: readyStartTime,
                    identifier: "readyStart_\(self.promiseID)"
                ) { error in
                    if let error = error {
                        print("준비 시작 알림 설정 실패: \(error)")
                    } else {
                        print("준비 시작 알림이 \(timeFormatter.string(from: readyStartTime))에 설정되었습니다.")
                    }
                }
                
                self.notificationManager.scheduleNotification(
                    title: "이동 시작",
                    body: "\(self.promiseName) 약속 장소로 이동할 시간입니다!",
                    triggerDate: moveStartTime,
                    identifier: "moveStart_\(self.promiseID)"
                ) { error in
                    if let error = error {
                        print("이동 시작 알림 설정 실패: \(error)")
                    } else {
                        print("이동 시작 알림이 \(timeFormatter.string(from: moveStartTime))에 설정되었습니다.")
                    }
                }
                
                self.notificationManager.getPendingNotifications { requests in
                    print("예정된 알림 수: \(requests.count)")
                    for request in requests {
                        if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                           let nextTriggerDate = trigger.nextTriggerDate() {
                            print("알림 ID: \(request.identifier), 예정 시간: \(timeFormatter.string(from: nextTriggerDate))")
                        }
                    }
                }
            } else {
                print("알림 권한이 허용되지 않았습니다.")
            }
        }
    }
}
