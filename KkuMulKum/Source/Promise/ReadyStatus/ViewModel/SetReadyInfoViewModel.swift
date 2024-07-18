//
//  SetReadyInfoViewModel.swift
//  KkuMulKum
//
//  Created by 예삐 on 7/15/24.
//

import Foundation

final class SetReadyInfoViewModel {
    var isValid = ObservablePattern<Bool>(false)
    var errMessage = ObservablePattern<String>("")
    
    var readyHour = ObservablePattern<String>("")
    var readyMinute = ObservablePattern<String>("")
    var moveHour = ObservablePattern<String>("")
    var moveMinute = ObservablePattern<String>("")
    
    //TODO: 준비 및 이동 시간 분 단위로 계산
    var readyTime: Int = 0
    var moveTime: Int = 0
    
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
}
