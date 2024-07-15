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
    
    func updateTime(textField: String, time: String) {
        guard let time = Int(time) else { return }
        
        switch textField {
        case "readyHour":
            if (0...23).contains(time) {
                readyHour.value = String(time)
            } else {
                readyHour.value = "23"
                errMessage.value = "시간은 23시간 59분까지만 입력할 수 있어요!"
            }
        case "readyMinute":
            if (0...59).contains(time) {
                readyMinute.value = String(time)
            } else {
                readyMinute.value = "59"
                errMessage.value = "시간은 23시간 59분까지만 입력할 수 있어요!"
            }
        case "moveHour":
            if (0...23).contains(time) {
                moveHour.value = String(time)
            } else {
                moveHour.value = "23"
                errMessage.value = "시간은 23시간 59분까지만 입력할 수 있어요!"
            }
        case "moveMinute":
            if (0...59).contains(time) {
                moveMinute.value = String(time)
            } else {
                moveMinute.value = "59"
                errMessage.value = "시간은 23시간 59분까지만 입력할 수 있어요!"
            }
        default:
            break
        }
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
